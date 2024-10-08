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
## 简介:
FirBuilder H5是一款类似fir.im应用分发的静态网页生成器。通过解析Android/iOS（以下统称APP）生成静态网页;
不需要任何配置，然后发布到支持page的git仓库，或者服务器即可实现APP分发功能。


## 环境要求:
1. 如果只需要解析iOS安装包直接运行即可
2. 如果需要解析Android应用，则需要JAVA运行环境；找到App应用包->显示包内容->然后找到ProcessTask.plist文件，修改其中JAVA_HOME的值即可。


## 参数解释:
1.ServerRoot：服务器存放HTML等资源文件的根路径(或者git仓库)它主要用来为apk提供云存储路径，即：ServerRoot+index.html能正常访问。
    例如：coding仓库路径为：https://fir-im.coding.net/p/fir.im/d/AppStore/git/tree/master ,那么对应的仓库路径：
    https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/
    或者：
    https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/自定义路径/
本应用默认使用腾讯coding仓库来存储资源。
警告：由于coding经过改版需要登录才能访问资源，所以现在不推荐使用coding存放资源，推荐使用Netlify。如果你的网速足够快可以直接使用github。

2.重新生成H5：即根据配置会重新生成所有HTML文件，修改ServerRoot后必须执行该操作


## 使用:
FirBuilder会在当前目录下生成html和html-sync两个目录，html-sync是同步目录其中是没有APP资源文件的，
如果有自己的服务器直接将html中的文件上传到服务器即可；（github,Netfily直接同步html目录即可）
如果没有可以使用将html推送到git仓库，html-sync同步到静态托管网站即可


## 警告⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
1.目前coding已经不能使用了，直接切换到Netlify即可。
2.目前已经支持CLI模式，直接在终端执行程序，并输入：-h，即可查询使用方法

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
