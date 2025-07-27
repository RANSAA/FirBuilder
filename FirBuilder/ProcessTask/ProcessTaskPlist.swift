//
//  ProcessTaskPlist.swift
//  FirBuilder
//
//  Created by kimi on 2024/10/7.
//

import Foundation

/**
 用于配置解析ProcessTask.plist文件
 */
class ProcessTaskPlist:CustomStringConvertible {
    static let shared = ProcessTaskPlist()
    
    private var plist:NSDictionary
    
    //环境环境变量
    private(set) var environment:[String:String]
    
    //可执行程序数组
    private(set) var exec:[[String:String]]
    
    private  init() {
        let config = ProcessTaskConfig.shared
        plist = NSDictionary(contentsOfFile: config.processTaskPath) ?? NSDictionary()
        
        //配置环境变量
        //获取系统环境环境变量
        var systemEnv:[String:String] = ProcessInfo.processInfo.environment
        ProcessTask.log("systemEnv:\(systemEnv)")
        //读取ProcessTask.plist文件中配置的环境变量
        let plistEnv:[[String:Any]] = plist["environment"] as? [[String:Any]] ?? []
        for dicItem in plistEnv {
            guard let name:String = dicItem["name"] as? String,
                  let values:[String] = dicItem["values"] as? [String],
                  let replace:Bool = dicItem["replace"] as? Bool,
                  let separator:String = dicItem["separator"] as? String
            else {
                ProcessTask.log("ProcessTask.plist environment配置信息解析错误")
                continue
            }
            //替换与体统同名的环境变量
            if replace {
                let value = values.joined(separator: separator)
                systemEnv[name] = value
            }else{//追加与系统同名的环境变量
                let sysValue:String = systemEnv[name] ?? ""
                var sysValues:[String] = sysValue.components(separatedBy: separator)
                sysValues += values
                //去除重复
                let setValue:Set<String> = Set(sysValues)
                let value = Array(setValue).joined(separator: separator)
                systemEnv[name] = value
            }
        }
        environment = systemEnv;
        
        exec = plist["exec"] as! [[String:String]]
        
    }
    
    
     var description: String{
         let msg = """
            environment:\(environment)
            """
        return msg
    }
    
}
