//
//  ParserTool.swift
//  FirBuilder
//
//  Created by PC on 2022/11/17.
//

import Foundation
import WCDBSwift
import KakaJSON




struct ParserTool {
    static var shared = ParserTool()
    
    //是否有解析任务
    var parsing = false

    typealias ParserBlock = (_ msg:String) -> Void
    var blockStart:ParserBlock?
    var blockFail:ParserBlock?
    var blockSuccess:ParserBlock?
    var blockMsg:ParserBlock?
    
    func parserStart(path:String){
        blockStart?("开始解析:\(path)")
        
        let type = ParserType.checkType(path: path)
        switch type {
        case .unknown:
            blockFail?("解析错误，文件不存在或者不支持改格式。 file：\(path)")
        case .ios, .android:
            let unzip = UnZipApp()
            unzip.start(path:path, type:type)
        }
    }
    
    static func msg(_ msg:String...){
        print(msg)
    }
    
    /** 清除解析垃圾*/
    static func clean(){
       try? FileManager.default.removeItem(atPath: Config.unzipPath)
    }
}
