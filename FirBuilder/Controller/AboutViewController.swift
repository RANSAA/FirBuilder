//
//  AboutViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/2/16.
//

import Cocoa

class AboutViewController: NSViewController {
    var lastVC:NSViewController!

    @IBOutlet var textView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "FirBuilder H5使用说明"
        textView.string = info()
    }

    func info() ->String{
        let info:String = """
        一：简介
                FirBuilder H5是一款类似fir.im应用分发的静态网页生成器。通过解析Android/iOS（以下统称APP）生成静态网页，不需要任何配置，然后发布到支持page的git仓库，或者服务器即可实现APP分发功能。



        二：环境要求
                1.如果只需要解析iOS安装包直接运行即可
                2.如果需要解析Android应用，则需要JAVA运行环境


        三：参数解释
                1.ServerRoot：用于存储资源的git仓库(服务器)根路径，它主要用来为apk提供云存储路径。本应用默认使用腾讯coding仓库来存储资源。
                              例如：coding仓库路径为：https://fir-im.coding.net/p/fir.im/d/AppStore/git/tree/master 那么他对应的资源存储仓库路径：
                              https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/ (注意区别)
                2.重新生成H5：即根据配置会重新生成所有HTML文件，修改ServerRoot后必须执行该操作


        四：使用
                FirBuilder会在当前目录生成H5，然后将文件提交到coding(服务器)上，然后在将sync目录同步到支持page的git仓库即可。




"""
        return info
    }

    @IBAction func btnBackAction(_ sender: Any) {
        goBack()
    }

    
}


extension AboutViewController{
    static func createVC(_ lastVC:NSViewController) -> AboutViewController{
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AboutViewController") as! AboutViewController
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
