//
//  Description.swift
//  FirBuilder
//
//  Created by PC on 2022/2/8.
//

import Foundation



// MARK: - 获取变量内存地址
func address<T: AnyObject>(o: T) -> String {
//    let res = "\(Unmanaged<AnyObject>.passUnretained(o).toOpaque())"
    let res = String.init(format: "%018p", unsafeBitCast(o, to: Int.self))
    return res
}

func address(o: UnsafeRawPointer) -> String {
    return String.init(format: "%018p", Int(bitPattern: o))
}



// MARK: - Swift：使对象自动支持description的解决方法
/**
 要求：需要继承NSObject或者实现CustomStringConvertible，CustomDebugStringConvertible协议
 并在 var description:String{ get }协议中实现下列操作
 var description:String {
     return printAllIvars(self, false)
 }
 */




// MARK: - 获取class中的所有属性名称，变量名称， 利用objc runtime 特性获取

/**
 获取指定class对象的变量名，PS:不包括父类变量
 */
public func getAllIvars(class cls:AnyClass?) -> [String]{
    var result = [String]()
    let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
    let buff = class_copyIvarList(cls, count)
    let countInt = Int(count[0])
    for i in 0..<countInt {
        if let temp = buff?[i],let cname = ivar_getName(temp) {
            let proper = String(cString: cname)
            result.append(proper)
        }
    }
    free(count)
    free(buff)
    return result
}



/**
 获取class变量的所有属性名， PS:只能获取被@objc标记的属性
 - object:目标对象
 - hasSuper:是否获取父类属性，默认 true
 - return: 返回属性名列表
 */
public func getAllPropertys(object:AnyObject?, _ hasSuper:Bool = true) -> [String]{

    func getCurrentPropertys(class cls:AnyClass?) -> [String]{
        var result: Set<String> = Set()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(cls, count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            if let temp = buff?[i] {
                let cname = property_getName(temp)
                let proper = String(cString: cname)
                result.insert(proper)
            }
        }
        free(count)
        free(buff)
        return Array(result)
    }


    var res: Set<String> = Set(getCurrentPropertys(class: object_getClass(object)))
    if hasSuper == true {
        var superCls:AnyClass? = object?.superclass
        while superCls != nil {
            let nodeRes = getCurrentPropertys(class: superCls)
            if nodeRes.contains("isa") {
                superCls = nil
            }else{
                res.formUnion(nodeRes)//合并集合
                superCls = superCls?.superclass()
            }
        }
    }
    return Array(res)
}


/**
 打印对象的所有变量与值
 */
public func printAllPropertys(object:AnyObject?, _ hasSuper:Bool = true) {
    let res = getAllPropertys(object:object,hasSuper)
    print(res)
}





// MARK: - Swift:获取任何类型对象中的所有变量名称 -- 使用Mirror反射获取（推荐使用）


/**
 获取对象的所有变量名称
 - any:指定对象
 - hasSuper:是否获取父类的变量，默认 true
 - return 返回变量名列表
 */
@discardableResult
public func getAllIvars(_ any: Any?, _ hasSuper:Bool = true) -> [String]{
    var result:[String] = []
    if let any = any {
        let mirror = Mirror(reflecting: any)
        mirror.children.forEach { (child) in
            if let porperty = child.label{
                result.append(porperty)
            }
        }
        if hasSuper == true {
            var superMirror = mirror.superclassMirror
            while superMirror != nil {
                superMirror?.children.forEach { (child) in
                    if let porperty = child.label{
                        result.append(porperty)
                    }
                }
                superMirror = superMirror?.superclassMirror
            }
        }
    }
    print("result:\(result)")
    return result
}



/**
 打印对象所有变量名与值,并返回
 - object:打印的Any对象
 - hasSuper:是否获取父类的变量，默认 true
 - hasAddress:是否打印class变量的内存地址，默认 true
 - isPrint:是否打印信息 默认 true
 - return 返回打印信息
 */
@discardableResult
public func printAllIvars(_ any: Any?, _ hasSuper:Bool = true, _ hasAddress:Bool = true, _ isPrint:Bool = true) -> String{
    var res = ""
    if let model = any {
        let mirror = Mirror(reflecting: model)

        var tagName = "<\(type(of: model))>"
        if hasAddress == true {
            if mirror.displayStyle == Mirror.DisplayStyle.class {
                tagName = "<\(type(of: model)):\(address(o: model as AnyObject))>"
            }
        }
        res += tagName + "\n"

        mirror.children.forEach { (child) in
            if let porperty = child.label{
                res += "    \(porperty): \(child.value)\n"
            }
        }

        if hasSuper == true {
            var superMirror = mirror.superclassMirror
            while superMirror != nil {
                superMirror?.children.forEach { (child) in
                    if let porperty = child.label{
                        res += "    \(porperty): \(child.value)\n"
                    }
                }
                superMirror = superMirror?.superclassMirror
            }
        }
        res += tagName
    }else{
        res += "nil"
    }
    if isPrint {
        print(res)
    }
    return res
}


