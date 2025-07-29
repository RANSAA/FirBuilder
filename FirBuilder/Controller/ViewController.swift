//
//  ViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    @IBOutlet var topView: NSView!
    @IBOutlet var bottomView: NSView!
    @IBOutlet var addAreaView: NSView!
    @IBOutlet var infoView: NSView!
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var textFieldCoding: NSTextField!

    var titleStr:String = "App分发平台-静态H5生成器"
    var dataArray:[AppHomeTable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            self.afterSetupUI()
        }
    }

    // MARK: afterSetupUI
    /**
     由于不知道是什么原因viewDidLoad()要比AppDlegate中的applicationDidFinishLaunching：方法先调用
     所以这儿的临时解决方案是延迟执行viewDidLoad中的setupUI操作
     */
    func afterSetupUI(){
        print("viewDidLoad")
        self.title = titleStr

        self.topView.wantsLayer = true
        self.topView.layer?.backgroundColor = NSColor.white.cgColor
        self.bottomView.wantsLayer = true
        self.bottomView.layer?.backgroundColor = NSColor.white.cgColor
        self.addAreaView.wantsLayer = true
        self.addAreaView.layer?.backgroundColor = NSColor.gridColor.cgColor
        self.addAreaView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.infoView.wantsLayer = true
        self.infoView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        self.collectionView.wantsLayer = true
        self.collectionView.layer?.backgroundColor = NSColor.white.cgColor

        self.textFieldCoding.stringValue = Config.serverRoot
        
        loadCollectionView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    //添加APP
    @IBAction func btnAddAppAction(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["apk","ipa","tipa"]
        panel.allowsOtherFileTypes = true
        panel.canSelectHiddenExtension = true
        //panel.begin
        panel.beginSheetModal(for: self.view.window!) { (result) in
            if result == .OK{
                let path = panel.url!.path
                log("file path:\(path)")
                if ParserTool.shared.parsing == false {
                    DispatchQueue.global().async {
                        ParserTool.shared.blockStart = {msg in
                            ParserTool.shared.parsing = true
                            self.showLoadHUD()
                        }
                        ParserTool.shared.blockFail = { msg in
                            ParserTool.shared.parsing = false
                            self.openErrorAlert(msg: msg)
                        }
                        ParserTool.shared.blockSuccess = {msg in
                            ParserTool.shared.parsing = false
                            self.loadDataArray()
                            self.openParserSuccess(msg: msg)
                        }
                        ParserTool.shared.blockPrompt = { msg in
                            self.openPromptAlert(msg: msg)
                        }
                        //开始解析任务
                        ParserTool.shared.parserStart(path: path)
                    }
                }else{
                    self.openErrorAlert(msg: "已经存在一个解析任务!")
                }
            }
            panel.close()
        }
    }

    //应用coding url路径
    @IBAction func btnApplyCondingAction(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "修改ServerRoot路径"
        alert.informativeText = "修改地址后需要运行【重新生成H5】才会更改已经生成的静态文件"
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .critical
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            print("ok")
            resetServerRoot()
        }else{
            print("cancel")
        }

    }

    func resetServerRoot(){
        let path = self.textFieldCoding.stringValue
        if path.count > 8 {
            let endIndex =  path.index(path.startIndex, offsetBy: 4)
            let hexf:String = String(path[...endIndex])
            if hexf == "https" {
                if path.last == "/" {
                    Config.resetServerRoot(serverRoot: path)
                    openParserSuccess(msg: "资源根路劲修改成功")
                }else{
                    openErrorAlert(msg: "ServerRoot路径必须以\"/\"结尾")
                }
            }else{
                openErrorAlert(msg: "ServerRoot路径必须为https类型")
            }
        }else{
            openErrorAlert(msg: "输入的地址错误")
        }
    }

    //重新生成所有的H5网页
    @IBAction func btnBuilderAllH5Action(_ sender: Any) {
        BuilderAppRes.rebuilderAllHTML()
        openParserSuccess(msg: "H5重新生成完成")
    }

    @IBAction func btnHelpAction(_ sender: Any) {
        let vc = AboutViewController.createVC(self)
        vc.push()
    }

    
    @IBAction func btnPreviewAction(_ sender: Any) {
        openBrowser()
    }
    
    
    /** 将数据同步到Netlify */
    @IBAction func btnSyncNetlifyAction(_ sender: NSButton) {
        let task = ProcessTask.shared.processSyncNetlify()
        do {
            try task.run()
        } catch  {
            let msg = "直接部署到Netlify.command脚本执行失败 - error:\(error)"
            log(msg)
            ParserTool.shared.blockPrompt?(msg)
        }
    }
    
}


