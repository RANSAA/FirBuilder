//
//  Config.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

struct Config {
    static let appPath:String = getAppPath()
//    static let appPath:String = "/Users/kimi/Desktop/Fir/"
    static let configPath = appPath + "FirBuilderConfig.plist"
    static let dbPath = appPath + "FirBuilderData.db"
    static var apktool = "/usr/local/Cellar/apktool/2.6.0/bin/apktool"
    static private(set) var serverRoot:String = "" //coding git 资源路径
    static let outPath = "/Users/kimi/Desktop/Fir/Unzip/"   //app资源解压路径
    static let syncPath:String = appPath + "/sync/"    //h5同步仓库目录


    public static func setup(){
        print(Config.appPath)

        checkCofigFile()
        checkSrcTemplate()

        DBService.createTable()
    }    
}


extension Config{
    //获取当前APP的路径
    private static func getAppPath() -> String{
        var path = CommandLine.arguments[0]
        var index = path.lastIndex(of: "/")
        path = String(path[..<index!])
        index = path.lastIndex(of: "/")
        path = String(path[..<index!])
        index = path.lastIndex(of: "/")
        path = String(path[..<index!])
        index = path.lastIndex(of: "/")
        path = String(path[...index!])
        return path
    }

    //FirBuilder.plist配置文件解析
    private static func checkCofigFile(){
        let orgUrl = "https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/"
        var tmpUrl:String = ""
        var config:NSMutableDictionary?
        if FileManager.default.fileExists(atPath: Config.configPath) {
            config = NSMutableDictionary(contentsOfFile: configPath)
            if let url = config?["url"] as? String {
                if url.count > 7 {
                    tmpUrl = url
                }
            }

            if let apktool = config?["apktool"] as? String {
                Config.apktool = apktool
            }

        }else{
            config = NSMutableDictionary(dictionaryLiteral: ("url",orgUrl),
                                  ("urlMark","腾讯Coding仓库主地址，用来提供资源存储路径，可设置为知己的coding仓库路径"),
                                  ("apktool",Config.apktool),
                                  ("apktoolMark","apktool工具的路径，可设置为自己的位置")
                                  )
            tmpUrl = orgUrl
        }


        var valid = false
        if tmpUrl.count > 7 {
            let endIndex =  tmpUrl.index(tmpUrl.startIndex, offsetBy: 4)
            let hexf:String = String(tmpUrl[...endIndex])
            if hexf == "https" && tmpUrl.last == "/" {
                valid = true
            }
        }

        if valid == false {
            tmpUrl = orgUrl
            print("FirBuilderConfig.plist url配置不正确，直接读取默认值：\(orgUrl)")
        }

        config?.setValue(tmpUrl, forKey: "url")
        config!.write(toFile: Config.configPath, atomically: true)
        Config.serverRoot = tmpUrl
    }


    //重新设置serverRoot地址
    static func resetServerRoot(serverRoot:String){
        var config:NSMutableDictionary?
        if !FileManager.default.fileExists(atPath: Config.configPath) {
            config = NSMutableDictionary(dictionaryLiteral: ("url",serverRoot),
                                  ("urlMark","腾讯Coding仓库主地址，用来提供资源存储路径，可设置为知己的coding仓库路径"),
                                  ("apktool",Config.apktool),
                                  ("apktoolMark","apktool工具的路径，可设置为自己的位置")
                                  )
        }else{
            config = NSMutableDictionary(contentsOfFile: configPath)
        }
        config?.setValue(serverRoot, forKey: "url")
        Config.serverRoot = serverRoot
        config!.write(toFile: Config.configPath, atomically: true)
        print("serverRoot:\(serverRoot)")
    }
}



extension Config{
    static func checkSrcTemplate(){
        if let path =  Bundle.main.path(forResource: "Template", ofType: nil){
            let srcPath = path + "/src/"
            print("srcPath:\(srcPath)")
            let toPath1:String = Config.appPath+"/src/"
            let toPath2:String = Config.syncPath+"/src/"

            if !FileManager.default.fileExists(atPath: toPath1) {
                try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath1)
            }

            if !FileManager.default.fileExists(atPath: toPath2) {
                try? FileManager.default.createDirectory(atPath: Config.syncPath, withIntermediateDirectories: true, attributes: nil)
                try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath2)
            }
        }
    }
}
