//
//  AppHomeTable.swift
//  FirBuilder
//
//  Created by PC on 2022/11/18.
//

import Foundation
import WCDBSwift
import KakaJSON

/**
 首页对应的表
 */
class AppHomeTable:TableCodable,Convertible{
    static let tableName = "AppHomeTable" //对应的表名

    var id:Int? = nil
    var bindID: String? = nil
    var isBind: Bool = false
    
    var type:ParserType = .ios
    var name:String? = nil
    var bundleID:String? = nil;
    var version:String? = nil
    var build:String? = nil
    
    var srcRoot:String? = nil   //指定版本APP的资源路径名称
    var logo512Path:String? = nil
    var newPath:String? = nil
    var listPath:String? = nil
    
    var createDate:Date = Date()
    var updateDate:Date = Date()
    
    enum CodingKeys:String, CodingTableKey {
        typealias Root = AppHomeTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case id
        case bindID
        
        case type
        case name
        case bundleID
        case version
        case build
        
        case srcRoot
        case logo512Path
        case newPath
        case listPath

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

extension AppHomeTable:CustomStringConvertible{
    var description:String {
        return printAllIvars(self, false)
    }
}
