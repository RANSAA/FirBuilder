//
//  BuilderID.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Foundation

//ID 生成器
class GeneratorID: NSObject {
    public static let shared = GeneratorID()
    public static var isUnique = true //生成的ID是否保持唯一

    private override init() {

    }

    static func UUID() ->String{
        var id = ""
        var step = 8
        let count:UInt32 = UInt32(keys.count)
        while step > 0 {
            let num = Int(arc4random() % count)
            id += keys.getOneStringWith(num)
            step -= 1;
        }

        if isUnique {
            loadBindIDSets()
            if checkIsUnique(uuid: id) {
                id = self.UUID()
            }
            insert(uuid: id)
        }
        return id
    }
}


//记录已经生成的ID-实际上只需要记录每天生成的ID即可
//这儿操作不完全
extension GeneratorID{
    private static let keys = "123456789ABCDEFGHJKLMNPQRSTUVWXYZ"
    private static var bindIDSets:Set<String> = Set()
    private static var isLoadBindIDSets = false

    static func loadBindIDSets(){
        if isLoadBindIDSets == false {
            let service = DBService()
            let bindIDs = try? service.db.getColumn(on: GeneratorIDTable.Properties.bindID, fromTable: GeneratorIDTable.tableName)
            if let binds = bindIDs {
                isLoadBindIDSets = true
                for item in binds {
                    bindIDSets.insert(item.stringValue)
                }
            }else{
                print("loadBindIDSets操作失败")
            }
        }
    }

    private static func checkIsUnique(uuid: String) -> Bool{
        return self.bindIDSets.contains(uuid)
    }

    private static func insert(uuid: String){
        self.bindIDSets.insert(uuid)
        let service = DBService()
        let RecordID = GeneratorIDTable(recordID: uuid)
        try? service.db.insert(objects: RecordID, intoTable: GeneratorIDTable.tableName)
    }
    
}
