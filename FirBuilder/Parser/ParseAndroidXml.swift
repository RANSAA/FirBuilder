//
//  ParseAndroidXml.swift
//  FirBuilder
//
//  Created by PC on 2022/2/7.
//

import Foundation

/**
 解析apk中的AndroidManifest.xml文件，可以直接使用apkTool工具进行反编译
 */
class ParseAndroidXml:NSObject{
    func parse(path:String){
        print("xml path:\(path)")
//        let fp:FILE = fopen(path, "r")
//        let fileHandle = FileHandle(forWritingAtPath: path)!
//        if let content = try? String(contentsOfFile: path, encoding: .utf8) {
//            print(content)
//        }
//        let data =  fileHandle.readDataToEndOfFile()
//        print("data:\(data)")


//        let fileHandle = FileHandle(forWritingAtPath: path)!
//        fileHandle.seekToEndOfFile()
//        fileHandle.write("hello, world!".data(using: .utf8)!)
//        if #available(OSX 10.15, *) {
//            try? fileHandle.close()
//        } else {
//            // Fallback on earlier versions
//        }
//
//        if let content = try? String(contentsOfFile: path, encoding: .utf8) {
//            print(content)
//        }

//        let data =  fileHandle.readDataToEndOfFile()
//        print("data:\(data)")

//        let c = readFile(filename: path as NSString)
//        print(c)

//        readFile(filename: path as NSString)
        readDataFrom(path: path)
    }

    func readFile(filename: NSString) -> UnsafeMutablePointer<CUnsignedChar>? {

        let pathString:String = String(filename)
        let fp  = fopen(pathString, "r");
//        let fp = fopen(filename.utf8String, "r")
        if fp == nil {
            print("Open File fail!")
            return nil
        }



        fseek(fp, 0, SEEK_END)
        let length = ftell(fp)
        fseek(fp, 0, SEEK_SET)

//        let ln = UnsafeMutablePointer<Int>.allocate(capacity: length)
//        var lineS = fgetln(fp, ln)
//        print(String(cString: lineS!))

//        let ln = UnsafeMutablePointer<Int8>.allocate(capacity: length)
//        let lineS = fgets(ln, 10, fp)!
//        print(String(cString: lineS))


//        let fileHandle = FileHandle(forReadingAtPath: pathString)
//        var rData =  fileHandle?.readData(ofLength: 20)
//        print("data:\(String(data: rData!, encoding: .utf8))")

//        print("ln:\(String(cString: ln))")
//        String(validatingUTF8: ln)

//        String(cString: UnsafePointer<CChar>)


        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        fread(buffer, MemoryLayout<CUnsignedChar>.size, length, fp)
        fclose(fp)
        print(String(cString: buffer))



//        print("buffer:\(String(describing: buffer))")


//        print("length:\(strlen(buffer))")

//        print(buffer.pointee)





        return nil
    }


    func readDataFrom(path:String) -> String{
        let mResultStr:NSMutableString = NSMutableString()
        var resultStr = ""
//        let fp = fopen(path.toNSString().utf8String, "r")
        let fp = fopen(path, "r")
        if fp == nil {
            print("Open File fail!")
            return resultStr
        }

        var ch: Int32 = fgetc(fp)
        while ch != EOF {
            mResultStr.appendFormat("%c", ch)
            resultStr.append(Character(UnicodeScalar(UInt32(ch))!))
            ch = fgetc(fp)
        }
        fclose(fp)



//        print(resultStr)
        print(mResultStr)

        return resultStr
    }

}
