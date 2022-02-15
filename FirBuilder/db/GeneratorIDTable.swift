//
//  IDRecordTable.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import WCDBSwift



//GeneratorID生成器ID记录表，用于保证生成的ID是唯一的
//GeneratorIDTable
class GeneratorIDTable: TableCodable {
    static let tableName = "GeneratorIDRecord" //对应的表名

    var id:Int? = nil
    var bindID: String? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = GeneratorIDTable
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id
        case bindID = "RecordID"

        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            let bindings = [
                id: ColumnConstraintBinding(isPrimary: true ,isAutoIncrement: true),
            ]
            return bindings
        }
    }

    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值

    init(recordID: String?) {
        self.bindID = recordID
    }
}
