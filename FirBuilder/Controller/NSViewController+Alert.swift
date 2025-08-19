//
//  NSViewController+Alert.swift
//  FirBuilder
//
//  Created by kimi on 2025/8/18.
//

import Foundation
import ObjectiveC



//Alert
extension NSViewController{

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

    /**
     功能：显示确认提示Alert
     title：标题
     msg：消息描述
     style：NSAlert.Style
     blockOK：确认回调
     blockCancel：取消回调
     */
    func openConfirmAlert(title:String, msg:String, style:NSAlert.Style = .critical,  blockOK: (() -> Void)?, blockCancel: (() -> Void)?  ){
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = msg
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .critical
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            print("ok")
            blockOK?()
        }else{
            print("cancel")
            blockCancel?()
        }
    }
    
    /**
     功能：显示确认提示Alert
     title：标题
     msg：消息描述
     style：NSAlert.Style
     blockOK：确认回调
     blockCancel：取消回调
     */
    static func openConfirmAlert(title:String, msg:String, style:NSAlert.Style = .critical,  blockOK: (() -> Void)?, blockCancel: (() -> Void)?  ){
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = msg
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .critical
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            print("ok")
            blockOK?()
        }else{
            print("cancel")
            blockCancel?()
        }
    }

    
}





//MARK: - 控制器切换

private var associatedObjectKeyLastViewController: UInt8 = 0
extension NSViewController{
    // 添加一个自定义方法，用于清除所有关联属性
    func clearAssociatedObject() {
        objc_removeAssociatedObjects(self)
    }
    
    /** 上一个显示的视图控制器 */
    var lastViewController:NSViewController?{
        get{
            return objc_getAssociatedObject(self, &associatedObjectKeyLastViewController) as? NSViewController
        }
        set{
            objc_setAssociatedObject(self, &associatedObjectKeyLastViewController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    

    
    /** 将指定控制器添加到keyWindow上*/
    func presentToKeyWindow(controller:NSViewController){
        controller.lastViewController = self
        controller.view.frame = self.view.frame
        NSApplication.shared.keyWindow?.contentViewController = controller
        
//        self.presentAsModalWindow(controller)
//        self.presentAsSheet(controller)
    }
    
    /** 将当前控制器从keyWindow上移除，并显示上一个viewController */
    func dismissFromKeyWindow(){
        guard let lastViewController = self.lastViewController else{
            return
        }
        lastViewController.view.frame = self.view.frame
        NSApplication.shared.keyWindow?.contentViewController = lastViewController
        
//        self.view.window?.close()
//        dismiss(lastVC)
    }
    
}



