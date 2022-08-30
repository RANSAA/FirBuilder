//
//  ParseIpa.swift
//  FirBuilder
//
//  Created by PC on 2022/2/13.
//

import Foundation
import SSZipArchive
import KakaJSON


class IPAParser:NSObject{
    var manager:ParserManager!
    var path:String!

    var appInfo:AppInfoModel = AppInfoModel()

    required init(_ path: String) {
        self.manager = nil
        self.path = path
        self.appInfo.type = .ios
        self.appInfo.appOriginalPath = path
        super.init()
    }

    required init(_ path: String, manager:ParserManager) {
        self.path = path
        self.manager = manager
        self.appInfo.type = .ios
        self.appInfo.appOriginalPath = path
        super.init()
    }

    func start(){
        unzip()
    }

    func unzip(){
        let destinationPath = Config.unzipPath
        let success =  SSZipArchive.unzipFile(atPath: self.path, toDestination: destinationPath)
        if success {
            print("ipa解压成功")
            parser()
        }else{
            print("ipa解压失败")
            manager.openErrorAlert(type: "ipa")
        }
    }

    func parser(){
        let unZipPath = Config.unzipPath+"Payload/"
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: unZipPath)
            print(items)
            var subDir:String?
            for node in items {
                if node.fileExtension == FileExtension.app.rawValue {
                    subDir = node
                    break
                }
            }
            if let sub = subDir {
                let appPath = unZipPath+sub+"/"
                //解析.mobileprovision文件
                parserEmbedded(appPath: appPath)

                //先解析描述文件,成功后再解析infoplist文件
                parserInfoPlist(appPath:appPath)

            }else{
                //error
                self.manager.openErrorAlert(msg: "错误：这不是一个正确的ipa文件")
            }
        } catch  {
            print(error)
            self.manager.openErrorAlert(msg: error.localizedDescription)
        }
    }

     func parserInfoPlist(appPath:String){
        let plistPath = appPath+"Info.plist"
        if FileManager.default.fileExists(atPath: plistPath) {
            if let plist =  NSDictionary(contentsOfFile: plistPath){
                let obj:IPAInfoPlist = KakaJSON.model(from: plist, type: IPAInfoPlist.self) as! IPAInfoPlist
                printAllIvars(obj)

                appInfo.bundleID = obj.bundleID
                appInfo.name = obj.name
                if appInfo.name == nil {
                    appInfo.name = obj.bundleName
                }
                appInfo.version = obj.version
                appInfo.build = obj.build
                appInfo.minSdkVersion = obj.minSdkVersion
                appInfo.targetSdkVersion = obj.targetSdkVersion
                appInfo.fileSize = FileManager.default.sizeWithFilePath(filePath: appInfo.appOriginalPath!)

                var iconName:String?
                if obj.iconFiles?.first != nil{
                    iconName = obj.iconFiles!.last!
                }else if(obj.iconFiles_ipad?.first != nil){
                    iconName = obj.iconFiles_ipad!.last!
                }
                if let icon = iconName {
                    if let items = try? FileManager.default.contentsOfDirectory(atPath: appPath) {
                        for item in items {
                            if item.contains(icon) || item.contains(icon+"@") {
                                appInfo.iconOriginalPath = appPath+item
                                print(appInfo.iconOriginalPath!)
                                break
                            }
                        }
                    }
                }

                self.manager.updateAppInfo(appInfo)
            }else{
                self.manager.openErrorAlert(msg: "infoPlist文件解析失败")
            }
        }else{
            self.manager.openErrorAlert(msg: "Plist文件不存在：\(plistPath)")
        }

    }

    func parserEmbedded(appPath:String){
        let mobPath = appPath+"embedded.mobileprovision"
        let obj = ParserEmbedded(filePath: mobPath)
        if obj.hasValid == true {
            if obj.localProvision == true {
                appInfo.signType = .localTest
            }else if obj.provisionsAllDevices == true{
                appInfo.signType = .enterprise
            }else{
                appInfo.signType = .adHoc
                appInfo.devices = obj.provisionedDevices
            }
        }else{
            appInfo.signType = .appStore
        }
    }



}
