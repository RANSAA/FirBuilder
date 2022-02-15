//
//  DetatalsViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa

class DetatalsViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
     var lastVC:NSViewController!
    var pushItem:AppReleaseListTable!

    @IBOutlet var infoView: NSView!

    @IBOutlet var imgLogo: NSImageView!
    @IBOutlet var imgType: NSImageView!


    @IBOutlet var labSigType: NSTextField!

    @IBOutlet var labName: NSTextField!

    @IBOutlet var labVersion: NSTextField!

    @IBOutlet var labUpdate: NSTextField!

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var scrollTableView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        setupUI()
        laodData()

    }

    func setupUI(){
        self.infoView.wantsLayer = true
        self.infoView.layer?.backgroundColor = NSColor.white.cgColor

//        let firstCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "firstCol"))
//        firstCol.width = 200
//        firstCol.title = "第一列"
//        tableView.addTableColumn(firstCol)



        if pushItem.type == .ios {
            self.tableView.rowHeight = 40
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }else{
            scrollTableView.isHidden = true
        }

    }

    func laodData(){
        self.imgLogo.sd_setImage(with: URL.init(fileURLWithPath: Config.appPath+pushItem.appIconPath!), completed: nil)
        imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/android.png")
        if pushItem.type == .ios {
            imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/apple.png")
        }
        labName.stringValue = pushItem.name!
        labVersion.stringValue = "版本：\(pushItem.version!) (Build \(pushItem.build!)     大小：\(pushItem.fileSize!)"
        labUpdate.stringValue = DateFormatter.dateStringWith(date: pushItem.updateDate)
        labSigType.stringValue = pushItem.signType.rawValue
    }

    @IBAction func backAction(_ sender: NSButton) {
        goBack()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return pushItem.devices?.count ?? 0
    }

    func tableView(_ tableView1: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = NSTextField()
        text.stringValue = ""
        if pushItem.devices?.first != nil {
            let device = pushItem.devices![row]
            text.stringValue = device
        }

        let cell = NSTableCellView()
        cell.addSubview(text)
        text.drawsBackground = false
        text.isBordered = false
        text.translatesAutoresizingMaskIntoConstraints = false

        cell.addConstraint(NSLayoutConstraint(item: text, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0))
        cell.addConstraint(NSLayoutConstraint(item: text, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1, constant: 13))
        cell.addConstraint(NSLayoutConstraint(item: text, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1, constant: -13))
        return cell

    }
}

extension DetatalsViewController{
    static func createVC(_ lastVC:NSViewController) -> DetatalsViewController{
        let vc = DetatalsViewController(nibName: "DetatalsViewController", bundle: nil)
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
