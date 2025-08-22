//
//  BuilderTemplateFile.swift
//  FirBuilder
//
//  Created by PC on 2022/6/7.
//

import Foundation


// 拷贝Template/src中的文件
struct BuilderTemplateFile {

    static func builder(){
        let srcPath = Config.templatePath + "src/"

        let toPath1:String = Config.htmlPath+"src/"
        let toPath2:String = Config.htmlSyncPath+"src/"

        
        ParserTool.createDirectory(atPath: Config.htmlPath)
        let app = Config.htmlPath + "app"
        ParserTool.createDirectory(atPath: app)
        

        do {
            try? FileManager.default.removeItem(atPath: toPath1)
            try FileManager.default.copyItem(atPath: srcPath, toPath: toPath1)
            
            if Config.isSync {
                try? FileManager.default.removeItem(atPath: toPath2)
                try FileManager.default.copyItem(atPath: srcPath, toPath: toPath2)
            }
        } catch  {
            log(error)
        }

        
        
        //拷贝manifest.json文件
        let manifestPath = Config.templatePath + "manifest.json"
        let manifestToPath = Config.htmlPath + "manifest.json"
        let manifestToSyncPath = Config.htmlSyncPath + "manifest.json"
        
        do {
            try? FileManager.default.removeItem(atPath: manifestToPath)
            try FileManager.default.copyItem(atPath: manifestPath, toPath: manifestToPath)

            if Config.isSync {
                try? FileManager.default.removeItem(atPath: manifestToSyncPath)
                try FileManager.default.copyItem(atPath: manifestPath, toPath: manifestToSyncPath)
            }
        } catch  {
            log(error)
        }
        
        
    }

}

