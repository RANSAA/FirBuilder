//
//  DetatalsViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa

class DetatalsViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    var lastVC:NSViewController!
    var pushItem:AppListTable!

    @IBOutlet var infoView: NSView!
    @IBOutlet var imgLogo: NSImageView!
    @IBOutlet var imgType: NSImageView!
    @IBOutlet var labSigType: NSTextField!
    @IBOutlet var labName: NSTextField!
    @IBOutlet var labVersion: NSTextField!
    @IBOutlet var labUpdate: NSTextField!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var scrollTableView: NSScrollView!
    @IBOutlet var tableHeaderView: NSTableHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print(self.className)

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
//            scrollTableView.isHidden = true
            for sub in scrollTableView.subviews {
                sub.isHidden = true
            }
        }
    }

    func laodData(){
        let imgPath = Config.htmlPath+pushItem.srcRoot!+pushItem.logo512Path!
        self.imgLogo.image = ImageTool.loadImageFrom(path: imgPath)
        imgType.image = NSImage(byReferencingFile: Config.htmlPath+"src/images/android.png")
        if pushItem.type == .ios {
            imgType.image = NSImage(byReferencingFile: Config.htmlPath+"src/images/apple.png")
        }
        labName.stringValue = pushItem.name!
        labVersion.stringValue = "版本：\(pushItem.version!) (Build \(pushItem.build!))    大小：\(pushItem.fileSize!)"
        labUpdate.stringValue = DateFormatter.dateStringWith(date: pushItem.updateDate)
        labSigType.stringValue = "\(pushItem.signType)"
    }

    @IBAction func backAction(_ sender: NSButton) {
        goBack()
    }
    
    //将当前App导出到指定路径
    @IBAction func btnExportAction(_ sender: NSButton) {
        export()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pushItem.devices?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        26
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


extension DetatalsViewController{
    
    func export(){
        ProcessTask.log("将当前App导出到指定路径.....")

        
//        ProcessTask.log(self.pushItem ?? "nil")
        ProcessTask.log(self.pushItem ?? "nil")
    
        let filePath = Config.appPath + "html/" + (self.pushItem.srcRoot ?? "") + (self.pushItem.appSavePath ?? "")
        
        let filename:String = (self.pushItem.name ?? "null") + "_v" + (self.pushItem.version ?? "null") + "." + (self.pushItem.appSavePath?.fileExtension ?? "")
        
        ProcessTask.log("filePath:\(filePath)")
        ProcessTask.log("outFileName:\(filename)")
        
        
        // 创建并配置 NSSavePanel
        let savePanel = NSSavePanel()
        
        // 设置保存面板的属性
        savePanel.title = "保存文件"
        savePanel.message = "请选择保存文件的位置"
        //savePanel.allowedFileTypes = ["txt"] // 限制文件类型，例如只能保存为 .txt
        savePanel.canCreateDirectories = true // 允许创建新目录
        savePanel.nameFieldStringValue = filename // 默认文件名
        

        // 以模态形式显示面板
        let response = savePanel.runModal()
        // 处理用户的选择
        if response == .OK, let url = savePanel.url {
            // 用户选择了保存路径，进行文件保存操作
            do {
                ProcessTask.log(url.relativeString)
                ProcessTask.log(url.relativePath)
                if FileManager.default.fileExists(atPath: url.relativePath){
                    try FileManager.default.removeItem(atPath: url.relativePath)
                }
                try FileManager.default.copyItem(atPath: filePath, toPath: url.relativePath)
            } catch  {
                ProcessTask.log("文件导出失败 - error:\(error)")
            }
        } else {
            // 用户点击了取消
            ProcessTask.log("用户取消了保存操作")
        }
        
        
        
//        // 显示保存面板，并处理用户选择的路径
//        savePanel.begin { (result) in
//            if result == NSApplication.ModalResponse.OK {
//                if let url = savePanel.url {
//                    // 用户选择了保存路径，进行文件保存操作
//                    do {
//                        try FileManager.default.copyItem(atPath: filePath, toPath: url.relativeString)
//                    } catch  {
//                        ProcessTask.log("文件导出失败 - error:\(error)")
//                    }
//                }
//            }
//        }
        
        
    }

    
}
