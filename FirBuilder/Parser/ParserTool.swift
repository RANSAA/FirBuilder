//
//  ParserTool.swift
//  FirBuilder
//
//  Created by PC on 2022/11/17.
//

import Foundation
import WCDBSwift
import KakaJSON




struct ParserTool {
    static var shared = ParserTool()
    
    //是否有解析任务
    var parsing = false

    typealias ParserBlock = (_ msg:String) -> Void
    var blockStart:ParserBlock?
    var blockSuccess:ParserBlock?
        
    var blockFail:ParserBlock? // ⚠️：新版本中使用
    var blockPrompt:ParserBlock? //只提示，不中断 ⚠️：新版本中使用
    
    func parserStart(path:String){
        //在解析之前清除上一个APP解析产生的垃圾文件
        ProcessTask.shared.clearTmp()
        
        let msg = "开始解析:\(path)"
        ProcessTask.log(msg)
        blockStart?(msg)
        let type = ParserType.checkType(path: path)
        switch type {
        case .unknown:
            let msg = "解析错误，文件不存在或者不支持该格式。 file：\(path)"
            ProcessTask.log(msg)
            blockFail?(msg)
        case .ios, .android:
            parserApp(type: type, filePath: path)
        }
    }
}


extension ParserTool{
    
    private func parserApp(type:ParserType, filePath:String){
        var isSuccess = false
        var appInfoModel:AppInfoModel? = nil
        if type == .ios {
            let ios = DecompileIOS(filePath: filePath)
            ios.start()
            ios.done()
            isSuccess = ios.verifyAppInfoModel()
            appInfoModel = ios.appInfoModel
        }else{
            let anroid = DecompileAndroid(filePath: filePath)
            anroid.start()
            anroid.done()
            isSuccess = anroid.verifyAppInfoModel()
            appInfoModel = anroid.appInfoModel
        }
        
        if isSuccess {
            //构建资源
            let builderRes = BuilderAppRes(appInfo: appInfoModel!)
            builderRes.start()
            
            //在解析之前清除上一个APP解析产生的垃圾文件
//            ProcessTask.shared.clearTmp()
        }else{
            let msg = "App添加失败!!！"
            ProcessTask.log(msg)
            ParserTool.shared.blockFail?(msg)
        }
        ProcessTask.log("\n\n\n")
        //整个App添加流程完毕
    }
    
}



extension ParserTool{
    
    /** 一个解析任务完成时: 清除解析垃圾*/
    static func clean(){
       try? FileManager.default.removeItem(atPath: Config.unzipPath)
    }
    
    /** 退出时：清理.unzip目录
     PS: 未使用，直接使用ProcessTask.shared.clear相关方法清理垃圾
     */
    static func exitClean(){
        let path = Config.appPath + ".unzip"
        do {
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
            print(".unzip清除成功!")
        } catch  {
            print(".unzip清除失败， error:\(error)")
        }
    }
    

    
    //Config.htmlPath
    //Config.htmlSyncPath
    private static var htmlPath:String{
        "html"
    }
    private static var htmlSyncPath:String{
        "html-sync"
    }
    
    
    @discardableResult
    static func save(_ data:Data?, path:String) -> Bool {
        let status = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        if Config.isSync {
            let syncPath = path.replacingOccurrences(of: htmlPath, with: htmlSyncPath)
            FileManager.default.createFile(atPath: syncPath, contents: data, attributes: nil)
        }
        return status
    }
    
    @discardableResult
    static func save(_ string:String?, path:String) -> Bool {
        if let str = string {
            let data = str.data(using: .utf8)
            return save(data, path: path)
        }
        return false
    }
    
    @discardableResult
    static func save(_ dict:NSDictionary?, path:String) -> Bool {
        guard let dict = dict else {
            return false
        }
        
        let status = dict.write(toFile: path, atomically: true)
        if Config.isSync {
            let syncPath = path.replacingOccurrences(of: htmlPath, with: htmlSyncPath)
            dict.write(toFile: syncPath, atomically: true)
        }
        return status
    }
    
    static func createDirectory(atPath path:String){
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            if Config.isSync {
                let syncPath = path.replacingOccurrences(of: htmlPath, with: htmlSyncPath)
                try FileManager.default.createDirectory(atPath: syncPath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch  {
            ProcessTask.log(error)
        }
    }
    
    static func delete(atPath path:String){
        do {
            try FileManager.default.removeItem(atPath: path)
            if Config.isSync {
                let syncPath = path.replacingOccurrences(of: htmlPath, with: htmlSyncPath)
                try FileManager.default.removeItem(atPath: syncPath)
            }
        } catch  {
            ProcessTask.log(error)
        }
    }
}


//弃用
extension ParserTool{
    private static var logPath:String{
        let path = Config.appPath + ".unzip/"
        return path+Config.random+"-parser.log"
    }
    
    static func resetLogPath(){
        let path = Config.appPath + ".unzip/"
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        try? FileManager.default.removeItem(atPath: logPath)
        FileManager.default.createFile(atPath: logPath, contents: Data(), attributes: nil)
    }
    
    static func log(_ msg:String...){
        let info = msg.joined(separator: " ")
        print(info)
        let handle = FileHandle(forWritingAtPath: logPath)
        let data = info.data(using: .utf8)!
        handle?.seekToEndOfFile()
        handle?.write(data)
        handle?.seekToEndOfFile()
        handle?.write("\n".data(using: .utf8)!)
    }
    
    static func log(_ msg:[Any]){
        let info = "\(msg)"
        log(info)
    }
    
    static func log(_ msg:Any){
        let info = "\(msg)"
        log(info)
    }
}

