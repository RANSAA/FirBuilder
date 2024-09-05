//
//  BuilderManifest.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import WCDBSwift
import KakaJSON


class BuilderManifest{


    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }

            let list:[AppListTable] = try db.getObjects(fromTable: AppListTable.tableName, where: AppListTable.Properties.type == ParserType.ios, orderBy: [AppListTable.Properties.updateDate.asOrder(by: .descending)])
            
            let appInfoList = list.compactMap({ (model) -> AppInfoModel in
                let jsonString = model.kj.JSONString()
                let appInfo:AppInfoModel = KakaJSON.model(from: jsonString, type: AppInfoModel.self) as! AppInfoModel
                return appInfo
            })
            for item in appInfoList {
                Self.builder(item)
            }
        } catch {
            ParserTool.log(error)
        }
    }


    /**
     通过AppInfoModel构建manifestPath文件
     */
    static func builder(_ appInfo:AppInfoModel){
        if appInfo.type == .ios {
            let metadata:[String:String] = [
                "bundle-identifier":appInfo.bundleID!,
                "bundle-version":appInfo.version!,
                "kind":"software",
                "subtitle":appInfo.name!,
                "title":appInfo.name!
            ]

            let itemApp = [
                "kind":"software-package",
                "url":Config.serverRoot+appInfo.srcRoot!+appInfo.appSavePath!
            ]

            let itemFull:[String : Any] = [
                "kind":"full-size-image",
                "needs-shine":false,
                "url":Config.serverRoot+appInfo.srcRoot!+appInfo.logo512Path!
            ]

            let itemDisplay:[String : Any] = [
                "kind":"display-image",
                "needs-shine":false,
                "url":Config.serverRoot+appInfo.srcRoot!+appInfo.logo57Path!
            ]


            //manifest file
            let manifest:NSDictionary = ["items":[
                ["assets":[itemApp,itemFull,itemDisplay],
                 "metadata":metadata
                ]
            ]]
            
            let path = Config.htmlPath+appInfo.srcRoot!+appInfo.manifestPath!
            ParserTool.save(manifest, path: path)
        }
    }

}



