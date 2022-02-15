//
//  AppDelegate.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import SDWebImageWebPCoder


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("注意：该程序的ViewController的viewDidLoad方法要比applicationDidFinishLaunching方法先执行")

        // Insert code here to initialize your application
//        Config.setup()


        // Add coder
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)



        print("setup:")
        print(Config.serverRoot)


    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

