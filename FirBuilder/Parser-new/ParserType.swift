//
//  ParserType.swift
//  FirBuilder
//
//  Created by PC on 2022/11/17.
//

import Foundation
import WCDBSwift
import KakaJSON



//解析支持的文件类型
enum ParserType:Int,CustomStringConvertible,ColumnJSONCodable,ConvertibleEnum {
    case ios
    case android
    case unknown
    
    var description: String{
        var des = "unknown"
        switch self {
        case .ios:
            des = "iOS"
        case .android:
            des = "Android"
        default :
            des = "unknown"
        }
        return des
    }
    
    /**
     检查指定路径的文件类型
     */
    static func checkType(path:String) -> ParserType{
        let android = ["apk"]
        let ios = ["ipa"];
        guard FileManager.default.fileExists(atPath: path) else {
            return .unknown
        }
        let fileExtension = path.fileExtension.lowercased()
        if android.contains(fileExtension) {
            return .android
        }
        if ios.contains(fileExtension) {
            return .ios
        }
        return .unknown
    }
}


//APP签名构建类型
enum ParserBuildType:Int,CustomStringConvertible,ColumnJSONCodable,ConvertibleEnum {
    case release
    case xcodeTest
    case simulator
    case adHoc
    case enterprise
    case appStore
    case unknown
    
    
    var description: String{
        var des = ""
        switch self {
        case .release:
            des = "正式版"
        case .simulator:
            des = "Simulator"
        case .xcodeTest:
            des = "XCode测试"
        case .adHoc:
            des = "Ad-Hoc"
        case .enterprise:
            des = "企业版"
        case .appStore:
            des = "App Store"
        default:
            des = "unknown"
        }
        return des
    }
    
}
