//
//  HomeImgItem.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa

class HomeImgItem: NSCollectionViewItem {
    @IBOutlet var imgVIew: NSImageView!
    @IBOutlet var appName: NSTextField!

    @IBOutlet var bundleID: NSTextField!

    @IBOutlet var version: NSTextField!

    @IBOutlet var updateDate: NSTextField!
    
    @IBOutlet var imgType: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor  = NSColor.windowBackgroundColor.cgColor


        self.imageView?.wantsLayer = true
        self.imageView?.layer?.backgroundColor = NSColor.white.cgColor

//
//        self.imageView?.wantsLayer = true
//        self.imageView?.layer?.backgroundColor = NSColor.red.cgColor;
//
//        self.imageView?.layer?.masksToBounds = true
//        self.imageView?.layer?.cornerRadius = 100;
//        self.imageView?.layer?.borderWidth = 24;



    }
    
}
