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

<title>App分发平台</title>
<!-- iOS Clip Web启动图片 测试 -->
<link rel="apple-touch-startup-image" href="/src/images/launch.png" media="(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2)">

<link rel="icon" type="image/x-icon" href="src/images/favicon.ico" />
<link rel="apple-touch-icon" href="src/images/favicon.png">
<link rel="manifest" href="/manifest.json">

<link rel="stylesheet" type="text/css" href="src/css/index.css">
<script type="text/javascript" src="src/js/device.js"></script>
</head>

<body>

<div class="nav-bar-top-right" onclick="handleTopRightClick()">
    <img class="nav-bar-top-right-img" src="src/images/nav-top-right.png" >
</div>

<div class="nav-bar">
    <br>
    <h2>App分发平台</h2>
    <br>
    <h4>当前设备类型类型：<span id="deviceType" style="color: red;">  </span></h4>
    <br>
    <div class="nav-bar-buttonarea">
        <button class="button-selected" onclick="window.location.href='index.html'">Home</button>
        <div style="width: 20px;"></div>
        <button class="button-normal" onclick="window.location.href='ios.html'">iOS</button>
        <div style="width: 20px;"></div>
        <button class="button-normal" onclick="window.location.href='android.html'">Android</button>
    </div>
</div>


<!-- grid开始 -->
<div class="home-grid-container fade-out" id="contentView">

"""
    let bodyEnd:String = """

</div>
<!-- grid结束 -->
</body>
</html>
<script>
    //显示当前设备类型
    document.getElementById("deviceType").innerHTML= getDeviceName();
    //iOS 禁用缩放补充
    disableZoomSupplement();

    // 设置homeItemStyle
    function setHomeItemStyle(value){
        // 存储数据（所有页面可读）
        localStorage.setItem('HomeContainerStyle', value);
    }

    // 获取homeItemStyle
    function getHomeItemStyle(){
        let style = localStorage.getItem('HomeContainerStyle')
        return style
    }

    /**
     * 替换指定ID标签中的class
     * @param {string} labelID - 需要替换标签的ID名称
     * @param {string} oldClassName - 需要被替换的 class 名称（如 "A"）
     * @param {string} newClassName - 替换后的 class 名称（如 "B"）
     */
    function replaceSpecifiedTagWithClass(labelID, oldClassName, newClassName){
        //1. 获取ID为labelID的元素,只能获取到第一个，注意：如果页面中出现了多了相同ID的元素，是不符合H5标准的，如果需要使用class
        const element = document.getElementById(labelID)
        element.classList.remove(oldClassName);  // 移除旧 class
        element.classList.add(newClassName);    // 添加新 class


        // //获取ID为labelID的所有元素，注意：如果页面中出现了多了相同ID的元素，是不符合H5标准的，如果需要使用class
        // const elements = document.querySelectorAll(`[id="${labelID}"]`)
        // // 2. 遍历每个元素，替换 class
        // elements.forEach(element => {
        //     element.classList.remove(oldClassName);  // 移除旧 class
        //     element.classList.add(newClassName);    // 添加新 class
        // });
        // console.log(`已替换 -- ${elements.length} 个元素的 class: ${oldClassName} → ${newClassName}`);
    }



    /**
     * 替换页面中所有指定 class 名称的元素
     * @param {string} oldClassName - 需要被替换的 class 名称（如 "A"）
     * @param {string} newClassName - 替换后的 class 名称（如 "B"）
     */
    function replaceClass(oldClassName, newClassName) {
      // 1. 获取所有包含 oldClassName 的元素
      const elements = document.querySelectorAll(`.${oldClassName}`);
      
      // 2. 遍历每个元素，替换 class
      elements.forEach(element => {
        element.classList.remove(oldClassName);  // 移除旧 class
        element.classList.add(newClassName);    // 添加新 class
      });

      console.log(`已替换 ${elements.length} 个元素的 class: ${oldClassName} → ${newClassName}`);
    }

    /**
     * 替换页面中所有指定 class 名称的元素
     * @param {string} oldClassName - 需要被替换的 class 名称（如 "A"）
     * @param {string} newClassName - 替换后的 class 名称（如 "B"）
     * 如果页面元素非常多（如数千个），建议使用 requestAnimationFrame分批次处理
     */
    function batchReplaceClass(oldClassName, newClassName) {
      const elements = document.querySelectorAll(`.${oldClassName}`);
      let i = 0;

      function update() {
        if (i >= elements.length) return;
        elements[i].classList.replace(oldClassName, newClassName);
        i++;
        requestAnimationFrame(update);
      }

      update();
    }

    //设置样式为网格样式
    function setHomeGridStyle(){
        replaceClass("home-table-container","home-grid-container");
        replaceClass("home-table-item","home-grid-item");
        replaceClass("home-table-item-icon","home-grid-item-icon");
        replaceClass("home-table-item-icon-fixsize","home-grid-item-icon-fixsize");
        replaceClass("home-table-item-logo","home-grid-item-logo");
        replaceClass("home-table-item-textarea","home-grid-item-textarea");
        replaceClass("home-table-item-text-name","home-grid-item-text-name");
        replaceClass("home-table-item-text-line","home-grid-item-text-line");
        replaceClass("home-table-item-text-info","home-grid-item-text-info");
        replaceClass("home-table-item-buttonarea","home-grid-item-buttonarea");
    }

    //设置样式为列表样式
    function setHomeTableStyle(){
        replaceClass("home-grid-container","home-table-container");
        replaceClass("home-grid-item","home-table-item");
        replaceClass("home-grid-item-icon","home-table-item-icon");
        replaceClass("home-grid-item-icon-fixsize","home-table-item-icon-fixsize");
        replaceClass("home-grid-item-logo","home-table-item-logo");
        replaceClass("home-grid-item-textarea","home-table-item-textarea");
        replaceClass("home-grid-item-text-name","home-table-item-text-name");
        replaceClass("home-grid-item-text-line","home-table-item-text-line");
        replaceClass("home-grid-item-text-info","home-table-item-text-info");
        replaceClass("home-grid-item-buttonarea","home-table-item-buttonarea");
    }

    //根据设备类型加载默认样式
    function defaultHomeItemStyle(){
        let homeItemStyle = getHomeItemStyle()
        //表示没有切换过样式
        if (homeItemStyle == undefined || homeItemStyle == null) {
            if (isMobile()) {
                setHomeItemStyle("grid"); //标记为网格样式
            }else{
                setHomeItemStyle("table"); //标记为列表样式
            }
             //只进行一次样式切换
            handleTopRightClick()
            
            console.log("站点第一次运行时对首页样式的切换......")
        }else{
            if (homeItemStyle == "grid") {
                setHomeGridStyle();
            }else{
                setHomeTableStyle();
            }
            console.log("根据getHomeItemStyle的值进行样式切换......")
        }

        //通过将 fade-out 设置为 fade 显示标签
        replaceSpecifiedTagWithClass("contentView","fade-out","fade")
    }


    // 右上角点击切换布局样式
    /**
     * 通过window.homeItemStyle的值设置样式，它的值可以为：1 和 0
     * 0：表示网格样式
     * 1：表示列表样式
     */
    function handleTopRightClick() {
        if (getHomeItemStyle() == "table") {
            setHomeItemStyle("grid");
            setHomeGridStyle();
        }else{
            setHomeItemStyle("table");
            setHomeTableStyle();
        }
        console.log("........")
        console.log(getHomeItemStyle());
    }

    window.onload = function(){
        console.log("onload, 所有资源加载后操作.....")
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log("DOM 已就绪，但图片可能未加载......");
        defaultHomeItemStyle();
    });
