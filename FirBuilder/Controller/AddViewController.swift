//
//  AppAddViewController.swift
//  FirBuilder
//
//  Created by PC on 2022/2/6.
//

import Cocoa

class AddViewController: NSViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App信息";
        let width = NSApplication.shared.mainWindow!.frame.size.width
        self.view.frame = NSMakeRect(0, 0, width, 200)
//        self.view.frame = NSApplication.shared.mainWindow!.frame;
    }

    override func loadView() {
        let view = NSView()
        self.view = view
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        //禁止拖动修改frame大小
        self.view.window?.styleMask.remove(.resizable)
    }

}