extension ViewController{
    func loadCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isSelectable = true

        let nib = NSNib.init(nibNamed: NSNib.Name("HomeImgItem"), bundle: nil)
        self.collectionView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeImgItem"))

        //设置item的大小以及间距
        let layout = self.collectionView.collectionViewLayout as! NSCollectionViewFlowLayout
        layout.itemSize = .init(width: 265, height: 343)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        loadDataArray()
    }

    func loadDataArray(){
        dataArray.removeAll()
        let db = DBService.shared.db
        defer {
            db.close()
        }
        let list:[AppHomeTable]? = try? db.getObjects(fromTable: AppHomeTable.tableName,orderBy: [AppHomeTable.Properties.updateDate.asOrder(by: .descending)])
        if list != nil {
            dataArray = list!
        }
        DispatchQueue.main.async {
            self.collectionView .reloadData()
        }
    }

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataArray.count
    }

    //返回对应的item自定义个体
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HomeImgItem"), for: indexPath) as! HomeImgItem
        let model = self.dataArray[indexPath.item]
        let imgPath = Config.htmlPath+model.srcRoot!+model.logo512Path!
        view.imgVIew.image = ImageTool.loadImageFrom(path: imgPath)
        view.appName.stringValue = model.name ?? "unknown"
        view.bundleID.stringValue = model.bundleID!
        view.version.stringValue = model.version!+" (Build \(model.build!))"
        view.updateDate.stringValue = DateFormatter.dateStringWith(date: model.updateDate)
        view.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/android.png")
        if model.type == .ios {
            view.imgType.image = NSImage(byReferencingFile: Config.appPath+"src/images/apple.png")
        }
        return view
    }


    //当item被选中
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print(indexPaths)
        let set = indexPaths.first!
        let section = set.section
        let row = set.item
        print(("section:\(section)  row:\(row)"))
        collectionView.reloadData()

        jumpTo(row: row)


//        let view = collectionView.item(at: indexPaths.first!) as! HomeImgItem
//        view.updateStatus()
    }

   //当item取消选中
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
//        let view = collectionView.item(at: indexPaths.first!) as! HomeImgItem
//        view.updateStatus()
    }

    func jumpTo(row:Int){
        let model = self.dataArray[row]
        let vc = ListViewController.createVC(self)
        vc.pushItem = model
        vc.push()
    }

}



//Alert
extension ViewController{

    func openErrorAlert(type:String){
        DispatchQueue.main.async {
            MacProgressHUD.removeAllHUD()
            let alert = NSAlert()
            alert.messageText = "警告,当前选中的不是标准的\(type)文件！"
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .critical
            alert.runModal()
        }
    }


    func openErrorAlert(msg:String){
        DispatchQueue.main.async {
            MacProgressHUD.removeAllHUD()
            let alert = NSAlert()
            alert.messageText = msg
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .critical
            alert.runModal()
        }
    }
    
    func openPromptAlert(msg:String){
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = msg
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    static func openPromptAlert(msg:String){
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = msg
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }

    func openParserSuccess(msg: String){
        DispatchQueue.main.async {
            MacProgressHUD.removeAllHUD()
            let alert = NSAlert()
            alert.messageText = msg
            alert.addButton(withTitle: "知道了")
            alert.alertStyle = .informational
            alert.runModal()
        }
    }

    
    
    
    func showLoadHUD(){
        DispatchQueue.main.async {
            MacProgressHUD.showWaiting(withPointColor: NSColor.white)
            //MacProgressHUD.showWaiting(withTitle: "2324", time: 3)
        }
    }
    
    func openNewWindow(){
        MacProgressHUD.removeAllHUD()
        DispatchQueue.main.async {
            let vc = AddViewController()
            //self.controller.presentAsSheet(vc)
            self.presentAsModalWindow(vc)
        }
    }
    

    func openBrowser(){
        let path = Config.htmlPath + "index.html"
        if FileManager.default.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            NSWorkspace.shared.open(url)
        }
    }
    
}
