//
//  DeletaButton.swift
//  FirBuilder
//
//  Created by PC on 2022/2/16.
//

import Cocoa

class DeletaButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let cor = NSColor(calibratedRed: 83/255.0, green: 179/255.0, blue: 168/255.0, alpha: 1.0)
        cor.set()
        cor.setFill()
    }
    
}
