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
class AppInfoModel123: Convertible{
    var type:ParserType = .ios
    var name:String? = nil
    var bundleID:String? = nil;
    var version:String? = nil
    var build:String? = nil
    
    var minSdkVersion:String? = nil
    var targetSdkVersion:String? = nil
    
    var signType:ParserBuildType = .release
    /** 过期时间 */
    var signExpiration:String? = "永久有效" 
    
    var devices:[String]? = nil //ios devices
    

    /** 原始图标路径 */
    var originalIconPath:String? = nil
    /** 原始app路径 */
    var originalAppPath:String? = nil
    var fileSize:String?  = nil

    //时间，如果修改了需要重新执行parse()
    var createDate:Date = Date()
    var updateDate:Date = Date()


    var isSelected:Bool = false

    
    var srcRoot:String? = nil   //指定版本APP的资源根路径
    var logoPath:String? = nil

    var saveAppName:String? = nil
    var saveAppPath:String? = nil

    var appIconPath:String? = nil   //512x512 png
    var appIcon57Path:String? = nil
    var appManifestPath:String? = nil

    var releaseName:String  = "list.html"
    var releasePath:String? = nil


    var selectedVerPath:String? = nil   //选中版本路径
    var detailsH5Path:String? = nil     //当前新生成的H5路径


    //合成内置资源路径
    func parse(){
        srcRoot = "app/\(self.type.rawValue)/\(self.bundleID ?? "")/"
        saveAppName = builderAppName()
        saveAppPath = srcRoot! + saveAppName!
        releasePath = srcRoot! + releaseName
        detailsH5Path   = srcRoot! + randomFileName + ".html"
        
//        selectedVerPath = detailsH5Path
        selectedVerPath =  srcRoot! + "new.html"

        appIconPath = srcRoot! + randomFileName + "_512x512.png"
        logoPath = appIconPath


        if self.type == .ios {
            appIcon57Path = srcRoot! + randomFileName + "_57x57.png"
            appManifestPath = srcRoot! + randomFileName + "_manifest.plist"
        }
    }

    func builderAppName() -> String{
        let type = self.type == .ios ? FileExtension.ipa.rawValue : FileExtension.apk.rawValue
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
