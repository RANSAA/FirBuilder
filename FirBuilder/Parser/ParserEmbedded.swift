//
//  ParserEmbedded.swift
//  FirBuilder
//
//  Created by PC on 2022/5/25.
//

import Foundation
import Cocoa
import KakaJSON
import HandyJSON



// 解析ipa的embedded.mobileprovision文件
@objcMembers class ParserEmbedded:NSObject, HandyJSON{

    var localProvision:Bool = false         //true = 本地签名标记
    var provisionsAllDevices:Bool = false   //true = Enterprise
    var provisionedDevices:[String] = []    //count>0 = ad-Hot
    var creationDate:Date = Date()
    var cxpirationDate:Date = Date()
    var platform:[String] = []

    var test:Bool?

    required  override init(){}


    /**
     读取.mobileprovision文件
     */
     func readEmbeddedFile(path:String) -> String?{
        if let resultStr = String.read(filePath: path) {
            let startInt = resultStr.findFirst("<?xml")
            let lastIndex = resultStr.findLast("</plist>")

            if  startInt == -1 || lastIndex == -1 {
                print("mobileprovision文件解析失败！")
                return nil
            }else{
                let start = resultStr.index(resultStr.startIndex, offsetBy: startInt)
                let end = resultStr.index(resultStr.startIndex, offsetBy: lastIndex+7)

                let str = String(resultStr[start...end])
                return str
            }
        }else{
            print("mobileprovision文件解析失败！")
            return nil
        }
    }


    /**
     读取.mobileprovision文件中的xml数据部分，并保存到plist文件中
     */
     func readToSavePlist(filePath path:String, toPlistPath:String){
        if let str = self.readEmbeddedFile(path: path) {
            try? str.write(toFile: toPlistPath, atomically: true, encoding: .utf8)

            let dic:NSDictionary = NSDictionary(contentsOfFile: toPlistPath)!
            print("dict:\n\(dic)")

            if let dic = NSDictionary(contentsOfFile: toPlistPath) {
                if let localProvision = dic["LocalProvision"] as? Bool  {
                    self.localProvision = localProvision
                    print("本地签名，不可上传")
                }

                if let provisionsAllDevices = dic["ProvisionsAllDevices"] as? Bool{ //Enterprise
                    self.provisionsAllDevices = provisionsAllDevices
                }

                if let provisionedDevices = dic["ProvisionedDevices"] as? [String] { //ad-hot
                    self.provisionedDevices = provisionedDevices
                }

                if let creationDate = dic["CreationDate"] as? Date{
                    self.creationDate = creationDate
                }

                if let cxpirationDate = dic["ExpirationDate"] as? Date{
                    self.cxpirationDate = cxpirationDate
                }

                if let platform = dic["Platform"] as? [String]{
                    self.platform += platform
                }


                print(self.getAllPropertys())
                print(self.getAllIvarList())
                self.printAllIvarList()

                //处理，并判断类型
            }

        }
    }

    override func value(forUndefinedKey key: String) -> Any?{
        return nil
    }

    
    init(filePath path:String){
        super.init()
        let fileName = path.fileName
        let index = path.findLast(fileName)
        let dir = path.subStringTo(index)
        let plistPath = dir + "embedded.plist"
        self.readToSavePlist(filePath: path, toPlistPath: plistPath)
    }



    func all(){
        let tag = "\(self)"
        var res = "\(tag)\n"

        var count : UInt32 = 0
        let ivars = class_copyIvarList(ParserEmbedded.self,&count)!
        for i in 0..<count{
            let nameP = ivar_getName(ivars[Int(i)])!
            let name = String(cString:nameP)
            if let value = self.value(forKey: name) {
                res += "\(name): \(value)\n"
            }else{
                res += "\(name): nil\n"
            }
         }
        res += "\(tag)\n"
        free(ivars)
        print(res)

    }

//    //获取一个类的所有属性
//    func getAllPropertys(view: Any?) -> [String] {
//        var result = [String]()
//        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
//        let buff = class_copyPropertyList(object_getClass(view), count)
//        let countInt = Int(count[0])
//        for i in 0..<countInt {
//            if let temp = buff?[i] {
//                let cname = property_getName(temp)
//                let proper = String(cString: cname)
//                result.append(proper)
//            }
//        }
//        return result
//    }
//
//    //获取一个类的成员变量
//    func getAllIvarList(view: Any?) -> [String] {
//        var result = [String]()
//        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
//        let buff = class_copyIvarList(object_getClass(view), count)
//        let countInt = Int(count[0])
//        for i in 0..<countInt {
//            if let temp = buff?[i],let cname = ivar_getName(temp) {
//                let proper = String(cString: cname)
//                result.append(proper)
//            }
//        }
//        return result
//    }



    static func test (){
        let path = "/Users/kimi/资料/ipa/Development.mobileprovision"
//        let plistPath = "/Users/kimi/Desktop/embedded.plist"
//        let obj = ParserEmbedded(filePath: path)
//        obj.readToSavePlist(filePath: path, toPlistPath: plistPath)

        ParserEmbedded(filePath: path)

    }
}


////用户类
//class User: NSObject{
//    @objc var name:String = ""  //姓名
//    @objc var age:Int = 0  //年龄
//
//    func test(){
//        //创建一个User实例对象
//        let user1 = User()
//        user1.name = "hangge"
//        user1.age = 100
//
//        //使用KVC取值
//        let name = user1.value(forKeyPath: #keyPath(User.name))
//        print(name)
//    }
//}


