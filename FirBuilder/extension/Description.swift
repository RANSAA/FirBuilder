//
//  Description.swift
//  FirBuilder
//
//  Created by PC on 2022/2/8.
//

import Foundation



/**
 直接打印变量的description描述信息
 PS:printAny与descriptionAny方法实现二选一即可
 */
public func printAny(_ object: Any?){
    if let model = object {
        print("<\(type(of: model))>")
        //利用反射获取属性类型和值
        Mirror(reflecting: model).children.forEach { (child) in
            if let porperty = child.label{
                print("    \(porperty): \(child.value) ")
            }
        }
        print("<\(type(of: model))>")
    }else{
        print("nil")
    }
}


/**
 获取变量的描述信息，使用方法：需要继承NSObject或者实现CustomStringConvertible，CustomDebugStringConvertible协议
 并在description方法执行descriptionAny(self)即可.
 PS:printAny与descriptionAny方法实现二选一即可
 */
public func descriptionAny(_ object: AnyObject?) -> String{
    if let model = object {
        let adr = address(o: model)
        let clsName = "\(type(of: model))"
        var des:String = "<\(clsName):\(adr)\n"
        //利用反射获取属性类型和值
        Mirror(reflecting: model).children.forEach { (child) in
            if let porperty = child.label{
                des += "    \(porperty): \(child.value)\n"
            }
        }
        des += "\(clsName):\(adr)>\n"
        return des
    }else{
        return ""
    }
}



// MARK: 获取变量内存地址
func address<T: AnyObject>(o: T) -> String {
    return String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
}

func address(o: UnsafeRawPointer) -> String {
    return String.init(format: "%018p", Int(bitPattern: o))
}
