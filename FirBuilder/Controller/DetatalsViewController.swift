//
//  DetatalsViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa
import WCDBSwift
import KakaJSON

class DetatalsViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    var lastVC:NSViewController!
    var model:AppListTable!

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
    
    
    
    @IBOutlet var markView: NSView!
    @IBOutlet var labUserMark: NSTextField!//用于处理userMark所占位置大小的动态依赖项
    @IBOutlet var textViewUserMark: SmartTextView! //需要编辑userMark的TextView
    
    private let placeholder = "提示:用户可以在这里添加应用描述!"
    
    private var userMark = ""
    
    
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
        self.markView.wantsLayer = true;
        self.markView.layer?.backgroundColor = NSColor.white.cgColor;
        
        labUserMark.stringValue = placeholder;
        
        textViewUserMark.wantsLayer = true;
        textViewUserMark.layer?.backgroundColor = NSColor.clear.cgColor;
        textViewUserMark.textColor = NSColor.red;
        textViewUserMark.font = NSFont.systemFont(ofSize: 14);
        textViewUserMark.placeholder = placeholder
        textViewUserMark.delegate = self

        //推荐直接重写mouseDown实现点击空白处使输入框失去焦点
//        // 添加点击手势，现点击空白处使输入框失去焦点
//        let clickGesture1 = NSClickGestureRecognizer(target: self, action: #selector(handleBackgroundClick(_:)))
//        infoView.addGestureRecognizer(clickGesture1)
//        let clickGesture2 = NSClickGestureRecognizer(target: self, action: #selector(handleBackgroundClick(_:)))
//        scrollTableView.addGestureRecognizer(clickGesture2)
        
        
        


