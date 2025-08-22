//
//  BuilderDetails.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import KakaJSON



class BuilderDetails{
    let h5Headder:String = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no viewport-fit=cover">
<meta name="format-detection" content="telephone=no">

<!-- PWA 状态栏设置 -->
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucen">
<meta name="theme-color" content="#8c8eff">

<title> </title>
<link rel="icon" type="image/x-icon" href="/src/images/favicon.ico"/>
<link rel="apple-touch-icon" href="/src/images/favicon.png">
<link rel="manifest" href="/manifest.json">
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
    <!--  line-height: 36px; -->
    <div style="margin-top: 36px; font-size: 22px; color: #333333;">
        <div>
            <img id="appTypeIconPath" class="size36-details">
            <span style="color:#FF9300;" id="appName"> </span>
            <span style="font-size:15px; color: #5AC5F8;" id="signType"> </span>
        </div>
    </div>

    <div style="margin-top:18px;color: red; display:none;" id="expirationDateDIV">
        <span id="expirationDate"> </span>
    </div>

     <!-- app info text -->
    <div style="font-size: 14px; color: #788090; margin-top: 20px;">
        <div>
            <span >BundleID:</span>
            <span id="bundleID"> </span>
        </div>
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


    <!-- userMakr info -->
    <div style="color: red; font-size:14px; white-space: pre-line; margin-top:0px; margin-bottom: -24px; margin-left: 10px;margin-right: 10px; display:none;" id="userMarkDIV">
        <span id="userMark"> </span>
    </div>


    <!-- qrcode -->
    <div style="width: 190px; height: 230px;  margin: auto; background: white; border-radius: 10px; margin-top: 44px;" >
        <div class="qrcode" id="qrcode" style="padding-left: 10px;padding-right: 10px;padding-top: 10px;padding-bottom: 15px;"></div>
        <span >手机扫描二维码安装</span>
    </div>


    <!-- Button area -->
    <div style=" margin-bottom: 24px; margin-top: 48px; text-align: center; ">
        <div id="btn0" style="display:none;">
            <button type="button" onclick="installApp()" class ="info-button-down" id="installApp">安装</button>
        </div>

        <div id="btn-download" style="display:none;">
            <br>
            <button type="button" onclick="downloadApp()" class ="info-button-down" id="downloadApp">下载</button>
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
    //iOS 禁用缩放补充
    disableZoomSupplement();

    //安装APP
    function installApp(){
        // ios value="itms-services://?action=download-manifest&amp;url=https%3A%2F%2F127.0.0.1%3A8080%2Fm%2Fff8080817ee744b8017ee746e5810011"
        // window.location.href = document.getElementById("installApp").value
        window.location.href = installURL
    }

    //下载
    function downloadApp(){
        // 创建一个a元素
        const link = document.createElement('a');
        
        // 设置文件的URL（这里用的是示例URL，换成你自己的文件路径）
        link.href = downloadURL;
        
        // 自定义下载的文件名
        link.download = downloadFileName;
        
        // 将a元素添加到页面并触发点击事件下载文件
        document.body.appendChild(link);
        link.click();
        
        // 下载完成后移除该a元素
        document.body.removeChild(link);

    }

