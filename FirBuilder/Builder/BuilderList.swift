//
//  BuilderList.swift
//  FirBuilder
//
//  Created by PC on 2022/2/14.
//

import Foundation
import WCDBSwift
import KakaJSON


class BuilderList{
    let bodyBegin:String = """
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucen">
<meta name="format-detection" content="telephone=no">
<title>列表</title>
<link rel="icon" type="image/x-icon" href="../../../src/images/favicon.ico">
<link rel="apple-touch-icon" href="../../../src/images/favicon.ico">
<link rel="stylesheet" type="text/css" href="../../../src/css/list.css">
<script type="text/javascript" src="../../../src/js/device.js"></script>
</head>
<body>

<div id="headerID" style="display: none;">
    <div style="text-align: center; line-height: 64px;">
        <h2 id="navName"> </h2>
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
            if (appType == "\(ParserType.ios)") {
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


        showWithID("headerID")
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
    /** 直接查询数据库，生成所有App对应的list.html页面 */
    func builderAll(){
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            var filters:[String:[AppListTable]] = [:]
            let array:[AppListTable] = try db.getObjects(fromTable: AppListTable.tableName)
//            ProcessTask.log("HTML App List array:\(array)   count:\(array.count)")
//            log("HTML App List array:\(array)   count:\(array.count)")
            //取出同一个App的所有版本
            for item in array {
                let key = item.bundleID! + "\(item.type)"
                var value = filters[key]
                if value == nil {
                    value = [];
                }
                value?.append(item)
                filters[key] = value
            }

            for (key, items) in filters {
                builder(list: items)
                log("BuilderList： bundleID:\(key)  count:\(items.count)")
            }
            
        } catch  {
            log(error)
        }
    }
    
    
    /** 根据AppInfoModel生成list.html */
    func builder(_ appInfo:AppInfoModel){
        let bundleID = appInfo.bundleID!
        let type = appInfo.type
        do {
            let db = DBService.shared.db
            defer {
                db.close()
            }
            let list:[AppListTable]? = try db.getObjects(fromTable: AppListTable.tableName, where: AppListTable.Properties.bundleID == bundleID && AppListTable.Properties.type == type, orderBy: [AppListTable.Properties.updateDate.asOrder(by: .descending)])
            //构建
            if let list = list {
                builder(list: list)
            }else{
                log("list.html页面构建失败，没有查询到bundleID为：\(bundleID) 的数据")
            }
        } catch  {
            log(error)
        }
    }

}

extension BuilderList{
    
    /** 构建一个App对应的list.html列表页面*/
    private func builder(list:[AppListTable]){
        //按更新时间降序
        let list = list.sorted{$0.updateDate > $1.updateDate}
        if list.count > 0 {
            var h5String:String = ""
            if let h5 = builderListItem(list: list) {
                h5String = h5
            }
            
            let model = list.first!
            let detailsData = h5String.data(using: .utf8)

            let path = Config.htmlPath+model.srcRoot!+model.listPath!
            ParserTool.save(detailsData, path: path)
        }
    }
    
    /** 获取list.html列表页面的HTML数据 */
    private func builderListItem(list:[AppListTable]?) -> String?{
        if list != nil && list?.first != nil {
            let list:[AppListTable] = list!
            var h5:String = bodyBegin;
            var node:String = ""
            for item in list {
                node += dymainItem(item)
            }
            h5 += node
            h5 += bodyEnd
            h5 += dymaninJS(list.first!)
            return h5
        }else{
            return nil
        }
    }
        
}

extension BuilderList{
    
    func dymaninJS(_ item:AppListTable) -> String{
        let str:String = """
<!-- 用于动态写入数据 -->
<script type="text/javascript">
    let appType = "\(item.type)" // ios or android
    let appName = "\(item.name!)"
    let appVersion = "\(item.version!) ( Build \(item.build!) ) "
</script>
"""
        return str
    }

    func dymainItem(_ item:AppListTable) -> String{
        let node:String = """
    <!-- list item begin-->
    <div name="item" class="list-item-mob">
        <div class="list-item-left">
            <img src="\(item.logo512Path!)" class="list-img-size100 ">
        </div>
        <div name="item-center" class="list-item-center-mob">
            <div class="list-app-name">
                <span><img name="appTypeIcon" src="../../../src/images/apple.png" class="list-app-img-size22"></span>
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
            <button class="list-btn-pre", onclick="window.open('\(item.detailsPath!)')"> 预览 </button>
        </div>
        <div class="list-item-space">
        </div>
    </div>
    <!-- list item end-->
"""
        return node
    }

}

