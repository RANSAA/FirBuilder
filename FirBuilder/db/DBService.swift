//
//  DBService.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import WCDBSwift

class DBService: NSObject {
    public let db:Database

    public static let shared = DBService()

    required override init() {
        db = Database(withPath:Config.dbPath)
    }

    func setup(){
//        if (try? db.isTableExists(GeneratorIDTable.tableName)) == false {
//            try? db.create(table: GeneratorIDTable.tableName, of: GeneratorIDTable.self)
//        }
        
        if (try? db.isTableExists(AppHomeTable.tableName)) == false {
            try? db.create(table: AppHomeTable.tableName, of: AppHomeTable.self)
        }
        
        if (try? db.isTableExists(AppListTable.tableName)) == false {
            try? db.create(table: AppListTable.tableName, of: AppListTable.self)
        }
        
        close()
    }

    func close(){
        if db.isOpened {
            db.close()
        }
    }



    func insert<Object: TableEncodable>(objects: Object..., intoTable table: String){
        do {
            try self.db.insert(objects: objects, intoTable: table)
        } catch  {
            print("insert error:\(error)")
        }
    }

    func insert<Object: TableEncodable>(objects: [Object], intoTable table: String){
        do {
            try self.db.insert(objects: objects, intoTable: table)
        } catch  {
            print("insert error:\(error)")
        }
    }



    func get(){
        do {
            let allObjects: [GeneratorIDTable] = try db.getObjects(fromTable: GeneratorIDTable.tableName)
//            let allObjects1: [IDRecordModel] = try db.getObjects(on: IDRecordModel.Properties.bindID, fromTable: IDRecordModel.tableName)
//            print(allObjects)
//            print(allObjects1)

            let bindIDs = try db.getColumn(on: GeneratorIDTable.Properties.id, fromTable: GeneratorIDTable.tableName)
//            print(bindIDs[0].int32Value)
//            bindIDs[0].stringValue

        } catch  {
            print("getObjects:\(error)")
        }

    }

}
