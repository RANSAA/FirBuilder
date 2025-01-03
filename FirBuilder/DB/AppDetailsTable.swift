//
//  AppDetailsTable.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import WCDBSwift

//bindID生成记录表
class AppDetailsTable: TableCodable {
    static let tableName = "AppDetails" //对应的表名

    var id:Int? = nil
    var bindID: String? = nil

    var type:AppType = .ios
    var name:String? = nil
    var bundleID:String = "";
    var version:String? = nil
    var build:String? = nil

    var detailsPath:String? = nil   //details.html文件位置
    var appPath:String? = nil         //app文件路径
    var icon57Path:String? = nil    //57x57尺寸的icon路径
    var icon512path:String? = nil   //512x512尺寸的icon路径
    var manifestPath:String? = nil  //manifest.plist文件路径


    enum CodingKeys: String, CodingTableKey {
        typealias Root = AppDetailsTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id
        case bindID

        case type
        case name
        case bundleID
        case version
        case build

        case detailsPath
        case appPath
        case icon57Path
        case icon512path
        case manifestPath

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            let bindings = [
                id: ColumnConstraintBinding(isPrimary: true ,isAutoIncrement: true),
            ]
            return bindings
        }
    }

    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值
}


