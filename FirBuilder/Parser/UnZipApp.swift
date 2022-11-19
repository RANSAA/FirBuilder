//
//  UnZipApp.swift
//  FirBuilder
//
//  Created by PC on 2022/11/17.
//

import Foundation
import SSZipArchive
import KakaJSON
import Yaml
import SWXMLHash
//import SwiftyXMLParser
import Zip



/**
 解压安装包
 */
struct UnZipApp {
    var unzipPath:String = Config.unzipPath
    var appInfo:AppInfoModel = AppInfoModel()
    
    func start(path:String, type:ParserType){
        appInfo.originalAppPath = path
        if FileManager.default.fileExists(atPath: path) {
            appInfo.fileSize = FileManager.default.sizeWithFilePath(filePath: path)
        }
        
        if type == .ios {
            unZipIos(path: path)
        }else{
            unZipAndroid(path: path)
        }
    }
    
    func unZipDone(){
        //appinfo内部数据合成
        appInfo.parseInfo()
        
        ParserTool.log("UnZipApp info:")
        ParserTool.log(appInfo)
        
 
        //构建资源
        let builderRes = BuilderAppRes(appInfo: appInfo)
        builderRes.start()

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
                ParserTool.log(subpaths)
                if subpaths.count == 0 {
                    ParserTool.shared.blockFail?("解析错误:\(unZipPath) 中不存在app")
                    return
                }
                let appPath = unZipPath+subpaths.first!+"/"
                ParserTool.log("ios unzip path: \(appPath)")
                
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
            ParserTool.log(obj)
            
            appInfo.bundleID = obj.bundleID
            appInfo.name = obj.name
            if appInfo.name == nil {
                appInfo.name = obj.bundleName
            }
            appInfo.version = obj.version
            appInfo.build = obj.build
            appInfo.minSdkVersion = obj.minSdkVersion
            appInfo.targetSdkVersion = obj.targetSdkVersion
            
            
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
                        ParserTool.log("originalIconPath:\(appInfo.originalIconPath!)")
                        break
                    }
                }
            }
            if appInfo.originalIconPath == nil {
                ParserTool.log("警告：图标未找到，直接使用一张空的占位图。")
            }
        }else{
            ParserTool.shared.blockFail?("解析错误，info.plist文件不存在。")
            return
        }
        
        
        let embedded = parserEmbedded(appPath:appPath)
        ParserTool.log("签名类型:\(embedded.type)")
        ParserTool.log("到期时间:\(embedded.lastTime)")
        ParserTool.log("设备列表:\(embedded.devices)")
        
        appInfo.devices = embedded.devices
        appInfo.signType = embedded.type
        appInfo.signExpiration = embedded.lastTime
        
        unZipDone()
    }
    
    //mobileprovision
    func parserEmbedded(appPath:String) -> (type:ParserBuildType,devices:[String],lastTime:String){
        let mobPath = appPath+"embedded.mobileprovision"
        if FileManager.default.fileExists(atPath: mobPath) {
            let obj = MobileprovisionFile(filePath: mobPath)
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
}

//解压Android
//MARK: - yaml 文件解析注意
/**
 pod 'Yaml'库有bug，
 可以直接通过下面的工具在shell中执行并获取结果
 js-yaml: https://github.com/nodeca/js-yaml
 :先使用js-yaml将yaml文件转换成json，然后在获取数据
 */
extension UnZipApp{
    
    func unZipAndroid(path:String){
        let unZipPath = Config.unzipPath
        var lastStr = ""
        
        let url = URL(fileURLWithPath: "/bin/bash")
        let arguments = ["-c","java -jar \(Config.apktool) d \"\(path)\" -s -f -o \(unZipPath)"]
        
        let task = Process()
        task.executableURL = url
        task.arguments = arguments
        task.terminationHandler = { proce in              // 执行结束的闭包(回调)
            ParserTool.log("apktool task执行完毕 proce:\(proce)")
        }
        
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        //2. 在后台线程等待数据和通知
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        //3. 接受到通知消息
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) { notification in
            //4. 获取管道数据 转为字符串
            let output = outputPipe.fileHandleForReading.availableData
            if let outputString = String(data: output, encoding: String.Encoding.utf8), outputString.isEmpty == false {
                lastStr = outputString
                //5. 在主线程处理UI
                DispatchQueue.main.async(execute: {
                    ParserTool.log("pipe:\(outputString)")
                })
            }
            //6. 继续等待新数据和通知
            outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
        do {
            try task.run()
        } catch  {
            ParserTool.log("apktool error:\(error)")
            ParserTool.shared.blockFail?("apktool.jar 调用失败! error:\(error)")
            return
        }
        task.waitUntilExit()
        
        //apk解包成功后最后一行logo提示可能出现的字符串
        let msgInfo = ["I: Copying original files...\n",
                   "I: Copying META-INF/services directory\n"
        ];
        if msgInfo.contains(lastStr) {
            ParserTool.log("android unzip path: \(unZipPath)")
            parserAndroidXML()
        }else{
            ParserTool.shared.blockFail?("解压失败")
        }
    }
    
    func parserAndroidXML(){
        let ymlPath = Config.unzipPath + "apktool.yml"
        let xmlPath = Config.unzipPath + "AndroidManifest.xml"
        guard FileManager.default.fileExists(atPath: xmlPath) && FileManager.default.fileExists(atPath: ymlPath) else {
            ParserTool.shared.blockFail?("apk解包失败。AndroidManifest.xml或apktool.yml文件不存在")
            return
        }
        
        appInfo.type = .android
        appInfo.signType = .release
        appInfo.signExpiration = "永久有效"
        
        //解析apktool.yml
        if let yamlStr = try? String(contentsOfFile: ymlPath) {
            do {
                //将不规则的yml文件裁剪，PS：Yaml框架有bug
                let find = yamlStr.findFirst("isFrameworkApk")
                let yamlStr = yamlStr.subStringFrom(find)
                let yaml = try Yaml.load(yamlStr)
                if let version = yaml["versionInfo"]["versionName"].string {
                    appInfo.version = version
                }
                if let build = yaml["versionInfo"]["versionCode"].string{
                    appInfo.build = build
                }
                if let minSdkVersion = yaml["sdkInfo"]["minSdkVersion"].string{
                    appInfo.minSdkVersion = minSdkVersion
                }
                if let targetSdkVersion = yaml["sdkInfo"]["targetSdkVersion"].string{
                    appInfo.targetSdkVersion = targetSdkVersion
                }
            } catch {
                ParserTool.shared.blockFail?("apktool.yml文件解析失败，error:\(error)")
            }
        }else{
            ParserTool.shared.blockFail?("apktool.yml文件解析失败，filePath:\(ymlPath)")
        }
        
        
        //AndroidManifest.xml
        guard let xmlStr = try? String(contentsOfFile: xmlPath) else {
            ParserTool.shared.blockFail?("AndroidManifest.xml文件解析失败，filePath:\(xmlPath)")
            return
        }
        let xml = XMLHash.parse(xmlStr)
        //bundleID
        if let bundleID = xml["manifest"][0].element?.attribute(by: "package")?.text {
            appInfo.bundleID = bundleID
        }else{
            ParserTool.shared.blockFail?("AndroidManifest.xml文件解析失败, 没有正确解析到bundleID")
            return
        }
        
        //解析APP Name ，icon
        if let node = xml["manifest"]["application"][0].element  {
            //app name
            var appName:String = "unknown";
            appInfo.name = appName
            if let tmpName = node.attribute(by: "android:label")?.text {
                appName = tmpName
            }else if let tmpName = node.attribute(by: "n1:label")?.text {
                appName = tmpName
            }
            ParserTool.log("AndroidManifest.xml -> app name:\(appName)")
            
            //@string/a4 -> res/values/strig.xml->a4
            if appName.contains("@string") {
                let namePath = Config.unzipPath + "res/values/strings.xml"
                if let nameXmlStr = try? String(contentsOfFile: namePath) {
                    let nameXML = XMLHash.parse(nameXmlStr)
                    let value = appName.components(separatedBy: "/").last
                    if let name = try? nameXML["resources"]["string"].withAttribute("name", value!).element?.text {
                        appInfo.name = name
                        ParserTool.log("res/values/strings.xml -> app name:\(appName)")
                    }
                }
            }else{
                appInfo.name = appName
            }
            
            
            //app icon
            var icon: String = "unknown";
            if let iconName = node.attribute(by: "android:icon")?.text{
                icon = iconName
            }else if let iconName = node.attribute(by: "n1:icon")?.text{
                icon = iconName
            }
            ParserTool.log("icon:\(icon)")
            
            //icon资源路径
            //@mipmap/ic_launcher -> res/mipmap-xxxhdpi/ic_launcher.png
            //@drawable/icon -> res/drawable/icon.png
            // xxxx/xxx -> 图片名不带后缀
            var iconPath = ""
            if icon.contains("@mipmap") {
                iconPath = icon.replacingOccurrences(of: "@mipmap", with: "mipmap-xxxhdpi")
            }else if icon.contains("@drawable") {
                iconPath = icon.replacingOccurrences(of: "@drawable", with: "drawable")
            }
            
            iconPath = Config.unzipPath + "res/" + iconPath //+ ".png"
            if !FileManager.default.fileExists(atPath: iconPath) {
                iconPath += ".png"
            }
            
            guard FileManager.default.fileExists(atPath: iconPath) else {
                let msg = """
                app icon 解析不正确!
                originalAppPath:\(appInfo.originalAppPath!)
                unZipPath:\(Config.unzipPath)
                """
                ParserTool.shared.blockMsg?(msg)
                ParserTool.shared.blockFail?(msg)
                return
            }
            appInfo.originalIconPath  = iconPath
            ParserTool.log("originalIconPath:\(appInfo.originalIconPath!)")
            unZipDone()
        }else{
            ParserTool.shared.blockFail?("AndroidManifest.xml文件解析失败, 没有正确解析到: manifest.application 节点")
            return
        }
        
    }
}
