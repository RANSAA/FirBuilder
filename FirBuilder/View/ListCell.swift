//
//  ListCell.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa

class ListCell: NSTableCellView {

    @IBOutlet var labName: NSTextField!
    @IBOutlet var img: NSImageView!

    @IBOutlet var labBundle: NSTextField!

    @IBOutlet var labVersion: NSTextField!
    @IBOutlet var labUpdate: NSTextField!

    @IBOutlet var imgType: NSImageView!


    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
