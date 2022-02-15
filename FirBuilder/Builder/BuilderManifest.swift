//
//  BuilderManifest.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import WCDBSwift

class BuilderManifest{


    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }

            let list:[AppReleaseListTable]? = try db.getObjects(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.type == AppType.ios, orderBy: [AppReleaseListTable.Properties.updateDate.asOrder(by: .descending)])

            if let list = list {
                for item in list {
                    builder(item)
                }
            }
        } catch {
            print(error)
        }
    }

    func builder(_ item: AppInfoModel){
        if item.type == .ios {
            let metadata:[String:String] = [
                "bundle-identifier":item.bundleID!,
                "bundle-version":item.version!,
                "kind":"software",
//                "subtitle":"sub Title",
                "title":item.name!
            ]

            let itemApp = [
                "kind":"software-package",
                "url":Config.serverRoot+item.saveAppPath!
            ]

            let itemFull:[String : Any] = [
                "kind":"full-size-image",
//                "needs-shine":false,
                "url":Config.serverRoot+item.appIconPath!
            ]

            let itemDisplay:[String : Any] = [
                "kind":"display-image",
//                "needs-shine":false,
                "url":Config.serverRoot+item.appIcon57Path!
            ]


            //manifest file
            let manifest:NSDictionary = ["items":[
                ["assets":[itemApp,itemFull,itemDisplay],
                 "metadata":metadata
                ]
            ]]
            manifest.write(toFile: Config.appPath+item.appManifestPath!, atomically: true)
        }
    }

    func builder(_ item: AppReleaseListTable){
        if item.type == .ios {
            let metadata:[String:String] = [
                "bundle-identifier":item.bundleID!,
                "bundle-version":item.version!,
                "kind":"software",
//                "subtitle":"sub Title",
                "title":item.name!
            ]

            let itemApp = [
                "kind":"software-package",
                "url":Config.serverRoot+item.saveAppPath!
            ]

            let itemFull:[String : Any] = [
                "kind":"full-size-image",
//                "needs-shine":false,
                "url":Config.serverRoot+item.appIconPath!
            ]

            let itemDisplay:[String : Any] = [
                "kind":"display-image",
//                "needs-shine":false,
                "url":Config.serverRoot+item.appIcon57Path!
            ]


            //manifest file
            let manifest:NSDictionary = ["items":[
                ["assets":[itemApp,itemFull,itemDisplay],
                 "metadata":metadata
                ]
            ]]
            manifest.write(toFile: Config.appPath+item.appManifestPath!, atomically: true)
        }
    }
}
