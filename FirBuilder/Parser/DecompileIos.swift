//
//  DecompileIos.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/7.
//

import Foundation
import SSZipArchive
import KakaJSON
import Zip


/**
 反编译，解析iOS应用包：.ipa,.tipa
 */
class DecompileIOS{
    //需要反编译的文件路径
    private var filePath:String
    
    //反编译文件存储路径
    private let unZipPath:String
    
    //获取Process任务执行最后一次的终端输出日志
    private var lastStr:String
    
    //用于存储最终的解析数据
    var appInfoModel:AppInfoModel
    
    init(filePath: String) {
        self.filePath = filePath
        self.unZipPath = ProcessTask.shared.unzipPath
        self.lastStr = ""
        
        appInfoModel = AppInfoModel()
        appInfoModel.type = .ios
    }
    
    /** 开始任务 */
    func start(){
        //解压IPA文件
        if SSZipArchive.unzipFile(atPath: filePath, toDestination: unZipPath){
            let payloadPath = unZipPath + "Payload/"
            do {
                let subPaths = try FileManager.default.contentsOfDirectory(atPath: payloadPath).filter({
                    $0.fileExtension.lowercased() == "app" ? true : false
                })
                ProcessTask.log(subPaths)
                if subPaths.count == 0 {
                    let msg = "解析错误:\(payloadPath)中不存在.app"
                    self.blockFail(msg)
                    return
                }
                let appPath = payloadPath+subPaths.first!+"/"
                let msg = "DecompileIOS:Unzip iOS App Path:\(appPath)"
                ProcessTask.log(msg)
                //开始解析所有数据
                self.parserFiles(appPath: appPath)
            } catch  {
                let msg = "DecompileIOS:Payload目录查找失败， error：\(error)"
                self.blockFail(msg)
                return
            }
        }else{
            let msg = "文件解压失败！ file:\(filePath)"
            self.blockFail(msg)
            return
        }
    }
    
    
    private var isInfoPlist = false
    private var isMobileProvision = false
    
    /** 完成*/
    func done(){
        if isInfoPlist && isMobileProvision {
            let msg = "App信息全部解析成功！"
            ProcessTask.log(msg)
        }else{
            let msg = "App信息解析失败，整个添加操作失败！"
            ProcessTask.log(msg)
        }
        
//        let msg = """
//App解析信息:
//        name:\(self.appInfoModel.name ?? "解析失败")
//        bundleID:\(self.appInfoModel.bundleID ?? "解析失败")
//        version:\(self.appInfoModel.version ?? "解析失败")
//        build:\(self.appInfoModel.build ?? "解析失败")
//        minSdkVersion:\(self.appInfoModel.minSdkVersion ?? "解析失败")
//        targetSdkVersion:\(self.appInfoModel.targetSdkVersion ?? "解析失败")
//        originalIconPath:\(self.appInfoModel.originalIconPath ?? "解析失败")
//        originalAppPath:\(self.appInfoModel.originalAppPath ?? "解析失败")
//        type:\(self.appInfoModel.type)
//        signType:\(self.appInfoModel.signType)
//        signExpiration:\(self.appInfoModel.signExpiration ?? "解析失败")
//        fileSize:\(self.appInfoModel.fileSize ?? "解析失败")
//"""
//        ProcessTask.log(msg)
    
    }
    
    /**
     解析完毕后必须对AppInfoModel进行数据校验，以确保最终的解析数据完全正确
     */
    func verifyAppInfoModel() -> Bool{
        let success = appInfoModel.verifyAppInfoModel()
        if success == false{
            let msg = "DecompileIOS -> AppInfoModel数据校验失败，中断解析任务。"
            self.blockFail(msg)
        }
        return success
    }
}


extension DecompileIOS{
    
    //操作失败 - 并且执行该方法时，会中断后面的反编译解析任务
    private func blockFail(_ msg:String){
        ProcessTask.log(msg)
        //change
        ParserTool.shared.blockFail?(msg)
    }
    
    //需要给用户提示的回调操作
    private func blockPrompt(_ msg:String){
        ProcessTask.log(msg)
        //change
        ParserTool.shared.blockPrompt?(msg)
    }
    
}


extension DecompileIOS{
    
