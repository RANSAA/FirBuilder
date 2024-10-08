//
//  ProcessTask.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/6.
//
/**
 用于执行Process进程任务的工具，例如执行shell脚本。
 */
import Foundation


/**
 封装用于执行进程任务，比如执行shell脚本
 */
class ProcessTask{
    static let shared = ProcessTask()
    
    //解压目录
    private(set) var unzipPath:String
    //日志文件
    private(set) var logPath:String
    //执行时间字符串
    private let dayStr:String
    
    private var logFileHandle:FileHandle?
    
    private init(){
        //确保ProcessTaskConfig初始化配置一定运行过
        //重置一下ProcessTaskConfig的环境
        ProcessTaskConfig.shared.resetConfig()
        print(ProcessTaskConfig.shared)
        
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyyMMdd-HHmmss"
        dayStr = dateFormat.string(from: Date())

        unzipPath = ProcessTaskConfig.shared.taskTmpPath +  "unzip/" //解压目录
        do {
            try FileManager.default.createDirectory(atPath: unzipPath, withIntermediateDirectories: true)
        } catch  {
            print(error)
        }
        logPath = ProcessTaskConfig.shared.taskLogPath + dayStr + ".txt"
        if !FileManager.default.fileExists(atPath: logPath){
            FileManager.default.createFile(atPath: logPath, contents: nil)
        }
        logFileHandle = FileHandle(forWritingAtPath: logPath)
    }
    
    
    
    private func reset(){
        //重置一下ProcessTaskConfig的环境
        ProcessTaskConfig.shared.resetConfig()
        
        unzipPath = ProcessTaskConfig.shared.taskTmpPath +  "unzip/" //解压目录
        do {
            try FileManager.default.createDirectory(atPath: unzipPath, withIntermediateDirectories: true)
        } catch  {
            print(error)
        }
        logPath = ProcessTaskConfig.shared.taskLogPath + dayStr + ".txt"
        if !FileManager.default.fileExists(atPath: logPath){
            FileManager.default.createFile(atPath: logPath, contents: nil)
        }
        logFileHandle = FileHandle(forWritingAtPath: logPath)
    }
    
    
    func process() -> Process{
        let process = Process()
        let url = URL(fileURLWithPath: "/bin/bash")
        process.executableURL = url //或者指定程序的execPath路径，当前是自行shell脚本需要的bash程序，也可执行 /xx/xxx/需要执行的程序.app
        process.environment = ProcessTaskPlist.shared.environment

        //重置数据配置
        reset()
        return process;
    }
    
}


//MARK: - Apktool：Android反编译
extension ProcessTask{
    /**
     获取apktool.jar的
     filePath:需要反编译的apk文件路径
     */
    func processApktool(filePath:String) -> Process{
        let process = process()
        //设置Apktool执行参数
        let config = ProcessTaskConfig.shared
        let apktoolPath = config.apktoolPath
        let arguments = ["-c","java -jar \(apktoolPath) d \"\(filePath)\" -s -f -o \(unzipPath)"]
        process.arguments = arguments
        ProcessTask.log("processApktool -> arguments:\(arguments)")
        return process
    }
}


//MARK: - acextract：Assets.car资源解析工具
extension ProcessTask{
    
    /**
     获取acextract，用于解析Assets.car
     filePath：需要解析的Assets.car资源的路径
     ouputPath：Assets.car资源解析后的输出路径
     */
    func processAcextract(filePath:String, ouputPath:String) -> Process {
        let process = process()
        let url = URL(fileURLWithPath: ProcessTaskConfig.shared.acextractPath)
        process.executableURL = url
        let arguments = ["-i",filePath,"-o",ouputPath]
        process.arguments = arguments
        ProcessTask.log("processAcextract -> arguments:\(arguments)")
        return process
    }
}



extension ProcessTask{
    
 /**
  执行“直接部署到Netlify.command”脚本任务
  */
    func processSyncNetlify() -> Process{
        var netlifyPath:String = "/Volumes/ExData/Remote-ExData/Z---本地工具集/Site-AppStore/直接部署到Netlify-Mac.command"
        for item in ProcessTaskPlist.shared.exec {
            if item["name"] == "直接部署到Netlify"{
                let value = item["path"]!
                netlifyPath = value
                break
            }
        }
        let process = process()
        let arguments = ["-c","open \(netlifyPath)"]
        process.arguments = arguments
        ProcessTask.log("processSyncNetlify -> arguments:\(arguments)")
        if !FileManager.default.fileExists(atPath: netlifyPath){
            let msg = "部署失败！\n文件不存在:\(netlifyPath)"
            ViewController.openPromptAlert(msg: msg)
        }
        return process
    }
    
}










//MARK: - Clear
extension ProcessTask{
    
    /** 只清除Process产生的垃圾文件，一般只在App添加成功之后清除 */
    func clear(){
        try? FileManager.default.removeItem(atPath: unzipPath)

        let user = ProcessTaskPlist.shared.environment["USER"] ?? "kimi"
        let apktoolResourcePath = "/Users/\(user)/Library/apktool/framework"
        try? FileManager.default.removeItem(atPath: apktoolResourcePath)
    }
    
    /** 清除Process产生的所有垃圾文件，日志文件等。*/
    func clearAll(){
        clear()
        try? FileManager.default.removeItem(atPath: ProcessTaskConfig.shared.taskLogPath)
        try? FileManager.default.removeItem(atPath: ProcessTaskConfig.shared.taskTmpPath)
    }
}


//MARK: - 日志输出
extension ProcessTask{
    
    static func log(_ msg:String...){
        let info = msg.joined(separator: " ")
        print(info)
        let handle = ProcessTask.shared.logFileHandle
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
