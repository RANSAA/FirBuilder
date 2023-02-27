//
//  AppInfo.swift
//  FirBuilder
//
//  Created by PC on 2022/2/10.
//

import Foundation
import KakaJSON

//app 应用信息
class AppInfoModel: Convertible{
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
    
    var srcRoot:String? = nil   //指定版本APP的资源路径名称
    
    var logo512Path:String? = nil
    var logo57Path:String? = nil
    var manifestPath:String? = nil
    
    var newPath:String? = nil
    var detailsPath:String? = nil
    var listPath:String? = nil
    
    var appSavePath:String? = nil
        
    var isSelected:Bool = false


    /**
     合成内部资源
     */
    func parseInfo(){
        let random = randomFileName
        srcRoot = "app/\(self.type)/\(self.bundleID ?? "")/".lowercased()
        srcRoot = srcRoot?.replacingOccurrences(of: " ", with: "")
        logo512Path = random + "_512x512.png"
        logo57Path = random + "_57x57.png"
        if type == .ios {
            manifestPath = random + "_manifest.plist"
        }
        
        newPath = "new.html"
        listPath = "list.html"
        detailsPath = random + ".html"
         
        if  type == .ios {
            /**
             对于 iOS 16 以上的 设备，你需要将 ipa 文件命名为：原文件名@bundle-identifier.ipa，即需要在原来的基础上加入@bundle-identifier，其中的 bundle-identifier 即 IPA 包中 Info.plist 的 CFBundleIdentifier
             */
            appSavePath = random + "@\(self.bundleID!)" + "." + originalAppPath!.fileExtension
        }else{
            appSavePath = random + "." + originalAppPath!.fileExtension
        }
    }
    
    //随机生成的文件名称
    var randomFileName:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var res = formatter.string(from: self.createDate)+"_"+version!+"_"+build!
        res = res.replacingOccurrences(of: " ", with: "").lowercased()
        return res
    }

    required init() {}
}


extension AppInfoModel:CustomStringConvertible{
    var description:String {
        return printAllIvars(self, false,isPrint: false)
    }
}
