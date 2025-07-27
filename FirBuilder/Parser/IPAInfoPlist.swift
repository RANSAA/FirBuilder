//
//  InfoPlist.swift
//  FirBuilder
//
//  Created by PC on 2022/2/13.
//

import Foundation
import KakaJSON

/**
 解析info.plist中的字段
 */
class IPAInfoPlist:Convertible{
    var bundleID:String?
    var name:String?
    var bundleName:String?
    var version:String?
    var build:String?
    var minSdkVersion:String?
    var targetSdkVersion:String?

    //icon-ios
    var iconFiles:[String]?
    var iconFiles_ipad:[String]?
    var iconFiles_1:[String]?
    var iconFile_2:String?

    required init(){}

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
            case "bundleID" : return "CFBundleIdentifier"
            case "name" : return "CFBundleDisplayName"
            case "bundleName" : return "CFBundleName"
            case "version" : return "CFBundleShortVersionString"
            case "build" : return "CFBundleVersion"
            case "minSdkVersion" : return "MinimumOSVersion"
            case "targetSdkVersion" : return "DTPlatformVersion"

            case "iconFiles": return "CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"
            case "iconFiles_ipad": return "CFBundleIcons~ipad.CFBundlePrimaryIcon.CFBundleIconFiles"
            case "iconFiles_1": return "CFBundleIconFiles"
            
            case "iconFile_2": return "CFBundleIconFile"
            
            default:return property.name
        }
    }

}


extension IPAInfoPlist:CustomStringConvertible{
    var description:String {
        return printAllIvars(self, false,isPrint: false)
    }
}
