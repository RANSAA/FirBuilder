//
//  BuilderDetails.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation



class BuilderDetails{

    let h5Headder:String = """
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="white">
<meta name="format-detection" content="telephone=no">
<title> </title>
<link rel="icon" type="image/x-icon" href="../../../src/images/favicon.ico">
<link rel="stylesheet" type="text/css" href="../../../src/css/details.css">
<script type="text/javascript" src="../../../src/js/device.js"></script>
<script type="text/javascript" src="../../../src/js/qrcode.js"></script>
</head>
<body>

<img src="../../../src/images/download_pattern_left.png" class="pattern left">
<img src="../../../src/images/download_pattern_right.png" class="pattern right">

<div id="appInfo" style="text-align: center; margin-top: 80px">

    <!-- app icon, name -->
    <div>
        <!-- 手动设置 -->
        <img id="appIcon"  class="size125">
    </div>
    <div style="margin-top: 36px; font-size: 22px; color: #333333; line-height: 36px;">
        <div>
            <img id="appTypeIconPath" class="size36-details">
            <span id="appName">  App Name  </span>
        </div>
    </div>

     <!-- app info text -->
    <div style="font-size: 14px; color: #788090; margin-top: 20px;">
        <div>
            <span >版本:</span>
            <span id="appVersion"> 1.0 </span>
            <span >&emsp; 大小:</span>
            <span id="appSize">   1M  </span>
        </div>
        <div>
            <span >更新时间:</span>
            <span id="appUpdateTime">2022-02-11 21:21:19</span>
        </div>
    </div>


    <!-- qrcode -->
    <div style="width: 190px; height: 230px;  margin: auto; background: white; border-radius: 10px; margin-top: 44px;" >
        <div class="qrcode" id="qrcode" style="padding-left: 10px;padding-right: 10px;padding-top: 10px;padding-bottom: 15px;"></div>
        <span >手机扫描二维码安装</span>
    </div>

    <!-- Button area -->
    <div style=" margin-bottom: 12px; margin-top: 48px; text-align: center; ">
        <div id="btn0" style="display:none;">
            <button type="button" onclick="installApp()" class ="info-button-down" id="installApp">下载安装</button>
        </div>
        <div id="btn1" style="display:none;">
            <br>
            <button type="button" onclick="installCrt()" class ="info-button-down" id="installCrt">安装证书</button>
        </div>

        <div id="btn2" style="display:none;">
            <br>
            <button type="button" onclick="shuowDevices()" class ="info-button-down" id="shuowDevices">查看设备列表</button>
        </div>
        <div id="btn3" style="display:none;">
            <br>
            <button type="button" onclick="getUUID()" class ="info-button-down" id="uuid">获取 UDID</button>
        </div>
        <div id="btn4" style="display:none;">
            <br>
            <button type="button" onclick="showTutorial()" class ="info-button-down" id="showTutorial">证书信任教程</button>
        </div>
        <br>
    </div>

</div>


</body>
</html>


<script type="application/javascript">
    //下载安装APP
    function installApp(){
        // ios value="itms-services://?action=download-manifest&amp;url=https%3A%2F%2F127.0.0.1%3A8080%2Fm%2Fff8080817ee744b8017ee746e5810011"
        // window.location.href = document.getElementById("installApp").value
        window.location.href = installURL
    }

    //安装证书
    function installCrt(){
        var crt = "xxx.crt"
        alert("安装证书")
    }

    //查看iOS设备列表
    function shuowDevices(){
        var list = "iOS设备列表:\\n\\n" + deivces
        console.log(list)
        alert(list)
    }

    //查看信任证书教程
    function showTutorial(){
        window.open("https://www.betaqr.com/support/articles/faq/ios9_certificate")
    }

    //获取UUID
    function getUUID(){
        // window.open("http://betaqr.com/udid","_self")
        window.open("http://betaqr.com/udid")
    }

    function dispalyButton(){
        hiddenWithID("btn0")
        hiddenWithID("btn1")
        hiddenWithID("btn2")
        hiddenWithID("btn3")
        hiddenWithID("btn4")
        var devideType = getDeviceType()
        if (appType == "ios") {
            if(devideType == "ios"){
                showWithID("btn0")
                // showWithID("btn1")
                showWithID("btn2")
                showWithID("btn3")
                showWithID("btn4")
            }
        }else{
            // if (devideType == "android") {
            //     showWithID("btn0")
            // }
            if (devideType != "ios") {
                showWithID("btn0")
            }
        }
     }

    function resize(){
        dispalyButton()
     }

    // window.addEventListener("resize", resize);
    // dispalyButton()

    function load(){
        //logo path
        document.getElementById("appIcon").src = appIconPath
        document.getElementById("appName").innerHTML = appName

        document.title = appName
        document.getElementById("appName").innerHTML = appName
        document.getElementById("appVersion").innerHTML = appVersion
        document.getElementById("appSize").innerHTML = appSize
        document.getElementById("appUpdateTime").innerHTML = appUpdateTime

        if (appType == "ios") {
            document.getElementById("appTypeIconPath").src = iosIcon
        }else{
            document.getElementById("appTypeIconPath").src = androidIcon
        }

        //
        window.addEventListener("resize", resize);
        dispalyButton()

        //当前网页二维码
        buildQRCodeWithImg(window.location.href, "appIcon")
        console.log(window.location.href)
        //root path
        // console.log(window.location.origin)


        showWithID("appInfo")
    }

    hiddenWithID("appInfo")

    window.onload = function(){
       load()
    }

    //type icon
    let iosIcon = "../../../src/images/apple.png"
    let androidIcon = "../../../src/images/android.png"

</script>


"""
}


