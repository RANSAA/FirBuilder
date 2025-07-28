//
//  AppListTable.swift
//  FirBuilder
//
//  Created by PC on 2022/11/18.
//

import Foundation
import WCDBSwift
import KakaJSON

/**
 App详细数据列表
 */
final class AppListTable:TableCodable,Convertible{
    static let tableName = "AppListTable" //对应的表名

    var id:Int? = nil
    var bindID: String? = nil
    var isBind: Bool = false
    
    var type:ParserType = .ios
    var name:String? = nil
    var bundleID:String? = nil;
    var version:String? = nil
    var build:String? = nil
    
    var fileSize:String?  = nil
    var isSelected:Bool = false

    var minSdkVersion:String? = nil
    var targetSdkVersion:String? = nil
    
    var signType:ParserBuildType = .release
    /** 过期时间 */
    var signExpiration:String? = "永久有效"
    var devices:[String]? = nil //ios devices
    
    var srcRoot:String? = nil   //指定版本APP的资源路径名称
    
    
    var logo512Path:String? = nil
    var logo57Path:String? = nil
    var manifestPath:String? = nil
    
    var newPath:String? = nil
    var detailsPath:String? = nil
    var listPath:String? = nil
    
    var appSavePath:String? = nil

    
    var createDate:Date = Date()
    var updateDate:Date = Date()
    
    enum CodingKeys:String, CodingTableKey {
        typealias Root = AppListTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case id
        case bindID
        
        case type
        case name
        case bundleID
        case version
        case build
        
        case fileSize
        case isSelected
        
        case minSdkVersion
        case targetSdkVersion
        
        case signType
        case signExpiration
        case devices
        case srcRoot
        
        case logo512Path
        case logo57Path
        case manifestPath
        case detailsPath
        case newPath
        case listPath
        
        case appSavePath

        case createDate
        case updateDate
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            let bindings = [
                id: ColumnConstraintBinding(isPrimary: true ,isAutoIncrement: true),
            ]
            return bindings
        }
    }
    
    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值
    
    required init(){}
}

extension AppListTable:CustomStringConvertible{
    var description:String {
        return printAllIvars(self, false,isPrint: false)
    }
}
