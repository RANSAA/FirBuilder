//
//  ListView.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa
import WCDBSwift

class ListViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    var lastVC:NSViewController!
    var homeItem:AppHomeListTable!

    @IBOutlet var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "列表-"+homeItem.name!
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
        let list:[AppReleaseListTable]? = try? db.getObjects(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.bundleID == homeItem.bundleID && AppReleaseListTable.Properties.type == homeItem.type, orderBy:[AppReleaseListTable.Properties.updateDate.asOrder(by: .descending)])
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
        cell.labVersion.stringValue = model.version!+" (Build \(model.build!) )"
        cell.labUpdate.stringValue = DateFormatter.dateStringWith(date: model.updateDate)
        cell.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/android.png")
        if model.type == .ios {
            cell.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/apple.png")
        }
        return cell
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
         let rowView = NSTableRowView()
         rowView.isEmphasized = false
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
    }


}
