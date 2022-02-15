//
//  APKParser.swift
//  FirBuilder
//
//  Created by PC on 2022/2/13.
//

import Foundation
import SSZipArchive
import Yaml
import SwiftyXMLParser
import SWXMLHash
import KissXML

import WCDBSwift

import HandyJSON
import KakaJSON

import SDWebImage
import SDWebImageWebPCoder
class APKParser:NSObject{
    let manager:ParserManager
    let path:String

    required init(_ path: String, manager:ParserManager) {
        self.path = path
        self.manager = manager
        super.init()
    }

    func start(){
        upzip()
    }

    func upzip(){
        let outPath = Config.outPath

        //OC使用NSTask
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c","\(Config.apktool) d \"\(path)\" -f -o \(outPath)"]
        task.terminationHandler = { proce in              // 执行结束的闭包(回调)
            print("task执行完毕 proce:\(proce)")
        }

        var lastStr = ""
        //在Swift中,NSPipe 被改名为Pipe
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        //2. 在后台线程等待数据和通知
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        //3. 接受到通知消息
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) { notification in
            //4. 获取管道数据 转为字符串
            let output = outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            if outputString != ""{
                lastStr = outputString
                //5. 在主线程处理UI
                DispatchQueue.main.async(execute: {
                    print("pipe:\(outputString)")
                })

            }
            //6. 继续等待新数据和通知
            outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }

        task.launch()
        task.waitUntilExit()


        let ary = ["I: Copying original files...\n",
                   "I: Copying META-INF/services directory\n"
        ];
        if ary.contains(lastStr) {
            print("apk解析成功")
            parser()
        }else{
            print("错误：不是标准的apk文件")
            manager.openErrorAlert(type: "apk")
        }
    }


    func parser(){
        let ymlPath = Config.outPath + "apktool.yml"
        let xmlPath = Config.outPath + "AndroidManifest.xml"

        if FileManager.default.fileExists(atPath: xmlPath) == false{
            manager.openErrorAlert(msg: xmlPath + "文件不存在")
            return
        }


        let appInfo = AppInfoModel()
        appInfo.type = .android
        appInfo.signType = .release
        appInfo.md5 = FileHash.md5WithPath(path: xmlPath)
        appInfo.appOriginalPath = path
        appInfo.fileSize = FileManager.default.sizeWithFilePath(filePath: path)

        if let yamlStr = try? String(contentsOfFile: ymlPath) {
            do {
                let yamlStr = "#" + yamlStr
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
                print("YAML ERROR:\(error)")
            }
        }

        if let xmlStr = try? String(contentsOfFile: xmlPath) {
            let xml = XMLHash.parse(xmlStr)
            if let bundleID = xml["manifest"][0].element?.attribute(by: "package")?.text {
                appInfo.bundleID = bundleID
            }

            //app name
            if let node = xml["manifest"]["application"][0].element  {
                //@string/a4 -> res/values/strig.xml->a4
                if let name = node.attribute(by: "android:label")?.text {
                    if name.contains("@string") {
                        let namePath = Config.outPath + "res/values/strings.xml"
                        if let nameXmlStr = try? String(contentsOfFile: namePath) {
                            let nameXML = XMLHash.parse(nameXmlStr)
                            let value = name.components(separatedBy: "/").last
                            if let name = try? nameXML["resources"]["string"].withAttribute("name", value!).element?.text {
                                appInfo.name = name
                            }
                        }
                    }else{
                        appInfo.name = name
                    }
                    print("name:\(name)")
                }


                //icon资源路径
                //@mipmap/ic_launcher -> res/mipmap-xxxhdpi/ic_launcher.png
                //@drawable/icon -> res/drawable/icon.png
                let icon = node.attribute(by: "android:icon")?.text ?? ""
                if let icon = node.attribute(by: "android:icon")?.text{
                    if icon.contains("@mipmap") {
                        var iconPath = icon.replacingOccurrences(of: "@mipmap", with: "mipmap-xxxhdpi")
                        iconPath = Config.outPath + "res/" + iconPath + ".png"
                        appInfo.iconOriginalPath  = iconPath
                        print("iconpath:\(iconPath)")
                    }else if icon.contains("@drawable") {
                        var iconPath = icon.replacingOccurrences(of: "@drawable", with: "drawable")
                        iconPath = Config.outPath + "res/" + iconPath + ".png"
                        appInfo.iconOriginalPath  = iconPath
                        print("iconpath:\(iconPath)")
                    }
                }

                print("icon:\(icon)")
            }
        }


        print(appInfo)
        //处理info内部属性,必须执行
//        appInfo.parse()
        manager.updateAppInfo(appInfo)
    }
}
