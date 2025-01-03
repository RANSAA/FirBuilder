//
//  DBService.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import WCDBSwift
import KakaJSON

class DBService: NSObject {
    public let db:Database

    public static let shared = DBService()

    required override init() {
        db = Database(withPath:Config.dbPath)
    }

    func setup(){
        if (try? db.isTableExists(GeneratorIDTable.tableName)) == false {
            try? db.create(table: GeneratorIDTable.tableName, of: GeneratorIDTable.self)
        }
        
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
            ParserTool.log("insert error:\(error)")
        }
    }

    func insert<Object: TableEncodable>(objects: [Object], intoTable table: String){
        do {
            try self.db.insert(objects: objects, intoTable: table)
        } catch  {
            ParserTool.log("insert error:\(error)")
        }
    }

}


extension DBService{
    
    /**
     删除App
     bundleID：对应的包名
     type:应用类型，如果值为nil,则删除所有符合类型的APP
     */
    func deleteAppWith(bundleID:String,type:ParserType?){
        defer {
            db.close()
        }
        var types:[ParserType] = [.ios,.android];
        if let type = type {
            types = [type];
        }
        do {
            for type in types {
                try db.delete(fromTable: AppHomeTable.tableName, where: AppHomeTable.Properties.bundleID == bundleID && AppHomeTable.Properties.type == type)
                try db.delete(fromTable: AppListTable.tableName, where: AppListTable.Properties.bundleID == bundleID && AppListTable.Properties.type == type)
                
                let srcRoot = "app/\(type)/\(bundleID)/".lowercased()
                let delPath = Config.htmlPath+srcRoot
                ParserTool.delete(atPath: delPath)
            }
            BuilderAppHome().builder()
            
            ParserTool.log("App删除成功！")
        } catch  {
            ParserTool.log(error)
        }
    }
    
    /**
     删除指定APP的一个版本记录
     */
    func deleteAppCell(model:AppListTable){
        do{
            defer {
                db.close()
            }
            try db.delete(fromTable: AppListTable.tableName, where: AppListTable.Properties.bundleID == model.bundleID! && AppListTable.Properties.type == model.type && AppListTable.Properties.updateDate == model.updateDate)

            ParserTool.delete(atPath: Config.htmlPath+model.srcRoot!+model.appSavePath!)
            ParserTool.delete(atPath: Config.htmlPath+model.srcRoot!+model.detailsPath!)
            ParserTool.delete(atPath: Config.htmlPath+model.srcRoot!+model.logo512Path!)
            ParserTool.delete(atPath: Config.htmlPath+model.srcRoot!+model.logo57Path!)
            
            let appInfo:AppInfoModel = model.kj_modelToModel(AppInfoModel.self)!
            
            //重新生成list.html
            BuilderList().builder(appInfo)
            
        }catch{
            ParserTool.log(error)
        }
    }
    
    
    
    /**
     更新首页列表
     */
    func updateAppHomeList(model: AppListTable, update:Date){
        do{
            defer {
                db.close()
            }
            let properties = [AppHomeTable.Properties.name,
                              AppHomeTable.Properties.version,
                              AppHomeTable.Properties.build,
                              AppHomeTable.Properties.logo512Path,
                              AppHomeTable.Properties.updateDate]
            let row:[ColumnEncodable] = [model.name!,model.version!,model.build!,model.logo512Path!,update]
            try db.update(table: AppHomeTable.tableName, on: properties, with: row, where: AppHomeTable.Properties.bundleID == model.bundleID! && AppHomeTable.Properties.type == model.type)

            BuilderAppHome().builder()
        }catch{
            ParserTool.log(error)
        }
    }
    
    
}
