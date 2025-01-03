//
//  ListCell.swift
//  FirBuilder
//
//  Created by PC on 2022/2/15.
//

import Cocoa


@objc protocol ListCellDelegate {
    @objc optional func listCell(clickButton btn:NSButton, btnIndex:Int, cellRow:Int)
}

class ListCell: NSTableCellView {

    @IBOutlet var labName: NSTextField!
    @IBOutlet var img: NSImageView!

    @IBOutlet var labBundle: NSTextField!

    @IBOutlet var labVersion: NSTextField!
    @IBOutlet var labUpdate: NSTextField!

    @IBOutlet var imgType: NSImageView!


    weak var delegate:ListCellDelegate?
    var row:Int = 0
    @IBOutlet var btnTop: NSButton!
    @IBOutlet var btnDelete: NSButton!

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.


    }


    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.title = "删除"
        btnTop.title = "置顶"
//        let cor = NSColor(calibratedRed: 83/255.0, green: 179/255.0, blue: 168/255.0, alpha: 1.0)

        btnTop.target = self
        btnTop.action = #selector(clickTap)
        btnDelete.target = self
        btnDelete.action = #selector(clickDelete)


    }

    @objc func clickTap(){
        clickBtn(btn: btnTop, index: 0)
    }

    @objc func clickDelete(){
        clickBtn(btn: btnDelete, index: 1)
    }

    func clickBtn(btn:NSButton, index:Int){
        self.delegate?.listCell?(clickButton: btn, btnIndex: index, cellRow: row)
    }
    
}
