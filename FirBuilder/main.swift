//
//  main.swift
//  FirBuilder
//
//  Created by PC on 2022/11/16.
//

import Foundation



//print("argc:\(CommandLine.argc)")
//print("arguments:\(CommandLine.arguments)")
//print("unsafeArgv:\(CommandLine.unsafeArgv)")



private let arguments = CommandLine.arguments
private let argc = CommandLine.argc


//MARK: - CLI 命令提示
if arguments.contains("-h") || arguments.contains("-help"){
    let msg = """
-h,-help           :帮助
-win               :强制使用窗口模式运行程序
-cli               :强制使用Command模式运行程序
-buildPath         :自定义FirBuilder资源输出路径，示例：-buildPath=/Users/kimi/Downloads/FirBuilder
-serverRoot        :自定义服务器资源存储路径，示例：-serverRoot=https://fir.netlify.app
-inputPath         :自定义需要解析app的文件路径，示例：-inputPath=/Users/kimi/Desktop/AnLinux-App-v6.50.apk
-html              :重新构建所有HTML页面
-sync              :生成同步目录,同步目录不含应用包
-d                 :删除指定BundleID对应的App，示例：-d=com.package.name
-ios,-android      :删除应用时指定App的类型，如果没有该参数表示删除所有符合-d的应用，只有指定-d时该参数才有效。
"""
    print(msg)
    exit(0)
}


//MARK: - 自定义输出目录
private var buildPath:String? = nil
private var serverRoot:String? = nil
private var inputPath:String? = nil
private var buildAllHTML = false
private var isSync = false
private var delBundleID:String? = nil;
private var delType:ParserType? = nil

private var block:(String,String,Bool)->String = { (string, findStr,append) in
    let index = string.index(string.startIndex, offsetBy: findStr.count)
    let end = string.endIndex
    var subStr = String(string[index..<end])
    if append == true {
        if subStr.last != "/" {
            subStr += "/"
        }
    }
    return subStr
}
for item in arguments {
    switch item {
    case "-html":
        buildAllHTML = true
        print("cli- 构建所有的HTML页面")
    case "-sync":
        isSync = true
        print("cli- 生成同步目录")
    case let item where item.hasPrefix("-buildPath="):
        let subStr = block(item, "-buildPath=",true)
        do {
            try FileManager.default.createDirectory(atPath: subStr, withIntermediateDirectories: true, attributes: nil)
            buildPath = subStr
        } catch  {
            print("cli- \(error)")
        }
        print("cli- 自定义解析资源输出目录:\(subStr)")
        
        
    case let item where item.hasPrefix("-serverRoot="):
        let subStr = block(item, "-serverRoot=",true)
        serverRoot = subStr
        print("cli- 自定义serverRoot:\(subStr)")
        
        
    case let item where item.hasPrefix("-inputPath="):
        let subStr = block(item, "-inputPath=",false)
        inputPath = subStr
        print("cli- 解析文件路径:\(inputPath!)")
        
    case let item where item.hasPrefix("-d="):
        let subStr = block(item, "-d=",false)
        delBundleID = subStr
        print("cli- 删除BundleID为:\(delBundleID!)的应用")
    case let item where item.lowercased() == "-android":
        delType = .android
        print("cli- 删除应用类型:Android")
        
    case let item where item.lowercased() == "-ios":
        delType = .ios
        print("cli- 删除应用类型:iOS")
    default:
        break
    }
}


//配置信息
Config.setup(buildPath: buildPath, serverRoot: serverRoot, isSync:isSync)


//MARK: - 判断APP启动模式
var winMode = false
if argc == 1 || arguments.contains("-NSDocumentRevisionsDebugMode") || arguments.contains("YES") {
    winMode = true
}
if arguments.contains("-win") {
    winMode = true
}
if arguments.contains("-cli") {
    winMode = false
}


//MARK: 窗口模式启动 或者 Command模式启动
if winMode {
    ProcessTask.log("使用窗口模式启动程序!")
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
} else{
    ProcessTask.log("使用Command模式启动程序!")
    let semaphore = DispatchSemaphore(value: 0)

    //开始解析
    if let path = inputPath {
        ParserTool.shared.blockStart = {msg in
            ParserTool.shared.parsing = true
            ProcessTask.log(msg)
        }
        ParserTool.shared.blockFail = { msg in
            ParserTool.shared.parsing = false
            ProcessTask.log(msg)
            ProcessTask.log("CLI-ParserTool Parser ID:\(Config.random)")
            ProcessTask.log("CLI-ParserTool Parser Fail.")
            semaphore.signal()
        }
        ParserTool.shared.blockSuccess = {msg in
            ParserTool.shared.parsing = false
            ProcessTask.log(msg)
            ProcessTask.log("CLI-ParserTool Parser ID:\(Config.random)")
            ProcessTask.log("CLI-ParserTool Parser Success.")
            semaphore.signal()
        }
        ParserTool.shared.parserStart(path: path)
        semaphore.wait()
    }else if buildAllHTML == true { //重新构建所有HTML页面
        BuilderAppRes.rebuilderAllHTML()
        ProcessTask.log("H5重新生成完成")
        ProcessTask.log("CLI-ParserTool Parser ID:\(Config.random)")
        ProcessTask.log("CLI-ParserTool Parser Success.")
    }else if let bundleID = delBundleID {
        DBService.shared.deleteAppWith(bundleID: bundleID, type: delType)
        ProcessTask.log("CLI-ParserTool Parser ID:\(Config.random)")
        ProcessTask.log("CLI-ParserTool Parser Success.")
    }
}











//MARK: - 加载图片测试
func testLoadImage(){
    //let path = "/Users/kimi/Desktop/cover.png"
    let path = "/Library/User Pictures/Animals/Eagle.tif"
    let image = ImageTool.loadImageFrom(path: path)
    let reImage = ImageTool.resize(image: image, size: NSMakeSize(200, 200))
    let savePath1 = "/Users/kimi/Downloads/test-1.png"
    let savePath2 = "/Users/kimi/Downloads/test-2.png"
    let savePath3 = "/Users/kimi/Downloads/test-3.png"
    let savePath4 = "/Users/kimi/Downloads/test-4.png"
    ImageTool.PNGRepresentation(image: image, path: savePath1)
    ImageTool.PNGRepresentation(image: reImage, path: savePath2)
    ImageTool.JPGRepresentation(image: image, path: savePath3)
    ImageTool.JPGRepresentation(image: reImage, path: savePath4)
}

