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
    
    private init(){
        resourcePath = (Bundle.main.resourcePath ?? Bundle.main.bundlePath) + "/"
        libsPath = resourcePath + "libs/"
        
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Shell"
        taskTmpPath = "/tmp/ProcessTask/\(appName)/tmp/"
        taskLogPath = "/tmp/ProcessTask/\(appName)/log/"
        do{
            try FileManager.default.createDirectory(atPath: taskTmpPath, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: taskLogPath, withIntermediateDirectories: true)
        }catch{
            print(error)
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
        }catch{
            print(error)
        }
    }
    
    
    
    var description: String{
        let msg = """
        resourcePath:\(resourcePath)
        libsPath:\(libsPath)
        taskTmpPath:\(taskTmpPath)
        taskLogPath:\(taskLogPath)
        processTaskPath:\(processTaskPath)
        apktoolPath:\(apktoolPath)
        acextractPath:\(acextractPath)
        """
        return msg
    }
}