</script>
"""
    var success = false

    private func listBodyBagin(_ type:ParserType) -> String{
    let iosClass = type == .ios ? "button-selected" : "button-normal"
    let androidClass = type == .android ? "button-selected" : "button-normal"
    let listBodyBagin:String = """
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
    
    <title>\(type) 列表</title>
    
    <!-- iOS Clip Web启动图片 测试 -->
    <link rel="apple-touch-startup-image" href="/src/images/launch.png" media="(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2)">
    
    <link rel="icon" type="image/x-icon" href="src/images/favicon.ico" />
    <link rel="apple-touch-icon" href="src/images/favicon.png">
    <link rel="manifest" href="/manifest.json">
    <link rel="stylesheet" type="text/css" href="src/css/index.css">
    <script type="text/javascript" src="src/js/device.js"></script>
    </head>

    <body>
    
    <div class="nav-bar-top-right" onclick="handleTopRightClick()">
        <img class="nav-bar-top-right-img" src="src/images/nav-top-right.png" >
    </div>
    
    
    <div class="nav-bar">
        <br>
        <h2>\(type) 列表</h2>
        <br>
        <h4>当前设备类型类型：<span id="deviceType" style="color: red;">  </span></h4>
        <br>
        <div class="nav-bar-buttonarea">
            <button class="button-normal" onclick="window.location.href='index.html'">Home</button>
            <div style="width: 20px;"></div>
            <button class="\(iosClass)" onclick="window.location.href='ios.html'">iOS</button>
            <div style="width: 20px;"></div>
            <button class="\(androidClass)" onclick="window.location.href='android.html'">Android</button>
        </div>
    </div>


    <!-- grid开始 -->
    <div class="home-grid-container fade-out" id="contentView">

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
            log(error)
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
    <div class="home-grid-item">
        <!-- 右上角图标 -->
        <div class="home-table-item-icon">
            <img class="home-table-item-icon-fixsize" name="appIconType" src="\(iconTypePath)">
        </div>
        <!-- logo icon -->
        <img class="home-table-item-logo" src="\(item.srcRoot!+item.logo512Path!)">
        <!-- 文字显示区域 -->
        <div class="home-table-item-textarea">
            <!-- app name -->
            <div class="home-table-item-text-name">
                <img  class="img-user-size16" src="src/images/user.png">
                <span>\(item.name!)</span>
            </div>
            <!-- text info -->
            <div class="home-table-item-text-line">
                <span>包名：</span>
                <span class="home-table-item-text-info">\(item.bundleID!)</span>
            </div>
            <div class="home-table-item-text-line">
                <span>版本：</span>
                <span class="home-table-item-text-info">\(item.version!) ( Build \(item.build!) )</span>
            </div>
            <div class="home-table-item-text-line">
                <span>更新时间：</span>
                <span class="home-table-item-text-info">\(DateFormatter.dateStringWith(date: item.updateDate))</span>
            </div>
        </div>
        <!-- button -->
        <div class="home-table-item-buttonarea" >
            <button class ="button-movemouse button-smail" onclick="window.open('\(item.srcRoot!+item.listPath!)')" >列表</button>
            <div style="width:44px;height: 12px;"></div>
            <button class ="button-movemouse button-smail" onclick="window.open('\(item.srcRoot!+item.newPath!)')" >预览</button>
        </div>
    </div>
    <!-- 一个item结束 -->
"""
        return h5
    }
}

