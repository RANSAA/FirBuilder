//
//  AppDelegate+Exit.swift
//  FirBuilder
//
//  Created by PC on 2022/5/27.
//

import Foundation

extension AppDelegate{

    /**
     添加左上角的Quit按钮与关闭按钮监听
     */
   func addQuitActions(){
    //左上角quit
        let application = NSApplication.shared
        let items = application.mainMenu?.items.first?.submenu?.items.last
        items?.target = self
        items?.action = #selector(quitMeunExitAction)

        //监听关闭按钮
//        NotificationCenter.default.addObserver(self, selector: #selector(quitMeunExitAction), name:NSWindow.willCloseNotification , object: nil)
    }

    @objc
    private func quitMeunExitAction(){
        print("左上角右键quit按钮退出程序")
        self.terminateApp()
//        NSApplication.shared.terminate(nil)
        exit(0)
    }


    //点击左上角 x 关闭程序
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        print("点击 x 关闭程序。。。")
        self.terminateApp()
        return true
    }

    //dock右键退出
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if ExitHolder.once == false {//防止点击左上角 x 关闭程序时会调用该退出方法
            exit(0)
        }
        print("dock右键退出")
        self.terminateApp()
        return .terminateNow
    }


    @objc
    private func terminateApp(){
        if ExitHolder.once {
            ExitHolder.once = false
            
            
            //清除程序运行产生的垃圾
            print("清理正在运行的任务....")
            ProcessTaskConfig.shared.clearTmp()
            ProcessTaskConfig.shared.clearLog()
        }
    }

    struct ExitHolder {
        static var once = true
    }
}
