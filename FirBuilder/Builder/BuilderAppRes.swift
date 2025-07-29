//
//  BuilderAppRes.swift
//  FirBuilder
//
//  Created by PC on 2022/11/18.
//

import Foundation
import KakaJSON
import WCDBSwift

/**
 构建AppInfoModel中的数据信息
 */
struct BuilderAppRes {
    var appInfo:AppInfoModel
    init(appInfo:AppInfoModel) {
        self.appInfo = appInfo
    }
 
    /**
     开始构建AppInfoModel数据信息
     */
    func start(){
          updateAppInfo()
    }
    
    /**
     更新数据库中的app信息
     */
    func updateAppInfo(){
        let fileManager = FileManager.default
        do {
            let srcPath = Config.htmlPath + appInfo.srcRoot!.lowercased()
            ParserTool.createDirectory(atPath: srcPath)
            
            let atPath = appInfo.originalAppPath!
            let toPath = Config.htmlPath + appInfo.srcRoot! + appInfo.appSavePath!
            
            //保存app
            try? fileManager.removeItem(atPath: toPath)
            try fileManager.copyItem(atPath: atPath, toPath: toPath)
            
            //更新数据库
            let db = DBService.shared.db
            defer {
                db.close()
            }
                        
            let jsonString = appInfo.kj.JSONString()
            let homeModel:AppHomeTable = KakaJSON.model(from: jsonString, type: AppHomeTable.self) as! AppHomeTable

            if let query:AppHomeTable = try db.getObject(fromTable: AppHomeTable.tableName,
                                                                where: AppHomeTable.Properties.bundleID == appInfo.bundleID! && AppHomeTable.Properties.type == appInfo.type){
                query.version = appInfo.version;
                query.build = appInfo.build;
                query.name = appInfo.name
                query.updateDate = appInfo.updateDate
                query.logo512Path = appInfo.logo512Path
                try db.insertOrReplace(objects: query, intoTable: AppHomeTable.tableName)
            }else{
                try db.insertOrReplace(objects: homeModel, intoTable: AppHomeTable.tableName)
            }
            
            let releseModel:AppListTable = KakaJSON.model(from: jsonString, type: AppListTable.self) as! AppListTable
            try db.insertOrReplace(objects: releseModel, intoTable: AppListTable.tableName)
            
        } catch  {
            log("updateAppInfo error:\(error)")
            ParserTool.shared.blockFail?("updateAppInfo error:\(error)")
            return
        }
        log("数据库信息更新成功!")
        
        builderRes()
    }
    
    func builderRes(){
        builderImage()
        builderManifest()
        builderHTML()
        
        log("HTML构建完成!")
        ParserTool.shared.blockSuccess?("App 解析完毕!")
    }
    
    //logo
    func builderImage(){
        var originalIconPath = "unkonwn"
        if let iconPath = appInfo.originalIconPath {
            originalIconPath = iconPath
        }
        let logo = ImageTool.loadImageFrom(path: originalIconPath)
        let logo512 = ImageTool.resize(image: logo, size: NSMakeSize(512, 512))
        let logo57 = ImageTool.resize(image: logo, size: NSMakeSize(57, 57))
        let logo512Path = Config.htmlPath + appInfo.srcRoot! + appInfo.logo512Path!
        let logo57Path  = Config.htmlPath + appInfo.srcRoot! + appInfo.logo57Path!
        ImageTool.JPGRepresentation(image: logo512, path: logo512Path)
        ImageTool.JPGRepresentation(image: logo57, path: logo57Path)
    }
    
    //manifest file
    func builderManifest(){
        if appInfo.type == .ios {
            BuilderManifest.builder(appInfo)
        }
    }
    
    
    //生成HTML
    func builderHTML(){
        //生成下载页面
        BuilderDetails().builderDetailsHTML(appInfo)
        
        //new.html
        BuilderDetails().builderNewHTML(appInfo)
        
        //生成list页面
        BuilderList().builder(appInfo)
        
        //生成首页页面
        BuilderAppHome().builder()
    }
    
    /**
     重新生成所有HTML
     */
    static func rebuilderAllHTML(){
        BuilderTemplateFile.builder()

        BuilderAppHome().builder()

        BuilderList().builderAll()

        BuilderDetails().builderAll()

        BuilderManifest().builderAll()
    }
    
}
