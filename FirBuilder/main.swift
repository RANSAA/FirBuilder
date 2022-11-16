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
-buildPath         :自定义FirBuilder资源输出路径，示例：-buildPath=/Users/kimi/Downloads/FirBuilder
-serverRoot        :自定义服务器资源存储路径，示例：-serverRoot=https://fir.netlify.app
"""
    print(msg)
    exit(0)
}


//MARK: - 自定义输出目录
private var buildPath:String? = nil
private var serverRoot:String? = nil
private var block:(String,String)->String = { (string, findStr) in
    let index = string.index(string.startIndex, offsetBy: findStr.count)
    let end = string.endIndex
    var subStr = String(string[index..<end])
    if subStr.last != "/" {
        subStr += "/"
    }
    return subStr
}
for item in arguments {
    let _buildPath = "-buildPath="
    let _serverRoot = "-serverRoot="
    if item.hasPrefix(_buildPath) {
        let subStr = block(item, _buildPath)
        do {
            try FileManager.default.createDirectory(atPath: subStr, withIntermediateDirectories: true, attributes: nil)
            buildPath = subStr
        } catch  {
            print("\(error)")
        }
        print("自定义输出目录:\(subStr)")
    }else if item.hasPrefix(_serverRoot){
        let subStr = block(item, _serverRoot)
        serverRoot = subStr
        print("自定义serverRoot:\(subStr)")
    }
}




//配置信息
Config.setup(buildPath: buildPath, serverRoot: serverRoot)


//MARK: - 判断APP启动模式
private var isWin = false
if argc == 1 || arguments.contains("-NSDocumentRevisionsDebugMode") || arguments.contains("YES") {
    isWin = true
}

//MARK: 窗口模式启动 或者 Command模式启动
if isWin {
    print("使用窗口模式启动程序!")
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
} else{
    print("使用Command模式启动程序!")
    print("CLI 模式处理解析任务...")
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



//MARK: - 模拟程序状态等待操作
private let seam = DispatchSemaphore(value: 0)
DispatchQueue.global().asyncAfter(deadline: .now() + 1 ) {
    print("after 2")
    seam.signal()
}
seam.wait()
print("seam.wait done.")
