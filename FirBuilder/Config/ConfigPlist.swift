//
//  ConfigPlist.swift
//  FirBuilder
//
//  Created by kimi on 2023/2/27.
//

import Foundation
import KakaJSON


class ConfigPlist:NSObject{
    var url:String = "https://fir-im.coding.net/p/fir.im/d/AppStore/git/raw/master/"
    var isExitClean:Bool = false

    var mark:[String:String] = [
        "url":"",
        "isExitClean":"程序退出时是否清理.unzip目录"
    ]
    
    static var shared:ConfigPlist = {
        var obj = ConfigPlist()
        obj.readData()
        return obj
    }()

    
    private func readData(){
        let path:String = Config.configPath
        if let plist = NSDictionary(contentsOfFile: path){
            if let url = plist["url"] as? String {
                self.url = url
            }
            if let isExitClean = plist["isExitClean"] as? Bool {
                self.isExitClean = isExitClean
            }
            if let mark = plist["mark"] as? [String:String] {
                self.mark = mark
            }
        }else{
            self.save()
        }
    }
    
    func save(){
        let path:String = Config.configPath
        let plist = NSMutableDictionary(dictionaryLiteral: ("url",self.url),
                                        ("isExitClean",self.isExitClean),
                                        ("mark",self.mark)
                                        )
        plist.write(toFile: path, atomically: true)

    }
    
    
}
