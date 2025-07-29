//
//  AppDelegate.swift
//  FirBuilder
//
//  Created by PC on 2022/1/25.
//

import Cocoa


//使用自定义main函数，具体查看main.swfit
//@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var keyWindow:NSWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        print("注意：该程序的ViewController的viewDidLoad方法要比applicationDidFinishLaunching方法先执行")

        // Insert code here to initialize your application

        
        // Add coder
//        let WebPCoder = SDImageWebPCoder.shared
//        SDImageCodersManager.shared.addCoder(WebPCoder)

        //自定义工具条按钮
        self.addQuitActions()
        
        
//        testShellTask()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    @objc func test(){
//        printAny(C())
//        printAny(B())
//        printAny(A())
//        let objC = C()
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


//        let application = NSApplication.shared
//        _ = application.mainMenu
//        let items = application.mainMenu?.items.first?.submenu?.items.first
//        print(items)
////        print(items?.numberOfItems)
//        print(items)
//
//
//
//        items?.target = self
//        items?.action = #selector(testAction)


    }


//    @objc func testAction(){
//       print("item action...")
//   }

    

    
    //test shell
    func testShellTask(){
//        print("testShellTask.....")
//
//        let unZipPath = Config.unzipPath
//        var lastStr = ""
//
//        let url = URL(fileURLWithPath: "/bin/bash")
//        let arguments = ["-c","java -jar \(Config.apktool) d \"\("path")\" -s -f -o \(unZipPath)"]
//
//        let task = Process()
//        task.executableURL = url
//        task.arguments = arguments
//        task.terminationHandler = { proce in              // 执行结束的闭包(回调)
//            log("apktool task执行完毕 proce:\(proce)")
//        }
//        print(task.environment)
//        print("Config.apktool:\(Config.apktool)")
//        print(ProcessInfo.processInfo.environment)
//
//        // 获取所有环境变量
//        let environment = ProcessInfo.processInfo.environment
//        // 打印所有环境变量
//        for (key, value) in environment {
//            print("\(key): \(value)")
//        }
//        // 获取特定环境变量，例如 PATH
//        if let path = environment["PATH"] {
//            print("PATH: \(path)")
//        } else {
//            print("PATH environment variable not found.")
//        }
        
        
//        print(ProcessTaskPlist.shared);
//        print(ProcessInfo.processInfo.environment);
//        let inputPath = "/Users/kimi/Desktop/Spotube-android-all-arch – 开源跨平台Spotify客户端.apk"
//        let task = ProcessTask.shared.processApktool(filePath: inputPath)
//        task.launch()
//        task.waitUntilExit()
//        ProcessTask.shared.clear()
        
        
//        //Android
//        let inputAndroidPath = "/Users/kimi/Desktop/Spotube-android-all-arch – 开源跨平台Spotify客户端.apk"
//        let decompileAndroid = DecompileAndroid(filePath: inputAndroidPath)
//        decompileAndroid.start()
//        decompileAndroid.done()
//        //校验decompileAndroid.appInfoModel的值是否有效
//        let success = decompileAndroid.verifyAppInfoModel()

        
//        //ios
//        let inputIOSPath = "/Users/kimi/Desktop/AppsManager_1.8.4_Crack.tipa.ipa"
////        let inputIOSPath = "/Users/kimi/Desktop/AppsDump2.ipa"
//        let decIOS = DecompileIOS(filePath: inputIOSPath)
//        decIOS.start()
//        decIOS.done()
//        //校验
//        let success = decIOS.verifyAppInfoModel()
        
        //所有数据构造完毕之后再清除。。
//        if success {//解析成功，清除垃圾文件
//            ProcessTask.shared.clear()
//        }
     
        
    }

}



