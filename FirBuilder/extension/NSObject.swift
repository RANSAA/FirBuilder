//
//  NSObject.swift
//  FirBuilder
//
//  Created by PC on 2022/2/8.
//

import Foundation


/**
 1.直接利用NSObject对象的kvc特性节课
 2.需要获取属性与变量名称直接使用Description.swift文件中的全局方法即可
 */
extension NSObject{
    /**
     获取对象对于的属性值，无对于的属性则返回NIL
     - parameter property: 要获取值的属性
     - returns: 属性的值
     */
//    func getValueOfProperty(property:String)->AnyObject?{
//        let allPropertys = self.getAllPropertys()
//        if(allPropertys.contains(property)){
//            return self.value(forKey: property) as AnyObject
//        }else{
//            return nil
//        }
//    }

    /**
     设置对象属性的值
     - parameter property: 属性
     - parameter value:    值
     - returns: 是否设置成功
     */
//    func setValueOfProperty(property:String,value:AnyObject)->Bool{
//        let allPropertys = self.getAllPropertys()
//        if(allPropertys.contains(property)){
//            self.setValue(value, forKey: property)
//            return true
//        }else{
//            return false
//        }
//    }

    

    /**
     获取对象的所有属性名称
     PS:注意无法获取值为nil的属性名称
     */
//    func getAllPropertys() -> [String] {
//        var result = [String]()
//        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
//        let buff = class_copyPropertyList(object_getClass(self), count)
//        let countInt = Int(count[0])
//        for i in 0..<countInt {
//            if let temp = buff?[i] {
//                let cname = property_getName(temp)
//                let proper = String(cString: cname)
//                result.append(proper)
//            }
//        }
//        free(count)
//        free(buff)
//        return result
//    }

    /**
     获取对象的所有成员变量名称
     */
//    func getAllIvarList() -> [String] {
//        var result = [String]()
//        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
//        let buff = class_copyIvarList(object_getClass(self), count)
//        let countInt = Int(count[0])
//        for i in 0..<countInt {
//            if let temp = buff?[i],let cname = ivar_getName(temp) {
//                let proper = String(cString: cname)
//                result.append(proper)
//            }
//        }
//        free(count)
//        free(buff)
//        return result
//    }

}

