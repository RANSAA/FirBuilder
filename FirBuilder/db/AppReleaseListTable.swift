//
//  AppListTable.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//
import Cocoa
import WCDBSwift
//import HandyJSON
import KakaJSON

//指定APP分发项目记录表
class AppReleaseListTable:TableCodable,CustomStringConvertible,Convertible {
    static let tableName = "AppReleaseList" //对应的表名

    var id:Int? = nil

    var bindID: String? = nil
    var isBind: Bool = false

    var signType:SignatureType = .release
    var type:AppType = .ios
    var name:String? = nil
    var bundleID:String? = nil;
    var version:String? = nil
    var build:String? = nil

    var fileSize:String? = nil

    var isSelected:Bool = false

    var minSdkVersion:String? = nil
    var targetSdkVersion:String? = nil

    var srcRoot:String? = nil   //APP存储位置的根目录地址，如app/ios/com.sayaDev.test/
    var detailsH5Path:String? = nil   //当前新生成的H5路径

    //app资源
    var saveAppName:String? = nil
    var saveAppPath:String? = nil

    var appIconPath:String? = nil
    var appIcon57Path:String? = nil
    var appManifestPath:String? = nil



    var devices:[String]? = nil //ios devices

    var createDate:Date = Date()
    var updateDate:Date = Date()


    enum CodingKeys:String, CodingTableKey {
        typealias Root = AppReleaseListTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case id
        case bindID
        case isBind

        case signType
        case type
        case name
        case bundleID
        case version
        case build

        case fileSize

        case isSelected

        case minSdkVersion
        case targetSdkVersion


        case srcRoot
        case detailsH5Path

        //app资源下载
        case saveAppPath

        case appIconPath
        case appIcon57Path
        case appManifestPath

        case devices

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

    
    //CustomStringConvertible
    var description:String {
        return printAllIvars(self, false)
    }

    //HandyJSON
    required init() {}
}