    /** 开始解析所有具体的文件 */
    private func parserFiles(appPath:String){
        //
        self.appInfoModel.originalAppPath = filePath
        self.appInfoModel.fileSize = FileManager.default.sizeWithFilePath(filePath: filePath)
        
        
        isInfoPlist = parserInfoPlist(appPath: appPath)
        isMobileProvision = parserMobileProvision(appPath: appPath)
    }
    
    
    /** 解析info.plist*/
    private func parserInfoPlist(appPath:String) -> Bool{
        let plistPath = appPath+"Info.plist"
        guard let plist = NSDictionary(contentsOfFile: plistPath) else {
            let msg = "DecompileIOS -> InfoPlist解析失败 -> info.plist加载失败。"
            self.blockFail(msg)
            return false
        }
        //解析info.plist文件
        let obj:IPAInfoPlist = KakaJSON.model(from: plist, type: IPAInfoPlist.self) as! IPAInfoPlist
        ProcessTask.log(obj)
        guard let bundelName = obj.bundleName,
              let bundleID = obj.bundleID,
              let version = obj.version,
              let build = obj.build,
              let minSdkVersion = obj.minSdkVersion,
              let targetSdkVersion = obj.targetSdkVersion
        else{
            let msg = """
            DecompileIOS -> info.plist解析失败，IPAInfoPlist：\(obj)
            """
            self.blockFail(msg)
            return false
        }
        let name:String = obj.name ?? bundelName
        self.appInfoModel.name = name
        self.appInfoModel.bundleID = bundleID
        self.appInfoModel.version = version
        self.appInfoModel.build = build
        self.appInfoModel.minSdkVersion = minSdkVersion
        self.appInfoModel.targetSdkVersion = targetSdkVersion
        
        //icon
        var iconNames:[String] = []
        if let iconFiles = obj.iconFiles{
            iconNames += iconFiles
        }
        if let iconFiles_ipad = obj.iconFiles_ipad{
            iconNames += iconFiles_ipad
        }
        if let iconFiles_1 = obj.iconFiles_1{
            iconNames += iconFiles_1
        }
        iconNames = iconNames.map({ name in
            var name = name.replacingOccurrences(of: "@2x", with: "")
            name = name.replacingOccurrences(of: "@3x", with: "")
            name = name.replacingOccurrences(of: "~ipad", with: "")
            name = name.replacingOccurrences(of: "~iphone", with: "")
            name = name.replacingOccurrences(of: ".png", with: "")
            return name
        })
        ProcessTask.log(iconNames)
        //装载所有可能出现的文件名称数组
        var newIconName:[String] = []
        for name in iconNames {
            newIconName.append(name+".png")
            newIconName.append(name+"@2x.png")
            newIconName.append(name+"@3x.png")
            newIconName.append(name+"@2x~iphone.png")
            newIconName.append(name+"@3x~iphone.png")
            newIconName.append(name+"@2x~ipad.png")
            newIconName.append(name+"@3x~ipad.png")
        }
        
        var iconSize = 0
        var iconRealPath:String? = nil
        var iconFind = false //是否找到有效的图标文件
        //查找符合条件的最大icon图标
        ProcessTask.log("App Icon可能出现的路径：")
        let findMaxIconPath = {
            for name in newIconName{
                let iconPath = appPath+name
                ProcessTask.log(iconPath)
                if FileManager.default.fileExists(atPath: iconPath){
                    iconFind = true
                    let size = FileManager.default.sizeForLocalFilePath(filePath: iconPath)
                    if size > iconSize{
                        iconSize = Int(size)
                        iconRealPath = iconPath
                    }
                }
            }
        }
        findMaxIconPath()
        //没有找到icon图标，现在尝试解压Assets.car文件，然后再重试
        if !iconFind {
            //解析Assets.car到xxx.app主目录
            let assetsPath = appPath + "Assets.car"
            let task = ProcessTask.shared.processAcextract(filePath: assetsPath, ouputPath: appPath)
            do {
                try task.run()
                task.waitUntilExit()
            } catch  {
                let msg = "Assets.car资源解析失败 -> error:\(error)"
                ProcessTask.log(msg)
            }
            //再次查找
            findMaxIconPath()
        }
        
//MARK: - App Icon and OriginalIconPath
        if iconFind, let iconRealPath {
            self.appInfoModel.originalIconPath = iconRealPath
            let msg = "originalIconPath:\(iconRealPath)"
            ProcessTask.log(msg)
        }else{//没有找到有效图标
            let msg = """
            App Icon 图标解析错误
            OriginalAppPath:\(self.appInfoModel.originalAppPath ?? "nil")
            UnZipPath:\(unZipPath)
            """
            self.blockPrompt(msg)
        }
        
        return true
    }
    
    
    
    /**
     解析embedded.mobileprovision文件
     */
    private func parserMobileProvision(appPath:String) -> Bool{
        let embeddedPath = appPath+"embedded.mobileprovision"
        var signType:ParserBuildType = .unknown
        var signExpiration:String?  = "永久有效"
        if FileManager.default.fileExists(atPath: embeddedPath){
            let obj = MobileprovisionFile(filePath: embeddedPath)
            if obj.hasValid{
                switch obj.signType{
                case 1:
                    signType = .xcodeTest
                case 2:
                    signType = .enterprise
                case 3:
                    signType = .adHoc
                default:
                    signType = .unknown
                }
            }else{
                let msg = "DecompileIOS -> embedded.mobileprovision文件解析失败!"
                self.blockFail(msg)
                return false
            }
        }else{//未找到embedded.mobileprovision文件，该App可能是脱壳应用，或者App Store下载的应用
            let metainfo = unZipPath+"META-INF"
            if FileManager.default.fileExists(atPath: metainfo){//App Store下载的应用
                signType = .appStore
                signExpiration = "永久有效"
            }else{//脱壳未签名应用
                signType = .simulator
                signExpiration = "永久有效(脱壳应用)"
            }
        }
        self.appInfoModel.signType = signType
        self.appInfoModel.signExpiration = signExpiration
        return true
    }
    
}
