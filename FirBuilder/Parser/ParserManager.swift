//
//  ParserManager.swift
//  FirBuilder
//
//  Created by PC on 2022/2/13.
//

import Foundation
import SSZipArchive
import Yaml
import SwiftyXMLParser
//import SWXMLHash
//import KissXML

import WCDBSwift

//import HandyJSON
import KakaJSON

import SDWebImage
import SDWebImageWebPCoder


//解析APP
/**
 功能：解析APP
 iOS：使用SSZipArchive解压文件，然后再分析
 Android：使用外部apktool工具反编译apk文件，然后再分析文件
 */
class ParserManager: NSObject {
    var path:String //app path
    var controller:ViewController!

    var startParserDate:Date!
    init(path:String, controller:ViewController){
        self.path = path
        self.controller = controller
        super.init()
    }


    func start(){
        try? FileManager.default.removeItem(atPath: Config.unzipPath)
        startParserDate = Date()
        if path.fileExtension.lowercased() == "ipa" {
            let ipa = IPAParser(path,manager: self)
            ipa.start()
        }else{
            let apk = APKParser(path,manager: self)
            apk.start()
        }
    }

    public func openErrorAlert(type:String){
        controller.openErrorAlert(type: type)
    }

    func openErrorAlert(msg:String){
        controller.openErrorAlert(msg: msg)
    }

    func openParserSuccess(msg: String){
        controller.openParserSuccess(msg: msg)
    }

    public func openNewWindow(){
        controller.openNewWindow()
    }


    func parserCountTime(){
        let endTime = Date()
        let count = endTime.timeIntervalSince(startParserDate!)
        print("解析耗时：\(count)s")
    }
}



extension ParserManager{

    //存储APP信息
    func updateAppInfo(_ appInfo:AppInfoModel){
        //处理info内部属性,必须执行
        appInfo.parse()

        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: Config.htmlPath + appInfo.srcRoot!) == false {
                try fileManager.createDirectory(atPath: Config.htmlPath + appInfo.srcRoot!, withIntermediateDirectories: true, attributes: nil)
            }

            if fileManager.fileExists(atPath: Config.htmlSyncPath + appInfo.srcRoot!) == false {
                try fileManager.createDirectory(atPath: Config.htmlSyncPath + appInfo.srcRoot!, withIntermediateDirectories: true, attributes: nil)
            }

            let atPath = appInfo.appOriginalPath!
            let toPath = Config.htmlPath + appInfo.saveAppPath!

            //保存app
            try? fileManager.removeItem(atPath: toPath)
            try fileManager.copyItem(atPath: atPath, toPath: toPath)


            //更新数据库
            let db = DBService.shared.db
            defer {
                db.close()
            }


            let jsonString = appInfo.kj.JSONString()
            let homeModel:AppHomeListTable = KakaJSON.model(from: jsonString, type: AppHomeListTable.self) as! AppHomeListTable

            if let query:AppHomeListTable = try db.getObject(fromTable: AppHomeListTable.tableName,
                                                                where: AppHomeListTable.Properties.bundleID == appInfo.bundleID! && AppHomeListTable.Properties.type == appInfo.type){
                query.version = appInfo.version;
                query.build = appInfo.build;
                query.name = appInfo.name
                query.updateDate = appInfo.updateDate
//                query.selectedVerPath = appInfo.selectedVerPath //new.html
                try db.insertOrReplace(objects: query, intoTable: AppHomeListTable.tableName)
            }else{
                try db.insertOrReplace(objects: homeModel, intoTable: AppHomeListTable.tableName)
            }

            let releseModel:AppReleaseListTable = KakaJSON.model(from: jsonString, type: AppReleaseListTable.self) as! AppReleaseListTable
            try db.insertOrReplace(objects: releseModel, intoTable: AppReleaseListTable.tableName)



            printAllIvars(appInfo)
            updateSuccess(appInfo)

        } catch {
            print(error)
            openErrorAlert(msg: "向数据库中写入数据失败")
        }
    }


    func updateSuccess(_ appInfo:AppInfoModel){
        builderIamge(appInfo)
        builderManifest(appInfo)
        builderHTML(appInfo)

        parserDone()
    }


    func builderIamge(_ appInfo:AppInfoModel){
        if let decodedImage = decodeImage(path: appInfo.iconOriginalPath!) {

            let fileManager = FileManager.default
            let image:NSImage = decodedImage as NSImage

            //512x512 png
            if let image = image.sd_resizedImage(withSizeFixed: NSMakeSize(512, 512), scaleMode: .aspectFit) {
                if let enData = image.sd_imageData(as: .PNG) {
                    fileManager.createFile(atPath: Config.htmlPath+appInfo.appIconPath!, contents: enData, attributes: nil)

                    //sync file
                    fileManager.createFile(atPath: Config.htmlSyncPath+appInfo.appIconPath!, contents: enData, attributes: nil)
                }
            }

            //57x57 png
            if appInfo.type == .ios {
                if let image = image.sd_resizedImage(withSizeFixed: NSMakeSize(57, 57), scaleMode: .aspectFit) {
                    if let enData = image.sd_imageData(as: .PNG) {
                        fileManager.createFile(atPath: Config.htmlPath+appInfo.appIcon57Path!, contents: enData, attributes: nil)

                        //sync file
                        fileManager.createFile(atPath: Config.htmlSyncPath+appInfo.appIcon57Path!, contents: enData, attributes: nil)
                    }
                }
            }
        }
    }


    func decodeImage(path:String) ->NSImage?{
        let orgImage = NSImage(contentsOfFile: path)
        if orgImage != nil {
            return orgImage
        }
        if let data = try? Data(contentsOf: URL.init(fileURLWithPath: path)) {
            if let decodedImage =  SDImageWebPCoder.shared.decodedImage(with: data, options: nil){
                return decodedImage
            }
        }
        return nil
    }


    func builderManifest(_ appInfo:AppInfoModel){
        BuilderManifest().builder(appInfo)
    }


    func builderHTML(_ appInfo:AppInfoModel){
        //生成下载页面
        BuilderDetails().builder(appInfo)

        //new.html
        BuilderDetails().builderNewHTML(appInfo)

        //生成list页面
        BuilderList().builder(bundleID: appInfo.bundleID!, appType: appInfo.type)

        //生成首页页面
        BuilderAppHome().builder()

    }



    func parserDone(){
        //删除生成的解压目录
        if Config.deleteUnzipDir{
            try? FileManager.default.removeItem(atPath: Config.unzipPath)
        }


        parserCountTime()
        MacProgressHUD.removeAllHUD()

        openParserSuccess(msg: "添加成功")

        DispatchQueue.main.async {
            self.controller.loadDataArray()
        }
    }
}
