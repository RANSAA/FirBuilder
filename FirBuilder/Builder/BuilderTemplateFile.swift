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


        try? FileManager.default.removeItem(atPath: toPath1)
        if Config.isSync {
            try? FileManager.default.removeItem(atPath: toPath2)
        }

        ParserTool.createDirectory(atPath: Config.htmlPath)

        try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath1)
        if Config.isSync {
            try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath2)
        }

        let app = Config.htmlPath + "app"
//        let appSync = Config.htmlSyncPath + "app"
        
        ParserTool.createDirectory(atPath: app)
    }

}

