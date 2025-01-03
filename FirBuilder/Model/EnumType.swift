//
//  AppType.swift
//  FirBuilder
//
//  Created by PC on 2022/2/6.
//

import Cocoa
import WCDBSwift
import KakaJSON


//ConvertibleEnum -> KakaJSON
//ColumnCodable -> WCDB自定义数据类型需要实现改协议
//ColumnJSONCodable -> WCDB默认实现ColumnCodable协议，为JSON格式
//ExpressionConvertible -> AppReleaseListTable.Properties.type == model.type
enum AppType:String,ColumnCodable,ExpressionConvertible,ConvertibleEnum {

    case ios = "iOS"
    case android = "Android"


    //ExpressionConvertible WCDB 自定义属性 where ==
    func asExpression() -> Expression {
        return Expression(stringLiteral: self.rawValue)
    }


    //ColumnCodable
    init?(with value: FundamentalValue) {
        if let obj = AppType(rawValue: value.stringValue) {
            self = obj
        }else{
            return nil
        }
    }
    func archivedValue() -> FundamentalValue {
        FundamentalValue(self.rawValue)
    }
    static var columnType: ColumnType{
        .text
    }
}


enum FileExtension:String,ColumnJSONCodable,ConvertibleEnum{
    case ipa = "ipa"
    case apk = "apk"
    case app = "app"
}


enum SignatureType:String, ColumnJSONCodable,ConvertibleEnum {
    case release    = "正式版"
    case adHoc      = "Ad-Hoc"
    case enterprise = "Enterprise"
    case localTest  = "Local-Test"
    case simulator  = "Simulator"
    case appStore   = "AppStore"

}
