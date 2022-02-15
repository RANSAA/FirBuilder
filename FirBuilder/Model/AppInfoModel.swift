//
//  AppInfo.swift
//  FirBuilder
//
//  Created by PC on 2022/2/10.
//

import Foundation
import KakaJSON

//app 应用信息
//注意
class AppInfoModel: Convertible{
    var type:AppType = .ios
    var name:String? = nil
    var bundleID:String? = nil;
    var version:String? = nil
    var build:String? = nil

    var isSelected:Bool = false
    var md5:String? = nil
    var signType:SignatureType = .release


    var minSdkVersion:String? = nil
    var targetSdkVersion:String? = nil

    var devices:[String]? = nil //ios devices

    //
    var iconOriginalPath:String? = nil
    var appOriginalPath:String? = nil
    var fileSize:String?  = nil

    //时间，如果修改了需要重新执行parse()
    var createDate:Date = Date()
    var updateDate:Date = Date()


    var srcRoot:String? = nil   //指定版本APP的资源根路径
    var logoPath:String? = nil

    var saveAppName:String? = nil
    var saveAppPath:String? = nil

    var appIconPath:String? = nil   //512x512 png
    var appIcon57Path:String? = nil
    var appManifestPath:String? = nil

    var releaseName:String  = "Release.html"
    var releasePath:String? = nil


    var selectedVerPath:String? = nil   //选中版本路径
    var detailsH5Path:String? = nil     //当前新生成的H5路径

    //合成内置资源路径
    func parse(){
        srcRoot = "app/\(self.type.rawValue)/\(self.bundleID ?? "")/"
        logoPath = srcRoot! + "Logo512.png"
        saveAppName = builderAppName()
        saveAppPath = srcRoot! + saveAppName!
        releasePath = srcRoot! + releaseName
        detailsH5Path   = srcRoot! + randomFileName + ".html"
//        selectedVerPath = srcRoot! + "details.html"
        selectedVerPath = detailsH5Path

        appIconPath = srcRoot! + randomFileName + "_512x512.png"
        if self.type == .ios {
            appIcon57Path = srcRoot! + randomFileName + "_57x57.png"
            appManifestPath = srcRoot! + randomFileName + "_manifest.plist"
        }
    }

    func builderAppName() -> String{
        let type = self.type == AppType.ios ? FileExtension.ipa.rawValue : FileExtension.apk.rawValue
        return randomFileName +  "." + type
    }

    //随机生成的文件名称
    var randomFileName:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: self.createDate)+"_"+version!+"_"+build!
    }

    required init() {}
}
