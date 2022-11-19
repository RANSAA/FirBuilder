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
    var blockFail:ParserBlock?
    var blockSuccess:ParserBlock?
    var blockMsg:ParserBlock?
    
    func parserStart(path:String){
        blockStart?("开始解析:\(path)")
        
        let type = ParserType.checkType(path: path)
        switch type {
        case .unknown:
            blockFail?("解析错误，文件不存在或者不支持改格式。 file：\(path)")
        case .ios, .android:
            let unzip = UnZipApp()
            unzip.start(path:path, type:type)
        }
    }
}

extension ParserTool{
    /** 清除解析垃圾*/
    static func clean(){
       try? FileManager.default.removeItem(atPath: Config.unzipPath)
    }
    
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
            log(error)
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
            log(error)
        }
    }
}
