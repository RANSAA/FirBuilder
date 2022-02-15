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

    static func createTable(){
        let database = Database(withPath:Config.dbPath)
        if (try? database.isTableExists(GeneratorIDTable.tableName)) == false {
            try? database.create(table: GeneratorIDTable.tableName, of: GeneratorIDTable.self)
        }

        if (try? database.isTableExists(AppHomeListTable.tableName)) == false {
            try? database.create(table: AppHomeListTable.tableName, of: AppHomeListTable.self)
        }

        if (try? database.isTableExists(AppReleaseListTable.tableName)) == false {
            try? database.create(table: AppReleaseListTable.tableName, of: AppReleaseListTable.self)
        }

//        if (try? database.isTableExists(AppDetailsTable.tableName)) == false {
//            try? database.create(table: AppDetailsTable.tableName, of: AppDetailsTable.self)
//        }

        database.close()
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
