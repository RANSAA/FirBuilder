//
//  DecompileAndroid.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/7.
//

import Foundation
import SWXMLHash
import KakaJSON
import Yaml
//import SwiftyXMLParser


/**
 反编译Android应用：.apk
 **/
class DecompileAndroid{
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
        appInfoModel.type = .android
    }
    
    
    /** 开始任务 */
    func start(){
        let task = ProcessTask.shared.processApktool(filePath: filePath)
        task.terminationHandler = { proce in              // 执行结束的闭包(回调)
            log("Apktool Task执行完毕! Process:\(proce)")
        }
        
        //创建管道
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        //2. 在后台线程等待数据和通知
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        //3. 接受到通知消息
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) { notification in
            //4. 获取管道数据 转为字符串
            let output = outputPipe.fileHandleForReading.availableData
            if let outputString = String(data: output, encoding: String.Encoding.utf8), outputString.isEmpty == false {
                self.lastStr = outputString
                //5. 在主线程处理UI
                DispatchQueue.main.async(execute: {
                    log("pipe:\(outputString)")
                })
            }
            //6. 继续等待新数据和通知
            outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
        //执行
        do {
            try task.run()
        } catch  {
            let msg = "Apktool Decompile error:\(error)"
            self.blockFail(msg)
            return
        }
        //等待运行结束
        task.waitUntilExit()
        
        //校验
        verify()
    }
    
    
    //校验
    private func verify(){
        /**
         通过apk反编译成功后最后一行log提示可能出现的字符串，判断是否处理成功。
         */
        let msgInfo = [
            "I: Copying original files...\n",
            "I: Copying META-INF/services directory\n"
        ];
        if msgInfo.contains(self.lastStr) {
            log("Android unzip path: \(unZipPath)")
            //开始解析所有数据
            parserFiles()
        }else{
            let msg = "Apktool Decompile 校验失败。"
            self.blockFail(msg)
        }
    }
    
    
    var isApktoolXML = false
    var isAndroidXML = false
    //完成
    func done(){
        if isApktoolXML && isAndroidXML {
            let msg = "App信息全部解析成功！"
            log(msg)
        }else{
            let msg = "App信息解析失败，整个添加操作失败！"
            log(msg)
        }

    }
    
    /**
     解析完毕后必须对AppInfoModel进行数据校验，以确保最终的解析数据完全正确
     */
    func verifyAppInfoModel() -> Bool{
        let success = appInfoModel.verifyAppInfoModel()
        if success == false{
            let msg = "AppInfoModel数据校验失败，中断解析任务。"
            self.blockFail(msg)
        }
        return success
    }
    
}


extension DecompileAndroid{
    
    //操作失败 - 并且执行该方法时，会中断后面的反编译解析任务
    private func blockFail(_ msg:String){
        log(msg)
        //change
        ParserTool.shared.blockFail?(msg)
    }
    
    //需要给用户提示的回调操作
    private func blockPrompt(_ msg:String){
        log(msg)
        //change
        ParserTool.shared.blockPrompt?(msg)
    }

}

extension DecompileAndroid{
    
    /** 开始解析所有具体的文件 */
    private func parserFiles(){
        //
        self.appInfoModel.signType = .release
        self.appInfoModel.signExpiration = "永久有效"
        self.appInfoModel.originalAppPath = filePath
        self.appInfoModel.fileSize = FileManager.default.sizeWithFilePath(filePath: filePath)

        //解析
        self.isApktoolXML = parserApktoolXML()
        self.isAndroidXML = parserAndroidXML()
    }
    
    
    /**
     解析apktool.xml文件获取版本号，构建号
     */
    private func parserApktoolXML() -> Bool{
        let ymlPath = unZipPath + "apktool.yml"
        guard FileManager.default.fileExists(atPath: ymlPath) else{
            blockFail("apktool.yml文件不存在：\(ymlPath)")
            return false;
        }
        guard  let yml =  try? String(contentsOfFile: ymlPath, encoding: .utf8) else {
            blockFail("apktool.yml文件读取失败。")
            return false
        }
//MARK: - Version and Build
        /**
         按行读取：versionCode，versionName,minSdkVersion,targetSdkVersion
         */
        var isVersionName = false
        var isVersionCode = false
        var isMinSdkVersion = false
        var isTargetSdkVersion = false
        let lines = yml.components(separatedBy: .newlines)
        for line in lines {
            if line.contains("versionName"){
                self.appInfoModel.version = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
                isVersionName = true
            }else if line.contains("versionCode"){
                self.appInfoModel.build = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
                isVersionCode = true
            }else if line.contains("minSdkVersion"){
                self.appInfoModel.minSdkVersion = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
                isMinSdkVersion = true
            }else if line.contains("targetSdkVersion"){
                self.appInfoModel.targetSdkVersion = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
                isTargetSdkVersion = true
            }
            
            if isVersionName && isVersionCode && isMinSdkVersion && isTargetSdkVersion {
                break
            }
        }
        return true
    }
    
