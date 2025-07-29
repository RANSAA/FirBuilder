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
    


    required init() {}
}


extension AppInfoModel:CustomStringConvertible{
    var description:String {
        return printAllIvars(self, false,isPrint: false)
    }
}

extension AppInfoModel{
    
    /**
     校验AppInfoModel的数据是否合法,如果合法继续添加，如果不合法表示整个App添加解析人事失败。
     */
    func verifyAppInfoModel() -> Bool{
        if originalIconPath == nil {
            //随便给个默认值用于占位，如果加载不出来图片，将会使用一个默认图标
            originalIconPath = "unkonwn"
        }
        guard let name = name,
        let bundleID = bundleID,
        let version = version,
        let build = build,
        let originalIconPath = originalIconPath,
        let originalAppPath = originalAppPath,
        let signExpiration = signExpiration,
        let fileSize = fileSize
        else{
            log("AppInfoModel数据校验失败，中断解析任务。")
            return false
        }
        
        //构建内部附加信息数据
        buildAllInfo()
        
        
        let msg = """
AppInfoModel:Start
            name:\(name )
            bundleID:\(bundleID )
            version:\(version )
            build:\(build)
            minSdkVersion:\(minSdkVersion ?? "解析失败")
            targetSdkVersion:\(targetSdkVersion ?? "解析失败")
            originalIconPath:\(originalIconPath )
            originalAppPath:\(originalAppPath )
            type:\(self.type)
            signType:\(self.signType)
            signExpiration:\(signExpiration )
            fileSize:\(fileSize )
            srcRoot:\(srcRoot ?? "Build失败")
            logo512Path:\(logo512Path ?? "不存在")
            logo57Path:\(logo57Path ?? "不存在")
            manifestPath:\(manifestPath ?? "不存在")
            newPath:\(newPath ?? "Build失败")
            listPath:\(listPath ?? "Build失败")
            detailsPath:\(detailsPath ?? "Build失败")
            appSavePath:\(appSavePath ?? "Build失败")
            devices:\(String(describing: devices) )
AppInfoModel:End
"""
        log(msg)
        
        return true
    }
    
    
    

}


extension AppInfoModel{
    
    /**
     构建AppInfoModel内部附加信息与数据
     */
    private func buildAllInfo(){
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
        var res = formatter.string(from: self.createDate)+"_"+(version ?? "null")+"_"+(build ?? "null")
        res = res.replacingOccurrences(of: " ", with: "").lowercased()
        return res
    }
    
}
