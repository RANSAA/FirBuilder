//
//  ListView.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa
import WCDBSwift

class ListViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,ListCellDelegate {
    var lastVC:NSViewController!
    var pushItem:AppHomeListTable!

    @IBOutlet var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "列表-"+pushItem.name!
        print("ListViewController")

        setupUI()
        loadData()
    }


    func setupUI(){
        //https://www.cnblogs.com/xjf125/p/14754196.html
        tableView.register(NSNib(nibNamed: "ListCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListCell"))

//        let firstCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "firstCol"))
//        firstCol.width = 200
//        firstCol.title = "第一列"
//        tableView.addTableColumn(firstCol)

        tableView.rowHeight = 140
        tableView.delegate = self
        tableView.dataSource = self
    }

    var dataAry:[AppReleaseListTable] = []
    func loadData(){
        let db = DBService.shared.db
        defer {
            db.close()
        }
        let list:[AppReleaseListTable]? = try? db.getObjects(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.bundleID == pushItem.bundleID && AppReleaseListTable.Properties.type == pushItem.type, orderBy:[AppReleaseListTable.Properties.updateDate.asOrder(by: .descending)])
        if let list = list {
            dataAry = list
        }
        tableView.reloadData()
    }


    func numberOfRows(in tableView: NSTableView) -> Int {
        dataAry.count
    }

//    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//
//    }

    func tableView(_ tableView1: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell:ListCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListCell"), owner: self) as! ListCell
        let model = self.dataAry[row]
        cell.img.sd_setImage(with: URL.init(fileURLWithPath: Config.appPath+model.appIconPath!), completed: nil)
        cell.labName.stringValue = model.name!
        cell.labBundle.stringValue = model.bundleID!
        cell.labVersion.stringValue = model.version!+" (Build \(model.build!))"
        cell.labUpdate.stringValue = "创建时间：\( DateFormatter.dateStringWith(date: model.createDate))      更新时间\( DateFormatter.dateStringWith(date: model.updateDate))"
        cell.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/android.png")
        if model.type == .ios {
            cell.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/apple.png")
        }
        cell.row = row
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
         let rowView = NSTableRowView()
         rowView.isEmphasized = true
         return rowView
     }

    //选中某一行
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        let model = self.dataAry[row]
        let vc:DetatalsViewController = DetatalsViewController.createVC(self)
        vc.pushItem = model
        vc.push()

        tableView.reloadData()
        print("tableViewSelectionDidChange row:\(row)")
    }

    @IBAction func backAction(_ sender: NSButton) {
        goBack()
    }

    @IBAction func btnDeleteApp(_ sender: NSButton) {
        let alert = NSAlert()
        alert.messageText = "删除App"
        alert.informativeText = "该操作会删除App及其相关的文件"
        alert.addButton(withTitle: "删除")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .critical
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            print("ok")
            deleteApp()
        }else{
            print("cancel")
        }
    }

}

extension ListViewController{
    static func createVC(_ lastVC:NSViewController) -> ListViewController{
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ListViewController") as! ListViewController
        vc.lastVC = lastVC
        return vc
    }

    func push(){
        self.view.frame = lastVC.view.frame
        NSApplication.shared.keyWindow?.contentViewController = self
//        lastVC.presentAsModalWindow(self)
//        lastVC.presentAsSheet(self)
    }

    func goBack(){
        lastVC.view.frame = self.view.frame
        NSApplication.shared.keyWindow?.contentViewController = lastVC
        let vc:ViewController = lastVC as! ViewController
        vc.loadDataArray()
    }


}


extension ListViewController{
    func deleteApp(){
        do{
            let db = DBService.shared.db
            defer {
                db.close()
            }
            try db.delete(fromTable: AppHomeListTable.tableName, where: AppHomeListTable.Properties.bundleID == pushItem.bundleID && AppHomeListTable.Properties.type == pushItem.type)
            try db.delete(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.bundleID == pushItem.bundleID && AppReleaseListTable.Properties.type == pushItem.type)
            BuilderAppHome().builder()

            let fileManager = FileManager.default
            try? fileManager.removeItem(atPath: Config.appPath+pushItem.srcRoot!)
            try? fileManager.removeItem(atPath: Config.syncPath+pushItem.srcRoot!)

        }catch{
            print(error)
        }


        goBack()
        let homeVC:ViewController = lastVC as! ViewController
        homeVC.loadDataArray()

    }
}