    /**
     解析AndroidManifest.xml文件，获取App名称，包名，logo图标
     */
    private func parserAndroidXML() -> Bool{
        let xmlPath = unZipPath + "AndroidManifest.xml"
        guard FileManager.default.fileExists(atPath: xmlPath) else{
            self.blockFail("AndroidManifest.xml文件不存在：\(xmlPath)")
            return false;
        }
        //AndroidManifest.xml
        guard let xmlStr =  try? String(contentsOfFile: xmlPath, encoding: .utf8) else {
            self.blockFail("AndroidManifest.xml文件读取失败。")
            return false
        }
        //解析xml文件
        let xml = XMLHash.parse(xmlStr)
        //解析 bundleID
        guard let bundleID = xml["manifest"][0].element?.attribute(by: "package")?.text else {
            self.blockFail("AndroidManifest.xml文件解析失败, 没有正确解析到bundleID")
            return false
        }
//MARK: - BundleID
        self.appInfoModel.bundleID = bundleID
        
        //manifest.application节点
        guard let node = xml["manifest"]["application"][0].element else {
            self.blockFail("AndroidManifest.xml文件解析失败, 没有正确解析到: manifest.application节点")
            return false
        }
        
        //解析App名称
        var appName:String = "unknown";
        self.appInfoModel.name = appName //占位
        //获取AppName的引用名称，方便在values.string文件中找到真实的App名称
        if let tmpName = node.attribute(by: "android:label")?.text {
            appName = tmpName
        }else if let tmpName = node.attribute(by: "n1:label")?.text {
            appName = tmpName
        }
        log("AndroidManifest.xml -> App References Name:\(appName)")
        //@string/a4 -> res/values/strig.xml->a4
        if appName.contains("@string") {//存在引用名称
            //优先解析中文环境下的App名称
            let namePath = unZipPath + "res/values/strings.xml"
            let namePath_ZH = unZipPath + "res/values-zh-rCN/strings.xml"
            //默认环境的App名称
            if let nameXmlStr = try? String(contentsOfFile: namePath),
               let referencesName = appName.components(separatedBy: "/").last
            {
                let nameXML = XMLHash.parse(nameXmlStr)
                //获取App的真实名称
                if let realName = try? nameXML["resources"]["string"].withAttribute("name", referencesName).element?.text {
//MARK: - App Name
                    self.appInfoModel.name = realName;
                    log("res/values/strings.xml -> App Real Name:\(realName)")
                }
            }
            //中文环境的App名称
            if let nameXmlStr = try? String(contentsOfFile: namePath_ZH),
               let referencesName = appName.components(separatedBy: "/").last
            {
                let nameXML = XMLHash.parse(nameXmlStr)
                //获取App的真实名称
                if let realName = try? nameXML["resources"]["string"].withAttribute("name", referencesName).element?.text {
                    self.appInfoModel.name = realName;
                    log("res/values-zh-rCN/strings.xml -> App Real Name:\(realName)")
                }
            }
        }else{//不存在，该值就是App的应用名称
            self.appInfoModel.name = appName
        }
        
        //App Icon
        var icon: String = "unknown";
        if let iconName = node.attribute(by: "android:icon")?.text{
            icon = iconName
        }else if let iconName = node.attribute(by: "n1:icon")?.text{
            icon = iconName
        }else{
            let msg = "AndroidManifest.xml -> App Icon References Name 在已知条件下不存在，提示：发现新的App Icon引用逻辑，请更新App!"
            self.blockPrompt(msg)
        }
        log("AndroidManifest.xml -> App Icon References Name:\(icon)")
       
        /**
         icon资源路径引用类型:
         1. @mipmap/ic_launcher -> res/mipmap-xxxhdpi/ic_launcher.png
         2. @drawable/icon -> res/drawable/icon.png
         3. xxxx/icon -> 图片名不带后缀 -> res/xxxx/icon.png  -> 其中xxxx指res中的未固定路径目录，

         以下是几个常用的图标资源目录，并且存放的图标资源依次变大
         mipmap-mdpi
         mipmap-hdpi
         mipmap-xhdpi
         
         drawable-mdpi
         drawable-hdpi
         drawable-xhdpi
         */
        var otherSubPath:String? = nil
        if !icon.contains("@mipmap") && !icon.contains("@drawable"){
            otherSubPath = icon.replacingOccurrences(of: "@", with: "").components(separatedBy: "/").first ?? "unknown"
        }
        
        icon = icon.replacingOccurrences(of: "@", with: "")
        let icon_last = icon.components(separatedBy: "/").last ?? "unknown";
        //检查icon的引用名称带后缀名没有
        var iconFileNames:[String] = []
        if icon_last.contains("."){//带了
            iconFileNames.append(icon_last)
        }else{//没带
            iconFileNames.append(icon_last+".png")
            iconFileNames.append(icon_last+".jpg")
            iconFileNames.append(icon_last+".jpeg")
            iconFileNames.append(icon_last+".ico")
        }
        //组合icon可能出现的所有子路径，然后从其中挑选一个最大的icon作为最终的icon
        var iconPaths:[String] = []
        for name in iconFileNames {
            iconPaths.append(unZipPath + "res/"+"mipmap-mdpi/"+name)
            iconPaths.append(unZipPath + "res/"+"mipmap-hdpi/"+name)
            iconPaths.append(unZipPath + "res/"+"mipmap-xhdpi/"+name)
            iconPaths.append(unZipPath + "res/"+"drawable-mdpi/"+name)
            iconPaths.append(unZipPath + "res/"+"drawable-hdpi/"+name)
            iconPaths.append(unZipPath + "res/"+"drawable-xhdpi/"+name)
            if  otherSubPath != nil {
                iconPaths.append(unZipPath + "res/"+"\(otherSubPath!)/"+name)
            }
        }
        //查找
        var iconSize = 0
        var iconRealPath:String? = nil
        var iconFind = false //是否找到有效的图标文件
        log("App Icon可能出现的路径：")
        for path in iconPaths {
            log(path)
            if FileManager.default.fileExists(atPath: path){
                iconFind = true
                let size = FileManager.default.sizeForLocalFilePath(filePath: path)
                if size > iconSize {
                    iconSize = Int(size)
                    iconRealPath = path
                }
            }
        }
        if iconFind, let iconRealPath {
//MARK: - App Icon and OriginalIconPath
            self.appInfoModel.originalIconPath = iconRealPath
            let msg = "originalIconPath:\(iconRealPath)"
            log(msg)
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
    
    
    
}
