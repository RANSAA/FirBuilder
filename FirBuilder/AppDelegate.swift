//
//  AppDelegate.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa
import SDWebImageWebPCoder


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("注意：该程序的ViewController的viewDidLoad方法要比applicationDidFinishLaunching方法先执行")

        // Insert code here to initialize your application
//        Config.setup()


        // Add coder
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)



        print("setup:")
        print(Config.serverRoot)


        test()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func test(){
//        printAny(C())
//        printAny(B())
//        printAny(A())
        let objC = C()
//        objC.test()
//
//        print("objC:\(objC)")
//        objC.printAllIvarList()
//        objC.printAllPropertys()
//        print(address(o: objC))
//        print(objC.eachIvarList())
//        printAllIvar(objC)
//        printAllIvar(object: objC)
//        printAllIvars(objC)
//        print(address(o: objC))
//        let obj2 = objC
//        print(address(o: obj2))

//        let ssd = 123
//        var s = Stu()
//        var ps = s
//        printAllIvars(s)

//        print(address2(o: s))
//        withUnsafePointer(to: &s) {ptr in print(ptr)}
//        withUnsafePointer(to: &ps) {ptr in print(ptr)}
//
//        print(s)

//        getAllIvars(obj2)
//        getAllIvars(ps)

//        Description.getAllIvars(obj2)
//        Description.getAllIvars(ps)

//        FirBuilder.printAllPropertys(object: obj2)

    }

}

