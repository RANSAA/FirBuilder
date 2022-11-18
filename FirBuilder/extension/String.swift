//
//  String.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa

//MARK: subString
extension String {

    /**
     截取字符串：从index到结束处
     - Parameter index: 开始索引
     - Returns: 子字符串
     */
    func subStringFrom(_ index: Int) -> String {
        let theIndex = self.index(self.endIndex, offsetBy: index - self.count)
        return String(self[theIndex..<endIndex])
    }

    /**
     截取字符串：从开始到index处
     - Parameter index: 索引结束位置
     - Returns: 子字符串
     */
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
    }

    /**
     获取指定位置的一个字符
     return 返回String
     */
    func getOneStringWith(_ index:Int) -> String{
        let subIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[subIndex])
    }


    /**
     功能:从0索引处开始向后查找第一次出现subString的位置
     return -1:表示没有找到。
     */
     func findFirst(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .literal ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }

    /**
     功能:从结尾处开始向前查找第一次出现subString的位置
     return -1:表示没有找到。
     */
     func findLast(_ sub:String)->Int {
         var pos = -1
         if let range = range(of:sub, options: .backwards ) {
             if !range.isEmpty {
                 pos = self.distance(from:startIndex, to:range.lowerBound)
             }
         }
         return pos
     }

    /**
     功能:从指定索引(begin)处向后查找第一次出现subString的位置
     return -1:表示没有找到。
     */
     func findFirst(_ sub:String,_ begin:Int)->Int {
        let str:String = self.subStringFrom(begin)
        let pos:Int = str.findFirst(sub)
         return pos == -1 ? -1 : (pos + begin)
     }

    /**
     功能:从指定索引(begin)处向前开始查找第一次出现subString的位置
     return -1:表示没有找到。
     */
     func findLast(_ sub:String,_ begin:Int)->Int {
        let str:String = self.subStringFrom(begin)
        let pos:Int = str.findLast(sub)
         return pos == -1 ? -1 : (pos + begin)
     }
 }


// MARK: NSRange 与 Range互相转换
extension String{

    /**  Range转换为NSRange */
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
          guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
              return NSMakeRange(0, 0)
          }
          return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
      }


    /** NSRange转换为Range */
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

}


// MARK: File Name
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

    public static func read(filePath path:String) -> String? {
        guard let fp = fopen(path, "r") else {
            return nil
        }
        defer {
            fclose(fp)
        }
        var resultStr = ""
        var ch: Int32 = fgetc(fp)
        while ch != EOF {
            //NSMutableString.appendFormat("%c", ch)
            resultStr.append(Character(UnicodeScalar(UInt32(ch))!))
            ch = fgetc(fp)
        }
        return resultStr
    }
}



// MARK: String.Encoding编码扩展
extension String.Encoding{
    //GBK原始获取方式
    //let cfEnc = CFStringEncodings.GB_18030_2000
    //let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
    //let gbk = String.Encoding.init(rawValue: enc)
    //enc的值为：2147485234，所以可以直接使用这个值创建GBK编码
    //GBK编码, 使用GB18030是因为它向下兼容GBK
    public static let gbk: String.Encoding = .init(rawValue: 2147485234)

}




// MARK: Base64 safe url
extension String{

    //Base64 编码
    public func encBase64() -> String{
        var base64String = ""
        if let data = self.data(using: .utf8) {
            base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        }else{
            print("⚠️ Base64 编码失败!")
        }
        return base64String
    }

    //Base64 解码
    public func decBase64() -> String{
        var decodeString = ""
        if let deData = Data(base64Encoded: self, options: .init(rawValue: 0)) {
            decodeString = String(data: deData, encoding: .utf8) ?? decodeString
        }else{
            print("⚠️ Base64 解码失败!")
        }
        return decodeString
    }



    //Base64 url safe 编码
    public func encBase64WebSafe() ->String{
        var base64String = ""
        if let data = self.data(using: .utf8) {
            base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            // %替换为_
            base64String = base64String.replacingOccurrences(of: "%", with: "_")
            // =替换为空
            base64String = base64String.replacingOccurrences(of: "=", with: "")
            // +替换为—
            base64String = base64String.replacingOccurrences(of: "+", with: "-")
            // /替换为_
            base64String = base64String.replacingOccurrences(of: "/", with: "_")
        }else{
            print("⚠️ Base64 Url Safe 编码失败!")
        }
        return base64String
    }

    //Base64 url safe 解码
    public func decBase64WebSafe() ->String{
        var decodeString = ""
        // -替换为+
        var base64Str = self.replacingOccurrences(of: "-", with: "+")
        // _替换为/
        base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
        let mod4 = base64Str.count % 4
        if mod4 > 0 {
                let appStr = ("====" as NSString).substring(to: (4 - mod4))
            base64Str += appStr
        }
        if let data = Data(base64Encoded: base64Str, options: .init(rawValue: 0)) {
            decodeString = String(data: data, encoding: .utf8) ?? decodeString
        }else{
            print("⚠️ Base64 Url Safe 解码失败!     original:\(self)")
        }
        return decodeString
    }

}
