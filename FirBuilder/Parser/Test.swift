//
//  Test.swift
//  FirBuilder
//
//  Created by PC on 2022/5/26.
//

import Foundation

class A:NSString{
    var a = "aa"
    var a1 = "aa"
    var a2 = "aa"
    var a3 = "aa"
    var a4 = "aa"
    var a5 = "aa"

//    override func value(forUndefinedKey key: String) -> Any?{
//        return nil
//    }

//    override var description: String{
//        "123"
//    }
}

@objcMembers class B:A{
     var b2 = "bb"
}

@objcMembers class C: B {
      var cccc = "cc"
     var tt:Bool?

//    override func value(forUndefinedKey key: String) -> Any?{
//        return nil
//    }

//    func test(){
//        let res = self.getAllIvarList(cls: object_getClass(self))
//        print(res)
//        if let superModel = self.superclass {
//            print("superClsss:\(superModel)")
//            let res = self.getAllIvarList(cls: superModel)
//            print(res)
//            if let superModel = self.superclass?.superclass() {
//                print("superClsss:\(superModel)")
//                let res = self.getAllIvarList(cls: superModel)
//                print(res)
//
//            }
//            if let superModel = self.superclass?.superclass()?.superclass() {
//                print("superClsss:\(superModel)")
//                let res = self.getAllIvarList(cls: superModel)
//                print(res)
//
//            }
//            if let superModel = self.superclass?.superclass()?.superclass()?.superclass() {
//                print("superClsss:\(superModel)")
//                let res = self.getAllIvarList(cls: superModel)
//                print(res)
//
//            }
//            if let superModel = self.superclass?.superclass()?.superclass()?.superclass()?.superclass() {
//                print("superClsss:\(superModel)")
//                let res = self.getAllIvarList(cls: superModel)
//                print(res)
//
//            }
//        }
//    }

//    func eachIvarList(){
//        var res = self.getAllIvarList(cls: object_getClass(self))
//        var superCls:AnyClass? = self.superclass
//        while superCls != nil {
//            let nodeRes = self.getAllIvarList(cls: superCls)
//            if nodeRes.contains("isa") {
//                superCls = nil
//            }else{
//                res += nodeRes
//                superCls = superCls?.superclass()
//            }
//        }
//        print(res)
////        let keyPath = #keyPath("C.c")
//
//    }
}


struct Stu {
    var d = 1
    var c = 2
    var dd = 3
    var def = 4
}
