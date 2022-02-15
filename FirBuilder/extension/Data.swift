//
//  Data.swift
//  FirBuilder
//
//  Created by PC on 2022/2/7.
//

import Foundation


extension Data{

    /**
     功能：读取二进制文件,按照每一个字节读取。读取时与编码无关

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
    func readBinaryDataFrom(path:String) ->String{
        var resultStr = ""
        let fp = fopen(path.toNSString().utf8String, "r")
        if fp == nil {
            print("Open File fail!")
            return resultStr
        }
        
        var ch: Int32 = fgetc(fp)
        while ch != EOF {
            //NSMutableString.appendFormat("%c", ch)
            resultStr.append(Character(UnicodeScalar(UInt32(ch))!))
            ch = fgetc(fp)
        }
        fclose(fp)
        return resultStr
    }


    //Data转16进制字符串
    func hexString() -> String{
        return self.map{ String($0, radix:16) }.joined()
//        var t = ""
//        let ts = [UInt8](self)
//        for one in ts {
//            t.append(String.init(format: "%02x", one))
//        }
//        return t
    }
}



extension Data{
  

    static func contentsOfPath(_ path:String) -> Data?{
        var data:Data? = nil
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch  {
            print(error)
        }
        return data
    }
    
}
