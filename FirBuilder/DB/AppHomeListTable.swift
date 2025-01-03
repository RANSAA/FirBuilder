//
//  AppListTable.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//
import Cocoa
import WCDBSwift
import KakaJSON


//APP分发项目记录表
class AppHomeListTable: TableCodable,Convertible {
    static let tableName = "AppHomeList" //对应的表名

    var id:Int? = nil
    var bindID: String? = nil
    var isBind: Bool = false

    var type:AppType = .ios
    var name:String? = nil
    var bundleID:String = "";
    var version:String? = nil
    var build:String? = nil

    var srcRoot:String? = nil   //APP存储位置的根目录地址，如app/ios/com.sayaDev.test/
    var logoPath:String? = nil  //logo地址,如Logo512x512.png文件的路径
    var releasePath:String? = nil   //releaseList.html文件地址
    var selectedVerPath:String? = "new.html"   //选中版本的details.html文件路径

    var createDate:Date = Date()
    var updateDate:Date = Date()

    enum CodingKeys: String, CodingTableKey {
        typealias Root = AppHomeListTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case id
        case bindID

        case type
        case name
        case bundleID
        case version
        case build

        case srcRoot
        case logoPath
        case releasePath
        case selectedVerPath

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


    required init() {

    }
}

