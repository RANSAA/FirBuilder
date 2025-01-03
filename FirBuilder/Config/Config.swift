//
//  Config.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

struct Config {
    //测试目录
    static var appPath:String = getAppPath()

//    static let configPath = appPath + "config/FirBuilderConfig.plist"
//    static let dbPath = appPath + "config/FirBuilderData.db"
    static let configPath = appPath + "config/FirBuilder.plist"
    static let dbPath = appPath + "config/FirBuilder.db"


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
        ParserTool.log("configPath  :\(configPath)")
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
        print("AppPath:\(path)")
        return path
    }


    private static func getServerRoot() -> String{
        return ConfigPlist.shared.url;
    }

    //重新设置serverRoot地址
    static func resetServerRoot(serverRoot:String){
        ConfigPlist.shared.url = serverRoot;
        ConfigPlist.shared.save()
        Config.serverRoot = serverRoot
        ParserTool.log("serverRoot:\(serverRoot)")
    }
}

