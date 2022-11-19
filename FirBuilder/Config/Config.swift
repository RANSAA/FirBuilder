//
//  Config.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

struct Config {
    //测试目录
//    static let appPath:String = "/Users/kimi/Desktop/Fir/"
    static var appPath:String = getAppPath()

    static let configPath = appPath + "config/FirBuilderConfig.plist"
    static let dbPath = appPath + "config/FirBuilderData.db"


    static let apktool = getApkToolPath()
    static let templatePath = getTemplatePath()
    static private(set) var serverRoot:String = getServerRoot() //coding git 资源路径


    static var deleteUnzipDir = true  //标记在解析成功之后是否删除Unzip目录
    static let unzipPath = appPath+".unzip/"+random+"/"   //app资源解压路径
//    static let unzipPath = appPath+".unzip/"
    static let htmlPath = appPath + "html/"   //生成的静态HTML资源路径
    static let htmlSyncPath = appPath + "html-sync/" //HTML 同步目录
    static var isSync = false // 是否生成同步目录
    
    private static var _random:String?
    static var random:String{
        if _random == nil {
            _random = "\(arc4random()%1000000)"
        }
       return _random!
//        return "test"
    }


    public static func setup(buildPath:String? = nil, serverRoot:String? = nil, isSync:Bool = false){
        if let buildPath = buildPath {
            appPath = buildPath
        }
        if let serverRoot = serverRoot {
            self.serverRoot = serverRoot
        }
        self.isSync = isSync
        ParserTool.resetLogPath()
        environment()
    }

    private static func environment(){
        //配置输出目录
        ParserTool.createDirectory(atPath: htmlPath)

        //拷贝模板中的资源文件
        BuilderTemplateFile.builder()

        
        //初始化数据库存储信息
        DBService.shared.setup()


        ParserTool.log("Config begin")
        ParserTool.log("buildPath   :"+appPath)
        ParserTool.log("htmlPath    :"+htmlPath)
        ParserTool.log("htmlSyncPath:"+htmlSyncPath)
        ParserTool.log("unzipPath   :\(unzipPath)")
        ParserTool.log("serverRoot  :"+serverRoot)
        ParserTool.log("Config end")
    }

}


extension Config{
    
    private static func getApkToolPath() -> String{
        var apkJar:String = "apktool.jar"
        if let path = Bundle.main.path(forResource: "apktool", ofType: "jar", inDirectory: "libs/jar") {
            apkJar = path
        }
        return apkJar;
    }

    private static func getTemplatePath() -> String{
        var template:String = "libs/Template"
        if let path = Bundle.main.path(forResource: template, ofType: nil) {
            template = path
        }
        if template.last != "/" {
            template += "/"
        }
        return template;
    }

    //获取当前APP的路径
    private static func getAppPath() -> String{
        var path = Bundle.main.bundlePath
        if let index = path.lastIndex(of: "/") {
            let startIndex = path.startIndex
            path = String(path[startIndex...index])
        }
        if path.last != "/" {
            path += "/"
        }
        path += "FirBuilder/"
        return path
    }


    private static func getServerRoot() -> String{
        let orgUrl = "https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/"
        let orgConfig = NSMutableDictionary(dictionaryLiteral: ("url",orgUrl),
                                            ("urlMark","腾讯Coding仓库主地址，用来提供资源存储路径，可设置为知己的coding仓库路径")
                                            )
        if FileManager.default.fileExists(atPath: Config.configPath) {
            if let config = NSMutableDictionary(contentsOfFile: configPath) {
                if let url = config["url"] as? String {
                    if url.hasPrefix("https") {
                        return url
                    }
                }
                let tmpConfig = config
                tmpConfig["url"] = orgUrl
                tmpConfig.write(toFile: Config.configPath, atomically: true)
            }else{
                orgConfig.write(toFile: Config.configPath, atomically: true)
            }
            return orgUrl
        }else{
            orgConfig.write(toFile: Config.configPath, atomically: true)
            return orgUrl
        }
    }

    //重新设置serverRoot地址
    static func resetServerRoot(serverRoot:String){
        var config:NSMutableDictionary?
        if !FileManager.default.fileExists(atPath: Config.configPath) {
            config = NSMutableDictionary(dictionaryLiteral: ("url",serverRoot),
                                  ("urlMark","腾讯Coding仓库主地址，用来提供资源存储路径，可设置为知己的coding仓库路径")
                                  )
        }else{
            config = NSMutableDictionary(contentsOfFile: configPath)
        }
        config?.setValue(serverRoot, forKey: "url")
        Config.serverRoot = serverRoot
        config!.write(toFile: Config.configPath, atomically: true)
        ParserTool.log("serverRoot:\(serverRoot)")

    }
}