extension BuilderDetails{
    /** 生成所有APP下载页面*/
    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let release:[AppReleaseListTable]? = try db.getObjects(fromTable: AppReleaseListTable.tableName, orderBy:[AppReleaseListTable.Properties.updateDate.asOrder(by: .ascending)])
            if let list = release {
                for item in list {
                    builder(item)
                    //new.html 每一条记录都生成，但是直接覆盖旧的new.html
                    builderNewHTML(item)
                }
            }
        } catch  {
            print(error)
        }
    }

    //生成自定item的下载页面
    func builder(_ item:AppInfoModel){
        let h5String:String = h5Headder+dymaninJS(item)
        let detailsData = h5String.data(using: .utf8)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: Config.htmlPath+item.detailsH5Path!, contents: detailsData, attributes: nil)
        fileManager.createFile(atPath: Config.htmlSyncPath+item.detailsH5Path!, contents: detailsData, attributes: nil)
    }

    func builder(_ item:AppReleaseListTable){
        let h5String:String = h5Headder+dymaninJS(item)
        let detailsData = h5String.data(using: .utf8)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: Config.htmlPath+item.detailsH5Path!, contents: detailsData, attributes: nil)
        fileManager.createFile(atPath: Config.htmlSyncPath+item.detailsH5Path!, contents: detailsData, attributes: nil)
    }


    //生成new.html
    func builderNewHTML(_ info:Any){
        if let item = info as? AppInfoModel {
            let h5String:String = h5Headder+dymaninJS(item)
            let detailsData = h5String.data(using: .utf8)
            let fileManager = FileManager.default
            fileManager.createFile(atPath: Config.htmlPath+item.srcRoot!+"new.html", contents: detailsData, attributes: nil)
            fileManager.createFile(atPath: Config.htmlSyncPath+item.srcRoot!+"new.html", contents: detailsData, attributes: nil)
        }
        if let item = info as? AppReleaseListTable {
            print("Config.serverRoot:   \(Config.serverRoot)");
            print("new.html: \(Config.htmlPath+item.srcRoot!+"new.html")")
            let h5String:String = h5Headder+dymaninJS(item)
            let detailsData = h5String.data(using: .utf8)
            let fileManager = FileManager.default
            fileManager.createFile(atPath: Config.htmlPath+item.srcRoot!+"new.html", contents: detailsData, attributes: nil)
            fileManager.createFile(atPath: Config.htmlSyncPath+item.srcRoot!+"new.html", contents: detailsData, attributes: nil)
        }
    }
}


extension BuilderDetails{
    //https://www.mfpud.com/topics/302/
    //ipa 安装示例
    //ios "itms-services://?action=download-manifest&url=https://127.0.0.1/ipa/manifest.plist"

    func dymaninJS(_ item:AppReleaseListTable) -> String{
        var install:String = Config.serverRoot+item.saveAppPath!
        if item.type == .ios {
            install = "itms-services://?action=download-manifest&url=\(Config.serverRoot)\(item.appManifestPath!)"
        }

        var devices:String = ""
        if item.type == .ios {
            if let deviceList = item.devices {
                devices = deviceList.joined(separator: ";\\n")
            }
        }

        let imagePath = item.appIconPath?.fileName

        let dymanic:String = """
<!-- 用于动态写入数据 -->
<script type="text/javascript">
    let appType = "\(item.type.rawValue)" // ios or android

    let appIconPath = "\(imagePath!)"
    let appName = "\(item.name!)"
    let appVersion = "\(item.version!) ( Build \(item.build!) ) "
    let appSize = "\(item.fileSize!)"
    let appUpdateTime = "\(DateFormatter.dateStringWith(date: item.updateDate))"

    //app install url
    let installURL = "\(install)"

    //动态记入设备列表
    let deivces = "\(devices)"

</script>

"""
        return dymanic
    }


    func dymaninJS(_ item:AppInfoModel) -> String{
        var install:String = Config.serverRoot+item.saveAppPath!
        if item.type == .ios {
            install = "itms-services://?action=download-manifest&url=\(Config.serverRoot)\(item.appManifestPath!)"
        }

        var devices:String = ""
        if item.type == .ios {
            if let deviceList = item.devices {
                devices = deviceList.joined(separator: ";\\n")
            }
        }

        let imagePath = item.appIconPath?.fileName

        let dymanic:String = """
<!-- 用于动态写入数据 -->
<script type="text/javascript">
    let appType = "\(item.type.rawValue)" // ios or android

    let appIconPath = "\(imagePath!)"
    let appName = "\(item.name!)"
    let appVersion = "\(item.version!) ( Build \(item.build!) ) "
    let appSize = "\(item.fileSize!)"
    let appUpdateTime = "\(DateFormatter.dateStringWith(date: item.updateDate))"

    //app install url
    let installURL = "\(install)"


    //动态记入设备列表
    let deivces = "\(devices)"

</script>

"""
        return dymanic
    }

}
