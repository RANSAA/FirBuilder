//
//  main.swift
//  FirBuilder
//
//  Created by PC on 2022/11/16.
//

import Foundation


#if DEBUG

print("argc:\(CommandLine.argc)")
print("arguments:\(CommandLine.arguments)")
print("unsafeArgv:\(CommandLine.unsafeArgv)")

#endif


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
-buildAllHTML      :重新构建所有HTML页面
"""
    print(msg)
    exit(0)
}


//MARK: - 自定义输出目录
private var buildPath:String? = nil
private var serverRoot:String? = nil
private var inputPath:String? = nil
private var buildAllHTML = false
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
    
    if item == "-buildAllHTML" {
        buildAllHTML = true
        print("构建所有的HTML页面")
    }else if item.hasPrefix("-buildPath=") {
        let subStr = block(item, "-buildPath=",true)
        do {
            try FileManager.default.createDirectory(atPath: subStr, withIntermediateDirectories: true, attributes: nil)
            buildPath = subStr
        } catch  {
            print("\(error)")
        }
        print("自定义解析资源输出目录:\(subStr)")
    }else if item.hasPrefix("-serverRoot="){
        let subStr = block(item, "-serverRoot=",true)
        serverRoot = subStr
        print("自定义serverRoot:\(subStr)")
    }else if item.hasPrefix("-inputPath=") {
        let subStr = block(item, "-inputPath=",false)
        inputPath = subStr
        print("解析文件路径:\(inputPath!)")
    }

}



//配置信息
Config.setup(buildPath: buildPath, serverRoot: serverRoot)


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
    print("使用窗口模式启动程序!")
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
} else{
    print("使用Command模式启动程序!")
    let semaphore = DispatchSemaphore(value: 0)

    //开始解析
    if let path = inputPath {
        ParserTool.shared.blockStart = {msg in
            ParserTool.shared.parsing = true
            print(msg)
        }
        ParserTool.shared.blockFail = { msg in
            print(msg)
            ParserTool.shared.parsing = false
            ParserTool.clean()
            semaphore.signal()
        }
        ParserTool.shared.blockSuccess = {msg in
            print(msg)
            ParserTool.shared.parsing = false
            ParserTool.clean()
            semaphore.signal()
        }
        ParserTool.shared.parserStart(path: path)
        semaphore.wait()
    }else if buildAllHTML == true { //重新构建所有HTML页面
        BuilderAppRes.rebuilderAllHTML()
        print("H5重新生成完成")
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



////MARK: - 模拟程序状态等待操作
//private let seam = DispatchSemaphore(value: 0)
//DispatchQueue.global().asyncAfter(deadline: .now() + 0.3 ) {
//    print("after 2")
//    seam.signal()
//}
//seam.wait()
//print("seam.wait done.")