    //安装证书 - 未使用
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
        window.open("https://www.betaqr.com.cn/support/articles/faq/ios9_certificate")
    }

    //获取UUID
    function getUUID(){
        // window.open("https://www.betaqr.com.cn/udid","_self")
        // window.open("https://www.betaqr.com.cn/udid")
        window.open("https://www.neicexia.com/UDID")
    }

    function dispalyButton(){
        hiddenWithID("btn0")
        hiddenWithID("btn-download")
        hiddenWithID("btn1")
        hiddenWithID("btn2")
        hiddenWithID("btn3")
        hiddenWithID("btn4")
        let devideType = getDeviceType()

        console.log(devideType)
        console.log(appType)

       //当前App类型为iOS
       if ( appType == "\(ParserType.ios)" )  {
           //当前设备类型为iOS系列
           if ( devideType == "\(ParserType.ios)" ) {
               showWithID("btn0")
               showWithID("btn2")
               showWithID("btn3")
               showWithID("btn4")
           }
           //显示下载按钮
           showWithID("btn-download")

           //显示应用过期时间
           showWithID("expirationDateDIV")
           document.getElementById("downloadApp").innerHTML = "下载IPA";
       } else {
           //当前App类型为Android或者其他非iOS平台

           //显示安装按钮
           //showWithID("btn0");

           //显示下载按钮
           showWithID("btn-download")
           document.getElementById("downloadApp").innerHTML = "下载";
       }

        //判断是否显示userMark
       if (userMark.length > 1) {
            showWithID("userMarkDIV")
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
        document.getElementById("signType").innerHTML = appSignType
        document.getElementById("expirationDate").innerHTML = appExpDate

        document.title = appName
        document.getElementById("appName").innerHTML = appName
        document.getElementById("appVersion").innerHTML = appVersion
        document.getElementById("appSize").innerHTML = appSize
        document.getElementById("appUpdateTime").innerHTML = appUpdateTime
        document.getElementById("bundleID").innerHTML = bundleID

        document.getElementById("userMark").textContent = userMark

        if (appType == "\(ParserType.ios)" ) {
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
        //console.log(window.location.origin)

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
    /** 生成所有APP下载页面 */
    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let list:[AppListTable] = try db.getObjects(fromTable: AppListTable.tableName, orderBy:[AppListTable.Properties.updateDate.asOrder(by: .ascending)])
            let appInfoList = list.compactMap({ (model) -> AppInfoModel in
                let jsonString = model.kj.JSONString()
                let appInfo:AppInfoModel = KakaJSON.model(from: jsonString, type: AppInfoModel.self) as! AppInfoModel
                return appInfo
            })
            
            for item in appInfoList {
                builderNewHTML(item)
                builderDetailsHTML(item)
            }
        } catch  {
            log(error)
        }
    }

}

extension BuilderDetails{
//MARK: - 使用AppInfoModel 生成下载页面
     func builder(_ appInfo:AppInfoModel, name:String){
        let h5String:String = h5Headder+dymaninJS(appInfo)
        let detailsData = h5String.data(using: .utf8)        
        let path = Config.htmlPath + appInfo.srcRoot! + name
        ParserTool.save(detailsData, path: path)
    }
    
    func builderDetailsHTML(_ appInfo:AppInfoModel){
        builder(appInfo, name:appInfo.detailsPath!)
    }
    
    //生成new.html
    func builderNewHTML(_ appInfo:AppInfoModel){
        builder(appInfo, name: appInfo.newPath!)
    }
}

extension BuilderDetails{
    
    func dymaninJS(_ appInfo:AppInfoModel) -> String{
        var install:String = Config.serverRoot+appInfo.srcRoot!+appInfo.appSavePath!
        let downloadURL:String = install
        if appInfo.type == .ios {
            install = "itms-services://?action=download-manifest&url=\(Config.serverRoot)\(appInfo.srcRoot!)\(appInfo.manifestPath!)"
        }

        var devices:String = ""
        if appInfo.type == .ios {
            if let deviceList = appInfo.devices {
                devices = deviceList.joined(separator: "\\n")
            }
        }
        let imagePath = appInfo.logo512Path!
        
        let downloadFileName = appInfo.name! + "_" + appInfo.version! + "." + appInfo.appSavePath!.fileExtension

        let dymanic:String = """
<!-- 用于动态写入数据 -->
<script type="text/javascript">
    let appType = "\(appInfo.type)" // ios or android
    let appIconPath = "\(imagePath)"
    let appName = "\(appInfo.name!) "
    let bundleID = "\(appInfo.bundleID!) "
    let appVersion = "\(appInfo.version!) ( Build \(appInfo.build!) ) "
    let appShortVersion = "\(appInfo.version!)"
    let appSize = "\(appInfo.fileSize!)"
    let appUpdateTime = "\(DateFormatter.dateStringWith(date: appInfo.updateDate))"
    let appSignType = "\(appInfo.signType)"
    let appExpDate = "过期时间:&nbsp; \(appInfo.signExpiration!)"

    //app install url
    let installURL = "\(install)"

    //app package download url
    let downloadURL = "\(downloadURL)"

    //下载时的文件路径
    let downloadFileName = "\(downloadFileName)"


    //写入App应用描述
    let userMark = `\(appInfo.userMark)`


    //动态写入设备列表
    let deivces = "\(devices)"


</script>
"""
        return dymanic
    }
}