extension ListViewController
{

    func listCell(clickButton btn: NSButton, btnIndex: Int, cellRow: Int) {
        print("click... index:\(btnIndex)   row:\(cellRow)")
        let model:AppReleaseListTable = self.dataAry[cellRow]
        let alert = NSAlert()
        alert.alertStyle = .critical
        if btnIndex == 0 {
            alert.messageText = "置顶"
            alert.informativeText = "会将该版本设置为预览状态"
            alert.addButton(withTitle: "确定")
        }else{
            alert.messageText = "删除"
            alert.informativeText = "会将该版本删除"
            alert.addButton(withTitle: "删除")
        }
        alert.addButton(withTitle: "取消")
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            if btnIndex == 0 {
                topCellActin(model)
            }else{
                deleteCellAction(model)
            }
        }else{
            print("cancel")
        }




//        if btnIndex == 0 {
//            topCellActin(model)
//        }else{
//            deleteCellAction(model)
//        }
//        loadData()
//        if self.dataAry.count < 1 {
//            deleteApp()
//        }
    }

    func topCellActin(_ model:AppReleaseListTable){
        do{
            let db = DBService.shared.db
            defer {
                db.close()
            }

            let update = Date()
            try db.update(table: AppReleaseListTable.tableName, on: AppReleaseListTable.Properties.updateDate, with: [update], where: AppReleaseListTable.Properties.bundleID == model.bundleID! && AppReleaseListTable.Properties.type == model.type && AppReleaseListTable.Properties.updateDate == model.updateDate)

            loadData()

            BuilderList().builderAll()

            updateAppHomeList(model, update: update)
        }catch{

        }
    }

    func deleteCellAction(_ model:AppReleaseListTable){
        do{
            let db = DBService.shared.db
            defer {
                db.close()
            }
            try db.delete(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.bundleID == model.bundleID! && AppReleaseListTable.Properties.type == model.type && AppReleaseListTable.Properties.updateDate == model.updateDate)

            loadData()

            BuilderList().builderAll()

        }catch{
            print(error)
        }

        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: Config.appPath+model.saveAppPath!)
        try? fileManager.removeItem(atPath: Config.appPath+model.detailsH5Path!)
        try? fileManager.removeItem(atPath: Config.appPath+model.appIconPath!)

        try? fileManager.removeItem(atPath: Config.syncPath+model.saveAppPath!)
        try? fileManager.removeItem(atPath: Config.syncPath+model.detailsH5Path!)
        try? fileManager.removeItem(atPath: Config.syncPath+model.appIconPath!)

        if model.type == .ios {
            try? fileManager.removeItem(atPath: Config.appPath+model.appIcon57Path!)
            try? fileManager.removeItem(atPath: Config.appPath+model.appManifestPath!)

            try? fileManager.removeItem(atPath: Config.syncPath+model.appIcon57Path!)
            try? fileManager.removeItem(atPath: Config.syncPath+model.appManifestPath!)
        }

        if self.dataAry.count < 1 {
            deleteApp()
        }else{
            let model: AppReleaseListTable = dataAry[0]
            updateAppHomeList(model,update: Date())
        }
    }

    func updateAppHomeList(_ model: AppReleaseListTable, update:Date){
        do{
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let properties = [AppHomeListTable.Properties.name,AppHomeListTable.Properties.version,AppHomeListTable.Properties.build,AppHomeListTable.Properties.selectedVerPath,AppHomeListTable.Properties.updateDate]
            let row:[ColumnEncodable] = [model.name!,model.version!,model.build!,model.detailsH5Path!,update]
            try db.update(table: AppHomeListTable.tableName, on: properties, with: row, where: AppHomeListTable.Properties.bundleID == model.bundleID! && AppHomeListTable.Properties.type == model.type)

            BuilderAppHome().builder()
        }catch{
            print(error)
        }
    }
}
