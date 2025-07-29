//
//  ProcessTaskConfig.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/7.
//

import Foundation

/**
 用于管理ProcessTask所需的相关配置  environment  Env
 */
class ProcessTaskConfig:CustomStringConvertible{
    static let shared:ProcessTaskConfig = ProcessTaskConfig()
    
    //资源路径
    let resourcePath:String
    //libs目录路径
    let libsPath:String
    
    //ProcessTask任务执行的临时路径
    let taskTmpPath:String
    //ProcessTask任务执行的日志路径
    let taskLogPath:String
    
    
    //ProcessTask.plist文件路径
    let processTaskPath:String
    
    
    //apktool.jar文件路径
    let apktoolPath:String
    
    //acextract（Assets.car解析工具） 文件路径
    let acextractPath:String
    
    //解压目录
    private(set) var unzipPath:String
    
    private init(){
        resourcePath = (Bundle.main.resourcePath ?? Bundle.main.bundlePath) + "/"
        libsPath = resourcePath + "libs/"
        
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Shell"
        taskTmpPath = "/tmp/ProcessTask/\(appName)/tmp/"
        taskLogPath = "/tmp/ProcessTask/\(appName)/log/"
        unzipPath = taskTmpPath +  "unzip/" //解压目录
        do{
            try FileManager.default.createDirectory(atPath: taskTmpPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: taskLogPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: unzipPath, withIntermediateDirectories: true)
        }catch{
            log(error)
        }
        
        processTaskPath = libsPath + "plist/ProcessTask.plist"
        apktoolPath = libsPath + "jar/apktool.jar"
        acextractPath = libsPath + "acextract/acextract"
        
    }
    
    
    /**
     重置配置信息
     */
    func resetConfig(){
        do{
            try FileManager.default.createDirectory(atPath: taskTmpPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: taskLogPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: unzipPath, withIntermediateDirectories: true)
        }catch{
            log(error)
        }
    }
    
    
    
    var description: String{
        let msg = """
        resourcePath:\(resourcePath)
        libsPath:\(libsPath)
        processTaskPath:\(processTaskPath)
        apktoolPath:\(apktoolPath)
        acextractPath:\(acextractPath)
        taskLogPath:\(taskLogPath)
        taskTmpPath:\(taskTmpPath)
        unzipPath:\(unzipPath)
        """
        return msg
    }
}



//MARK: - Clear
extension ProcessTaskConfig{
    
    /** 只清除Process产生的垃圾文件，一般只在App添加成功之后清除 */
    func clearTmp(){
        try? FileManager.default.removeItem(atPath: unzipPath)

        let user = ProcessTaskPlist.shared.environment["USER"] ?? "kimi"
        let apktoolResourcePath = "/Users/\(user)/Library/apktool/framework"
        try? FileManager.default.removeItem(atPath: apktoolResourcePath)
    }
    
    /** 清除程序上一次运行所产生的日志文件,通常在应用启动时清除*/
    func clearLog(){
        try? FileManager.default.removeItem(atPath: taskLogPath)
        try? FileManager.default.removeItem(atPath: taskTmpPath)
    }
}
