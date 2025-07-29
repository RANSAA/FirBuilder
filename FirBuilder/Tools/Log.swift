//
//  Log.swift
//  FirBuilder
//
//  Created by kimi on 2025/7/29.
//


/**
 日志管理工具
 */
import Foundation




//自定义日志配置
fileprivate final class LogConfig{
    static let shared = LogConfig()
    
    //日志文件
    private(set) var logPath:String
    private(set) var logFileHandle:FileHandle?
    
    //执行时间字符串
    private let dayStr:String
    
    init() {
        Self.createDirectory()
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd-HH:mm:ss"
        dayStr = dateFormat.string(from: Date())
        
        logPath = ProcessTaskConfig.shared.taskLogPath + dayStr + ".log"
        if !FileManager.default.fileExists(atPath: logPath){
            FileManager.default.createFile(atPath: logPath, contents: nil)
        }
        
        logFileHandle = FileHandle(forWritingAtPath: logPath)
    }
    
    /** 根据条件重设文件句柄*/
    fileprivate func reset(){
        if !FileManager.default.fileExists(atPath: logPath) {
            FileManager.default.createFile(atPath: logPath, contents: nil)
            do{
                try logFileHandle?.close()
            }catch{
                print("LogConfig logFileHandle?.close()失败!")
            }
            logFileHandle = FileHandle(forWritingAtPath: logPath)
        }
    }
    
    //删除日志文件
    func delete(){
        do{
            try logFileHandle?.close()
        }catch{
            print("LogConfig logFileHandle?.close()失败!")
        }
        
        do {
            try FileManager.default.removeItem(atPath: logPath)
        } catch  {
            print("LogConfig logPath删除失败，logPath：\(logPath)")
        }
    }
    
    private static func createDirectory(){
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Shell"
        let taskTmpPath = "/tmp/ProcessTask/\(appName)/tmp/"
        let taskLogPath = "/tmp/ProcessTask/\(appName)/log/"
        do{
            try FileManager.default.createDirectory(atPath: taskTmpPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: taskLogPath, withIntermediateDirectories: true)
        }catch{
            print(error)
        }
    }
}

func log(_ msg:String...){
    let info = msg.joined(separator: " ")
    print(info)
    LogConfig.shared.reset()
    let handle = LogConfig.shared.logFileHandle
    let data = info.data(using: .utf8)!
    handle?.seekToEndOfFile()
    handle?.write(data)
    handle?.seekToEndOfFile()
    handle?.write("\n".data(using: .utf8)!)
}

func log(_ msg:[Any]){
    let info = "\(msg)"
    log(info)
}

func log(_ msg:Any){
    let info = "\(msg)"
    log(info)
}
