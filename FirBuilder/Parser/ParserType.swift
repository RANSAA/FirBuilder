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
//ConvertibleEnum -> KakaJSON
enum ParserType:Int,CustomStringConvertible,ConvertibleEnum{
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
        let ios = ["ipa","tipa"];
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
//WCDBSwift
//ColumnCodable -> WCDB自定义数据类型需要实现改协议
//ColumnJSONCodable -> WCDB默认实现ColumnCodable协议，为JSON格式
//ExpressionConvertible -> AppReleaseListTable.Properties.type == model.type
extension ParserType:ExpressionConvertible,ColumnCodable,ColumnJSONCodable{
    //ExpressionConvertible WCDB 自定义属性 where ==
    func asExpression() -> Expression {
        return Expression(integerLiteral: self.rawValue)
    }
    
    //ColumnCodable
    //实现该协议来自定义对应数据库中的存储数据类型
    //如果不自定义，那么在数据库中将会以data方式存储
    init?(with value: FundamentalValue) {
        let intValue = Int(value.int32Value)
        if let obj = ParserType(rawValue: intValue) {
            self = obj
        }else{
            return nil
        }
    }
    func archivedValue() -> FundamentalValue {
        FundamentalValue(self.rawValue)
    }
    static var columnType: ColumnType{
        .integer32
    }
}



//APP签名构建类型
enum ParserBuildType:Int,CustomStringConvertible,ConvertibleEnum {
    case release
    case xcodeTest
    case simulator
    case adHoc
    case enterprise
    case appStore
    case unknown
    
    
    var description: String{
        var des = "unknown"
        switch self {
        case .release:
            des = "正式版"
        case .simulator:
            des = "Simulator"
            des = "未签名"
        case .xcodeTest:
            des = "Xcode测试版"
            des = "Free Developer测试版"
            des = "Free测试版"
        case .adHoc:
            des = "Ad-Hoc"
        case .enterprise:
            des = "企业版"
        case .appStore:
            des = "App Store"
        default:
            break;
        }
        return des
    }
    
}


//WCDBSwift
//ColumnCodable -> WCDB自定义数据类型需要实现改协议
//ColumnJSONCodable -> WCDB默认实现ColumnCodable协议，为JSON格式
//ExpressionConvertible -> AppReleaseListTable.Properties.type == model.type
extension ParserBuildType:ExpressionConvertible,ColumnCodable,ColumnJSONCodable{
    //ExpressionConvertible WCDB 自定义属性 where ==
    func asExpression() -> Expression {
        return Expression(integerLiteral: self.rawValue)
    }
    
    //ColumnCodable
    //实现该协议来自定义对应数据库中的存储数据类型
    init?(with value: FundamentalValue) {
        let intValue = Int(value.int32Value)
        if let obj = ParserBuildType(rawValue: intValue) {
            self = obj
        }else{
            return nil
        }
    }
    func archivedValue() -> FundamentalValue {
        FundamentalValue(self.rawValue)
    }
    static var columnType: ColumnType{
        .integer32
    }
}


