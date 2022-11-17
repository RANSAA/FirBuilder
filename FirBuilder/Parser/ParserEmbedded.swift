//
//  ParserEmbedded.swift
//  FirBuilder
//
//  Created by PC on 2022/5/25.
//

import Foundation
import Cocoa
import KakaJSON
//import HandyJSON



// 解析ipa的embedded.mobileprovision文件
@objcMembers class ParserEmbedded:Convertible{
    var localProvision:Bool = false         //true = 本地签名标记
    var provisionsAllDevices:Bool = false   //true = Enterprise
    var provisionedDevices:[String] = []    //count>0 = ad-Hoc
    var creationDate:Date = Date() //证书创建时间
    var cxpirationDate:Date = Date() //证书过期时间
    var platform:[String] = [] //平台类型
    var hasValid:Bool = true //mobileprovision文件是否有效或存在
    
    /**
     签名类型：
     0: 未知
     1: XCode 测试签名(7天)
     2: 企业签名
     3: Ad-Hoc签名
     */
    var signType:Int{
        if hasValid == false {
            return 0
        }
        if localProvision == true {
            return 1
        }
        if provisionsAllDevices == true {
            return 2
        }
        if localProvision == false && provisionsAllDevices == false {
            return 3
        }
        return 0
    }

    required  init(){}


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
            if let dic = NSDictionary(contentsOfFile: toPlistPath) {
                
//                print("embedded filePath:\(path)")
//                print("embedded toPlistPath:\(toPlistPath)")
//                print("embedded:\n\(dic)\nembedded:")
                
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

                //处理，并判断类型
            }else{
                self.hasValid = false
                print("不是标准的smobileprovision文件")
            }
        }else{
            self.hasValid = false
            print("mobileprovision文件不存在")
        }
    }

    
    init(filePath path:String){

//        let fileName = path.fileName
//        let index = path.findLast(fileName)
//        let dir = path.subStringTo(index)
//        let plistPath = dir + "embedded.plist"
        
//        let path = "/Users/kimi/资料/ipa/AdHoc.mobileprovision"
        let plistPath = Config.unzipPath + "\(arc4random()%1000)-" + "embedded.plist"
        self.readToSavePlist(filePath: path, toPlistPath: plistPath)
    }


}
