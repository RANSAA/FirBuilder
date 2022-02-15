//
//  String.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

//subString
extension String {
    // 截取字符串：从index到结束处
    // - Parameter index: 开始索引
    // - Returns: 子字符串
    func subStringFrom(_ index: Int) -> String {
        let theIndex = self.index(self.endIndex, offsetBy: index - self.count)
        return String(self[theIndex..<endIndex])
    }

    // 截取字符串：从开始到index处
    // - Parameter index: 索引结束位置
    // - Returns: 子字符串
    func subStringTo(_ index:Int) -> String{
        let toIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[startIndex..<toIndex])
    }

    /**
     获取指定位置的一个字符
     return 返回Character
     */
    func getOneCharacterWith(_ index:Int) -> Character{
        let subIndex = self.index(self.startIndex, offsetBy: index)
        return self[subIndex]
//        let loc = self.distance(from: subIndex, to: self.endIndex)
//        if loc > 0 {
//            return self[subIndex]
//        }else{
//            print("Error: getCharacterWith(_ index:Int) 越界")
//            return " "
//        }
    }

    /**
     获取指定位置的一个字符
     return 返回String
     */
    func getOneStringWith(_ index:Int) -> String{
        let subIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[subIndex])
    }


     //从0索引处开始查找是否包含指定的字符串，返回Int类型的索引
     //返回第一次出现的指定子字符串在此字符串中的索引
     func findFirst(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .literal ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }

     //从0索引处开始查找是否包含指定的字符串，返回Int类型的索引
     //返回最后出现的指定子字符串在此字符串中的索引
     func findLast(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .backwards ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }

     //从指定索引处开始查找是否包含指定的字符串，返回Int类型的索引
     //返回第一次出现的指定子字符串在此字符串中的索引
     func findFirst(_ sub:String,_ begin:Int)->Int {
        let str:String = self.subStringFrom(begin)
        let pos:Int = str.findFirst(sub)
         return pos == -1 ? -1 : (pos + begin)
     }

     //从指定索引处开始查找是否包含指定的字符串，返回Int类型的索引
     //返回最后出现的指定子字符串在此字符串中的索引
     func findLast(_ sub:String,_ begin:Int)->Int {
        let str:String = self.subStringFrom(begin)
        let pos:Int = str.findLast(sub)
         return pos == -1 ? -1 : (pos + begin)
     }
 }


//NSRange 与 Range互相转换
extension String{

    //Range转换为NSRange
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
          guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
              return NSMakeRange(0, 0)
          }
          return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
      }


    //NSRange转换为Range
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

}


extension String{

    //文件扩展名
    var fileExtension: String{
        get{
            if let index = self.lastIndex(of: ".") {
                let startIndex = self.index(after: index)
                let sub = String(self[startIndex...])
                return sub
            }else{
                return ""
            }
        }
    }

    //文件名称
    var fileName: String{
        get{
            var name = ""
            let ary = self.components(separatedBy: "/")
            if let last = ary.last {
                name = last
            }
            return name
        }
    }

    func toNSString() ->NSString{
        return self as NSString
    }

    /**
     功能：从一个二进制文件中读取数据并创建String，读取规则是按照每个字节读取的。读取时与原文件的编码类型无关
     path:BinaryData的文件路径

     其它：
     下面几种方式依然可以利用FILE读取文件，但是如果文件是二进制(无编码，即打开文件呈现乱码的形式)的模式时，将会读取失败，
     读取全部内容
             let ln = UnsafeMutablePointer<Int>.allocate(capacity: length)
             var lineS = fgetln(fp, ln)
             print(String(cString: lineS!))

     读取全部内容，或者指定长度
         fseek(fp, 0, SEEK_END)
         let length = ftell(fp)
         fseek(fp, 0, SEEK_SET)
         let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
         fread(buffer, MemoryLayout<CUnsignedChar>.size, length, fp)//length
         fclose(fp)
         print(String(cString: buffer))

     读取指定长度
             let ln = UnsafeMutablePointer<Int8>.allocate(capacity: length)
             let lineS = fgets(ln, 10, fp)!
             print(String(cString: lineS))
     */
    public init(binaryFilePath path:String){
        var resultStr = ""
        let fp = fopen(path, "r")
        if fp == nil {
            print("Open File fail!  file:\(path)")
            self = resultStr
            return
        }

        var ch: Int32 = fgetc(fp)
        while ch != EOF {
            //NSMutableString.appendFormat("%c", ch)
            resultStr.append(Character(UnicodeScalar(UInt32(ch))!))
            ch = fgetc(fp)
        }
        fclose(fp)
        self = resultStr
    }
}
