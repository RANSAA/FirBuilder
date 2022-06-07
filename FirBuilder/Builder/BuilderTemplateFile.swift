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
        if let path =  Bundle.main.path(forResource: "Template", ofType: nil){
            let srcPath = path + "/src/"
            print("Template src Path:\(srcPath)")
            let toPath1:String = Config.appPath+"/src/"
            let toPath2:String = Config.syncPath+"/src/"


            try? FileManager.default.removeItem(atPath: toPath1)
            try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath1)


            if !FileManager.default.fileExists(atPath: Config.syncPath) {
                try? FileManager.default.createDirectory(atPath: Config.syncPath, withIntermediateDirectories: true, attributes: nil)
            }
            try? FileManager.default.removeItem(atPath: toPath2)
            try? FileManager.default.copyItem(atPath: srcPath, toPath: toPath2)
        }
    }

}