//        let firstCol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "firstCol"))
//        firstCol.width = 200
//        firstCol.title = "第一列"
//        tableView.addTableColumn(firstCol)

        if model.type == .ios {
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
        let imgPath = Config.htmlPath+model.srcRoot!+model.logo512Path!
        self.imgLogo.image = ImageTool.loadImageFrom(path: imgPath)
        imgType.image = NSImage(byReferencingFile: Config.htmlPath+"src/images/android.png")
        if model.type == .ios {
            imgType.image = NSImage(byReferencingFile: Config.htmlPath+"src/images/apple.png")
        }
        labName.stringValue = model.name!
        labVersion.stringValue = "版本：\(model.version!) (Build \(model.build!))    大小：\(model.fileSize!)"
        labUpdate.stringValue = DateFormatter.dateStringWith(date: model.updateDate)
        labSigType.stringValue = "\(model.signType)"
        
        userMark = model.userMark
        //存在有效字符才显示
        userMark = userMark.replacingOccurrences(of: " ", with: "")
        if userMark.count > 0 {
            textViewUserMark.string = model.userMark
        }
    }

    
    //MARK: - 重写鼠标点击事件，实现点击空白使所有输入框失去焦点
    override func mouseDown(with event: NSEvent) {
        let point = view.convert(event.locationInWindow, from: nil)
        
        
        // 方案1：
        // 检查点击是否在任何输入控件内
//        var shouldResign = true
//        for subview in view.subviews {
//            if subview is NSTextField ||
//                subview is NSTextView ||
//                subview is NSComboBox ||
//                subview is NSSearchField
//            {
//                if subview.frame.contains(point) {
//                    shouldResign = false
//                    break
//                }
//            }
//        }
//        // 如果点击的是空白区域
//        if shouldResign {
//            view.window?.makeFirstResponder(nil)
//        }
        
        
        // 方案2：
        // 如果点击的不是可编辑视图
        if !view.editableViewContains(point: point) {
            view.window?.makeFirstResponder(nil)
        }
        
        
        super.mouseDown(with: event)
    }
    
    @objc func handleBackgroundClick(_ sender: NSClickGestureRecognizer) {
        // 点击背景时使所有输入框失去焦点
        view.window?.makeFirstResponder(nil)
    }
    
    
    @IBAction func backAction(_ sender: NSButton) {
        goBack()
    }
    
    //将当前App导出到指定路径
    @IBAction func btnExportAction(_ sender: NSButton) {
        export()
    }
    
    @IBAction func btnUpdateAction(_ sender: NSButton) {
        self.textViewUserMark.window?.makeFirstResponder(nil)
        updateDataBase()
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return model.devices?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        26
    }

    func tableView(_ tableView1: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text = NSTextField()
        text.stringValue = ""
        if model.devices?.first != nil {
            let device = model.devices![row]
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


    func goBack(){
        dismissFromKeyWindow()
    }

}


extension DetatalsViewController{
    
    //MARK: - 导出app
    func export(){
        log("将当前App导出到指定路径.....")
        log(self.model ?? "nil")
    
        let filePath = Config.appPath + "html/" + (self.model.srcRoot ?? "") + (self.model.appSavePath ?? "")
        let filename:String = (self.model.name ?? "null") + "_v" + (self.model.version ?? "null") + "." + (self.model.appSavePath?.fileExtension ?? "")
        
        log("filePath:\(filePath)")
        log("outFileName:\(filename)")
        
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
                log(url.relativeString)
                log(url.relativePath)
                if FileManager.default.fileExists(atPath: url.relativePath){
                    try FileManager.default.removeItem(atPath: url.relativePath)
                }
                try FileManager.default.copyItem(atPath: filePath, toPath: url.relativePath)
            } catch  {
                log("文件导出失败 - error:\(error)")
            }
        } else {
            // 用户点击了取消
            log("用户取消了保存操作")
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
//                        log("文件导出失败 - error:\(error)")
//                    }
//                }
//            }
//        }
    }

    
    
    //MARK: - 更新数据信息
    func updateDataBase(){
        let isUpdate = userMark == model.userMark ? false : true;
        if isUpdate{
            self.openConfirmAlert(title: "更新", msg: "数据发生改变，可以更新！", blockOK: { [unowned self] in
                self.updatemodelData()
            }, blockCancel: nil)
        }else{
            self.openPromptAlert(msg: "数据没有修改，取消更新！")
        }
    }
    
    
    //更新App详情数据
    func updatemodelData(){
        log("更新数据库......")
        self.model.userMark = self.userMark
        
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            
            //更新AppInfo
            let updateDate = Date()
            model.updateDate = updateDate
            
            let properties = [AppListTable.Properties.updateDate,
                              AppListTable.Properties.userMark]
            let values:[ColumnEncodable] = [model.updateDate,model.userMark]
            try db.update(table: AppListTable.tableName, on: properties, with: values, where:AppListTable.Properties.bundleID == model.bundleID! && AppListTable.Properties.type == model.type && AppListTable.Properties.createDate == model.createDate)
            
            
            
            //转换莫得了
            let appInfo:AppInfoModel = model.kj_modelToModel(AppInfoModel.self)!

            
            //重新生成new.html
            BuilderDetails().builderNewHTML(appInfo)
            //重新生成details.html
            BuilderDetails().builderDetailsHTML(appInfo)
            //重新生成list.html
            BuilderList().builder(appInfo)
            
            
            
            //更新当前AppList数据
            NotificationCenter.default.post(name: kNotificationNameUpdateSelectedAppList, object: nil)
            
            
            //更新首页数据
            DBService.shared.updateAppHomeList(model: model, update: updateDate)
            //通知首页更新
            NotificationCenter.default.post(name: kNotificationNameUpdateHomeData, object: nil)
            
            DispatchQueue.main.async {
                self.openPromptAlert(msg: "更新成功!")
            }
        } catch  {
            log("App详情数据更新失败：\(error)")
            DispatchQueue.main.async { [weak self] in
                self?.openErrorAlert(msg: "更新失败！")
            }
        }
        
    }
    
}




extension DetatalsViewController:NSTextViewDelegate{
        
    func textDidChange(_ notification: Notification) {
        userMark = textViewUserMark.string
        labUserMark.stringValue = userMark
    }
    
    func textDidEndEditing(_ notification: Notification) {
        userMark = textViewUserMark.string
        let _userMark = userMark.replacingOccurrences(of: " ", with: "")
        if _userMark.count > 0 {//最终的输入数据有效
            labUserMark.stringValue = userMark
            log("输入有效...")
        }else{//输入无效，即全部输入空格
            labUserMark.stringValue = placeholder
            textViewUserMark.string = "";
            userMark = ""
            log("输入无效....  \(_userMark.isEmpty)      \(textViewUserMark.string.isEmpty)")
        }
    }

}

