//
//  BuilderList.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import WCDBSwift



class BuilderList{
    let bodyBegin:String = """
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="white">
<meta name="format-detection" content="telephone=no">
<title>应用下载</title>
<link rel="icon" type="image/x-icon" href="../../../src/images/favicon.ico">
<link rel="stylesheet" type="text/css" href="../../../src/css/list.css">
<script type="text/javascript" src="../../../src/js/device.js"></script>
</head>
<body>

<div>
    <div style="text-align: center;">
        <h4 id="navName">   </h4>
    </div>
    <div style="background: #F6F6F6; height: 10px;"></div>
</div>

<div id="list" name="list" class="list-mob" style="display: none;" >


"""

    let bodyEnd:String = """

</div>
</body>
</html>
<script>

    function updateLabelStyle(){
        var list = document.getElementsByName("list")
        list.forEach((item,index,array)=>{
            if (isMobile()) {
                item.className = "list-mob"
            }else{
                item.className = "list"
            }
        })

        var items = document.getElementsByName("item")
        items.forEach((item,index,array)=>{
            if (isMobile()) {
                item.className = "list-item-mob"
            }else{
                item.className = "list-item"
            }
        })

        var centerItems = document.getElementsByName("item-center")
        centerItems.forEach((item,index,array)=>{
            if (isMobile()) {
                item.className = "list-item-center-mob"
            }else{
                item.className = "list-item-center"
            }
        })

        var rightItems = document.getElementsByName("item-right")
        rightItems.forEach((item,index,array)=>{
            if (isMobile()) {
                item.className = "list-item-right-mob"
            }else{
                item.className = "list-item-right"
            }
        })
    }

    function updateTypeIcon(){
        var appIcons = document.getElementsByName("appTypeIcon")
        appIcons.forEach((item,index,array)=>{
            if (appType == "ios") {
                item.src = iosIcon
            }else{
                item.src = androidIcon
            }
        })
    }

    window.onload = function(){
        window.addEventListener("resize", updateLabelStyle);
        updateLabelStyle()
        updateTypeIcon()
        document.title = "列表-"+appName
        document.getElementById("navName").innerHTML="列表-"+appName

        showWithID("list")
    }

    //type icon
    let iosIcon = "../../../src/images/apple.png"
    let androidIcon = "../../../src/images/android.png"


</script>

"""

    var success:Bool = false
    var htmlPath:String = ""
}


extension BuilderList{

    //生成所有APP 列表页面
    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let apps:[AppHomeListTable]? = try db.getObjects(fromTable: AppHomeListTable.tableName)
            if let list = apps {
                for item in list {
                    let bundleID:String = item.bundleID
                    let type  = item.type
                    builder(bundleID: bundleID, appType: type)
                }
            }
        } catch  {
            print(error)
        }
    }


    //生成指定具体的APP列表页面
    func builder(bundleID:String, appType:AppType){
        success = false
        var h5String:String = ""
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let list:[AppReleaseListTable]? = try db.getObjects(fromTable: AppReleaseListTable.tableName, where: AppReleaseListTable.Properties.bundleID == bundleID && AppReleaseListTable.Properties.type == appType, orderBy: [AppReleaseListTable.Properties.updateDate.asOrder(by: .descending)])

            if let h5 = parser(list: list) {
                h5String = h5
                success = true
            }
        } catch  {
            print(error)
        }

        if success {
            let detailsData = h5String.data(using: .utf8)
            let fileManager = FileManager.default
            fileManager.createFile(atPath: Config.appPath+htmlPath, contents: detailsData, attributes: nil)
            fileManager.createFile(atPath: Config.syncPath+htmlPath, contents: detailsData, attributes: nil)
        }
    }

    private func parser(list:[AppReleaseListTable]?) -> String?{
        if list != nil && list?.first != nil {
            let list:[AppReleaseListTable] = list!
            var h5:String = bodyBegin;
            var node:String = ""

            for item in list {
                node += dymainItem(item)
            }

            h5 += node
            h5 += bodyEnd
            h5 += dymaninJS(list.first!)

            htmlPath = list.first!.srcRoot!+"Release.html"
            return h5
        }else{
            return nil
        }
    }
}


extension BuilderList{

    func dymaninJS(_ item:AppReleaseListTable) -> String{
        let str:String = """
<!-- 用于动态写入数据 -->
<script type="text/javascript">
    let appType = "\(item.type.rawValue)" // ios or android

    let appName = "\(item.name!)"
    let appVersion = "\(item.version!) ( Build \(item.build!) ) "

</script>
"""
        return str
    }

    func dymainItem(_ item:AppReleaseListTable) -> String{
        let node:String = """
    <!-- list item begin-->
    <div name="item" class="list-item-mob">

        <div class="list-item-left">
            <img src="\(item.appIconPath!.fileName)" class="list-img-size100 ">
        </div>

        <div name="item-center" class="list-item-center-mob">

            <div class="list-app-name">
                <span><img name="appTypeIcon" src="src/images/apple.png" class="list-app-img-size22"></span>
                <span >\(item.name!)</span>
            </div>

            <div class="list-app-info">
                <div>
                    <span>BundleID：</span>
                    <span>\(item.bundleID!)</span>
                </div>
                <div>
                    <span >版本：</span>
                    <span>\(item.version!) (Build \(item.build!))</span>
                </div>
                <div class="list-app-update">
                    <span><img src="../../../src/images/update.png" class="list-app-update-img"></span>
                    <span >\(DateFormatter.dateStringWith(date: item.updateDate))</span>
                </div>

            </div>
        </div>

        <div name="item-right" class="list-item-right-mob">
            <button class="list-btn-pre", onclick="window.open('\(item.detailsH5Path!.fileName)')"> 预览 </button>
        </div>

        <div class="list-item-space">
        </div>
    </div>
    <!-- list item end-->

"""
        return node
    }

}
