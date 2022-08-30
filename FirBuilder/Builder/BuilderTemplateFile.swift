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
        try? FileManager.default.removeItem(atPath: toPath2)

        if !FileManager.default.fileExists(atPath: Config.htmlPath) {
            try? FileManager.default.createDirectory(atPath: Config.htmlPath, withIntermediateDirectories: true, attributes: nil)
        }
        if !FileManager.default.fileExists(atPath: Config.htmlSyncPath) {
            try? FileManager.default.createDirectory(atPath: Config.htmlSyncPath, withIntermediateDirectories: true, attributes: nil)
        }

        try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath1)
        try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath2)

        
        let app = Config.htmlPath + "app"
        let appSync = Config.htmlSyncPath + "app"
        if !FileManager.default.fileExists(atPath: app) {
            try? FileManager.default.createDirectory(atPath: app, withIntermediateDirectories: true, attributes: nil)
        }
        if !FileManager.default.fileExists(atPath: appSync) {
            try? FileManager.default.createDirectory(atPath: appSync, withIntermediateDirectories: true, attributes: nil)
        }


    }

}

