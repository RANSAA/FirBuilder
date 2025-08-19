//
//  DBService.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import WCDBSwift
import KakaJSON

final class DBService: NSObject {
    public let db:Database

    public static let shared = DBService()

    required override init() {
        db = Database(withPath:Config.dbPath)
        super.init()
        self.setup()
    }

    //初始化表数据
    private func setup(){
        /**
         注意：现在不校验isTableExists了，比如说在TableCodable中修改了表属性后，
         如果验证了isTableExists那么表属性不会修改，db.create方法会创建更新表数据
         */
        
//        if (try? db.isTableExists(GeneratorIDTable.tableName)) == false {
//            try? db.create(table: GeneratorIDTable.tableName, of: GeneratorIDTable.self)
//        }
//        if (try? db.isTableExists(AppHomeTable.tableName)) == false {
//            try? db.create(table: AppHomeTable.tableName, of: AppHomeTable.self)
//        }
//        if (try? db.isTableExists(AppListTable.tableName)) == false {
//            try? db.create(table: AppListTable.tableName, of: AppListTable.self)
//        }
        
        
        try? db.create(table: GeneratorIDTable.tableName, of: GeneratorIDTable.self)
        try? db.create(table: AppHomeTable.tableName, of: AppHomeTable.self)
        try? db.create(table: AppListTable.tableName, of: AppListTable.self)
        
        
        //默认初始化标后关闭数据库，其它的数据库操作会自动检测数据库是否开启，如果没打开，将会自动打开
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
            log("insert error:\(error)")
        }
    }

    func insert<Object: TableEncodable>(objects: [Object], intoTable table: String){
        do {
            try self.db.insert(objects: objects, intoTable: table)
        } catch  {
            log("insert error:\(error)")
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
            log("App删除成功！")
        } catch  {
            log(error)
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
            log(error)
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
            log(error)
        }
    }
    
    
}
