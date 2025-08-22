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
        ProcessTaskConfig.shared.clearTmp()
        
        let msg = "开始解析:\(path)"
        log(msg)
        blockStart?(msg)
        let type = ParserType.checkType(path: path)
        switch type {
        case .unknown:
            let msg = "解析错误，文件不存在或者不支持该格式。 file：\(path)"
            log(msg)
            blockFail?(msg)
            break
        case .ios, .android:
            parserApp(type: type, filePath: path)
            break
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
        }else{
            let msg = "App添加失败!!！"
            log(msg)
            ParserTool.shared.blockFail?(msg)
        }
        log("\n\n\n")
        //整个App添加流程完毕
    }
    
}



extension ParserTool{
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
            let syncPath = path.replacingOccurrences(of: Config.htmlPath, with: Config.htmlSyncPath)
            let syncLastPath = syncPath.deletingLastPathComponent + "/"
            try? FileManager.default.createDirectory(atPath: syncLastPath, withIntermediateDirectories: true)
            
            //创建同步文件
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
            let syncPath = path.replacingOccurrences(of: Config.htmlPath, with: Config.htmlSyncPath)
            let syncLastPath = syncPath.deletingLastPathComponent + "/"
            try? FileManager.default.createDirectory(atPath: syncLastPath, withIntermediateDirectories: true)
            
            //写入同步数据
            dict.write(toFile: syncPath, atomically: true)
        }
        return status
    }
    
    static func createDirectory(atPath path:String){
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            if Config.isSync {
                let syncPath = path.replacingOccurrences(of: Config.htmlPath, with: Config.htmlSyncPath)
                let syncLastPath = syncPath.deletingLastPathComponent + "/"
                try? FileManager.default.createDirectory(atPath: syncLastPath, withIntermediateDirectories: true)
                
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
                let syncPath = path.replacingOccurrences(of: Config.htmlPath, with: Config.htmlSyncPath)
                let syncLastPath = syncPath.deletingLastPathComponent + "/"
                try? FileManager.default.createDirectory(atPath: syncLastPath, withIntermediateDirectories: true)
                
                try FileManager.default.removeItem(atPath: syncPath)
            }
        } catch  {
            log(error)
        }
    }
}




//MARK: - 同步全部文件
extension ParserTool{
    
    
    /// 将html中的文件全部同步到html-sync文件夹中
    static func syncAllHTML(){
        
        /**
         注意这儿只需要同步图片和HTML等较小的文件，不能将应用包同步到该文件夹，应为这将没有任何意义。
         */
        if Config.isSync{
            log("注意这儿只需要同步图片和HTML等较小的文件，不能将应用包同步到该文件夹，应为这将没有任何意义。");
            
//            try? FileManager.default.removeItem(atPath: Config.htmlSyncPath)
//            do {
//                try FileManager.default.copyItem(atPath: Config.htmlPath, toPath: Config.htmlSyncPath)
//            } catch  {
//                log(error)
//            }
        }
        
        
    }
}
