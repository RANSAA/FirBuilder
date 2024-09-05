//
//  BuilderAppHome.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import WCDBSwift



class BuilderAppHome{
    let bodyBagin:String = """
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="white">
<meta name="format-detection" content="telephone=no">
<title>App分发平台</title>
<link rel="icon" type="image/x-icon" href="src/images/favicon.ico" />
<link rel="stylesheet" type="text/css" href="src/css/index.css">
<script type="text/javascript" src="src/js/device.js"></script>
</head>

<body style="margin: 0px ;">

<div class="nav-bar">
    <br><br><br><br>
    <h1>App分发平台</h1>
    <br>
    <h4>当前设备类型类型：<span id="deviceType" style="color: red;">  </span></h4>
    <br>
    <div style="padding-bottom:12px;">
        <button type="button" class="home-button-selected" onclick="window.location.href='index.html'">Home</button>
        <button type="button" class="home-button-normal" onclick="window.location.href='ios.html'">iOS</button>
        <button type="button" class="home-button-normal" onclick="window.location.href='android.html'">Android</button>
    </div>
</div>

<!-- grid开始 -->
<div class="home-grid-container" >

"""
    let bodyEnd:String = """

</div>
<!-- grid结束 -->
</body>
</html>
<script>
    document.getElementById("deviceType").innerHTML= getDeviceName();
</script>
"""
    var success = false

    private func listBodyBagin(_ type:ParserType) -> String{
    let iosClass = type == .ios ? "home-button-selected" : "home-button-normal"
    let androidClass = type == .android ? "home-button-selected" : "home-button-normal"
    let listBodyBagin:String = """
    <!DOCTYPE html>
    <html lang="en-US">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="white">
    <meta name="format-detection" content="telephone=no">
    <title>\(type) List</title>
    <link rel="icon" type="image/x-icon" href="src/images/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="src/css/index.css">
    <script type="text/javascript" src="src/js/device.js"></script>
    </head>

    <body style="margin: 0px ;">

    <div class="nav-bar">
        <br><br><br><br>
        <h1>\(type) List</h1>
        <br>
        <h4>当前设备类型类型：<span id="deviceType" style="color: red;">  </span></h4>
        <br>
        <div style="padding-bottom:12px;">
            <button type="button" class="home-button-normal" onclick="window.location.href='index.html'">Home</button>
            <button type="button" class="\(iosClass)" onclick="window.location.href='ios.html'">iOS</button>
            <button type="button" class="\(androidClass)" onclick="window.location.href='android.html'">Android</button>
        </div>
    </div>

    <!-- grid开始 -->
    <div class="home-grid-container" >

    """
        return listBodyBagin
    }

}


extension BuilderAppHome{

    private func save(string:String, name:String){
        let appHomeData = string.data(using: .utf8)        
        let path = Config.htmlPath+name
        ParserTool.save(appHomeData, path: path)
    }

}



extension BuilderAppHome{
    
    func builder(){
        do {
            var h5:String = ""
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let list:[AppHomeTable] = try db.getObjects(fromTable: AppHomeTable.tableName,orderBy: [AppHomeTable.Properties.updateDate.asOrder(by: .descending)])
           
            h5 += bodyBagin
            for item in list {
                h5 += dymaincItem(item)
            }
            h5 += bodyEnd
            save(string: h5, name: "index.html")
            
            //生成iOS和Android的单独列表
            builderIosList(list: list.filter({$0.type == .ios}) )
            builderAndroidList(list: list.filter({$0.type == .android}) )
        } catch  {
            ParserTool.log(error)
        }
    }
    
    func builderIosList(list:[AppHomeTable]){
        var h5:String = ""
        h5 += listBodyBagin(.ios)
        for item in list {
            h5 += dymaincItem(item)
        }
        h5 += bodyEnd
        save(string: h5, name: "ios.html")
    }

    func builderAndroidList(list:[AppHomeTable]){
        var h5:String = ""
        h5 += listBodyBagin(.android)
        for item in list {
            h5 += dymaincItem(item)
        }
        h5 += bodyEnd
        save(string: h5, name: "android.html")
    }
}


extension BuilderAppHome{
    
    func dymaincItem(_ item:AppHomeTable) ->String{
        let iconTypePath:String = item.type == .ios ? "src/images/apple.png" : "src/images/android.png"

        let h5:String = """
    <!-- 一个item开始 -->
    <div class="home-grid-item ">
        <!-- 右上角图标 -->
        <div style="height: 48px;">
            <img name="appIconType" src="\(iconTypePath)"  class="top-img-right">
        </div>

        <div class="margin48">
            <!-- logo icon -->
             <div class="home-nav-logo-height">
                <img src="\(item.srcRoot!+item.logo512Path!)" class="size100">
            </div>
            <!-- app name -->
            <div class="home-nav-name-height">
                <img src="src/images/user.png" class="size16">
                <span>\(item.name!)</span>
            </div>
            <!-- text info -->
            <div class="home-nav-line-height">
                <span class="home-line-label ">包名：</span>
                <span class="home-line-text">\(item.bundleID!)</span>
            </div>
            <div class="home-nav-line-height">
                <span class="home-line-label ">版本：</span>
                <span class="home-line-text">\(item.version!) ( Build \(item.build!) )</span>
            </div>
            <div class="home-nav-line-height">
                <span class="home-line-label ">更新时间：</span>
                <span class="home-line-text">\(DateFormatter.dateStringWith(date: item.updateDate))</span>
            </div>
            <!-- button -->
            <div style="margin-top:62px;">
                <div>
                    <button type="button" onclick="window.open('\(item.srcRoot!+item.listPath!)')" class ="home-button-left">列表</button>
                    <button type="button" onclick="window.open('\(item.srcRoot!+item.newPath!)')" class ="home-button-right">预览</button>
                </div>
            </div>
        </div>

    </div>
    <!-- 一个item结束 -->
"""
        return h5
    }
}

