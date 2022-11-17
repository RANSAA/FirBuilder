//
//  UnZipApp.swift
//  FirBuilder
//
//  Created by PC on 2022/11/17.
//

import Foundation
import SSZipArchive
import KakaJSON

/**
 解压安装包
 */
struct UnZipApp {
    var unzipPath:String = Config.unzipPath
    var appInfo:AppInfoModel123 = AppInfoModel123()
    
    func start(path:String, type:ParserType){
        appInfo.originalAppPath = path
        if type == .ios {
            unZipIos(path: path)
        }else{
            unZipAndroid(path: path)
        }
    }
}

//解压iOS
extension UnZipApp{
    
    func unZipIos(path:String){
        if SSZipArchive.unzipFile(atPath: path, toDestination: unzipPath) == true {
            let unZipPath = Config.unzipPath+"Payload/"
            do {
                let subpaths = try FileManager.default.contentsOfDirectory(atPath: unZipPath).filter{
                    $0.fileExtension.lowercased() == "app" ? true : false
                }
                print(subpaths)
                if subpaths.count == 0 {
                    ParserTool.shared.blockFail?("解析错误:\(unZipPath) 中不存在app")
                    return
                }
                let appPath = unZipPath+subpaths.first!+"/"
                print("ios unzip path: \(appPath)")
                
                parserInfoPlist(appPath:appPath)
                
            } catch  {
                ParserTool.shared.blockFail?("\(error)")
            }
        }else{
            ParserTool.shared.blockFail?("解压失败")
        }
    }
    
    //info.plist
    func parserInfoPlist(appPath:String){
        let plistPath = appPath+"Info.plist"
        if FileManager.default.fileExists(atPath: plistPath) {
            guard let plist = NSDictionary(contentsOfFile: plistPath) else {
                ParserTool.shared.blockFail?("解析错误，info.plist加载失败。")
                return
            }
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
            if let appOriginalPath = appInfo.originalAppPath {
                appInfo.fileSize = FileManager.default.sizeWithFilePath(filePath: appOriginalPath)
            }
            
            var iconName:String?
            if obj.iconFiles?.first != nil{
                iconName = obj.iconFiles!.last!
            }else if(obj.iconFiles_ipad?.first != nil){
                iconName = obj.iconFiles_ipad!.last!
            }
            if let icon = iconName, let items = try? FileManager.default.contentsOfDirectory(atPath: appPath){
                for item in items {
                    if item.contains(icon) || item.contains(icon+"@") {
                        appInfo.originalIconPath = appPath+item
                        print(appInfo.originalIconPath!)
                        break
                    }
                }
            }
            if appInfo.originalIconPath == nil {
                print("警告：图标未找到，直接使用一张空的占位图。")
            }
        }else{
            ParserTool.shared.blockFail?("解析错误，info.plist文件不存在。")
            return
        }
        
        
        let embedded = parserEmbedded(appPath:appPath)
        print("签名类型:\(embedded.type)")
        print("到期时间:\(embedded.lastTime)")
        print("设备列表:\(embedded.devices)")
        
        appInfo.devices = embedded.devices
        appInfo.signType = embedded.type
        appInfo.signExpiration = embedded.lastTime
        printAllIvars(appInfo)
        
        unZipIosDone()
    }
    
    //mobileprovision
    func parserEmbedded(appPath:String) -> (type:ParserBuildType,devices:[String],lastTime:String){
        let mobPath = appPath+"embedded.mobileprovision"
        if FileManager.default.fileExists(atPath: mobPath) {
            let obj = ParserEmbedded(filePath: mobPath)
//            printAllIvars(obj)
            var singType:ParserBuildType = .unknown
            if obj.hasValid == true {
                switch obj.signType {
                case 1:
                    singType = .xcodeTest
                case 2:
                    singType = .enterprise
                case 3:
                    singType = .adHoc
                default:
                    singType = .unknown
                }
            }
            return (singType,obj.provisionedDevices,"\(obj.cxpirationDate)")
        }else{
            let metaInf = Config.unzipPath+"META-INF"
            if FileManager.default.fileExists(atPath: metaInf) {
                return (.appStore,[],"永久有效")
            }
            return (.simulator,[],"永久有效")
        }
    }
    
    func unZipIosDone(){
        ParserTool.shared.blockSuccess?("文件解压完毕")
    }
}

//解压Android
extension UnZipApp{
    
    func unZipAndroid(path:String){
        
    }
}
