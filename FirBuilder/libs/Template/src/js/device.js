//获取设备类型
function getDeviceName(){
    // let agent = navigator.userAgent.toLowerCase();
    // console.log(agent)
    // if ( isIPad() ) {
    //     return "iPad"
    // }
    // else if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
    //     return 'iPhone';
    // }
    // else if (/android/.test(agent) && /mobile/.test(agent)) {
    //     return 'Android';
    // }
    // else if (/macintosh/.test(agent)) {
    //     return 'Mac';
    // }
    // else if (/windows/.test(agent)) {
    //     return 'Windows';
    // }
    // else if (/linux/.test(agent)) {
    //     return 'Linux';
    // }
    // else {
    //     return 'Other';
    // }


    const agent = navigator.userAgent.toLowerCase();
    // 设备检测规则表（按优先级排序）
    const rules = [
        { test: () => isIPad(agent), name: 'iPad' },
        { test: () => /(iphone|ipod).*mobile/.test(agent), name: 'iPhone' },
        { test: () => /android.*mobile/.test(agent), name: 'Android' },
        { test: () => /macintosh/.test(agent), name: 'Mac' },
        { test: () => /windows/.test(agent), name: 'Windows' },
        { test: () => /linux/.test(agent), name: 'Linux' }
    ];
    // 查找匹配的第一个规则
    for (const rule of rules) {
        if (rule.test()) {
            return rule.name;
        }
    }
    return 'Other';
}


/**
 * 获取设备类型：iOS，Android，macOS，Windows，Linux
 **/
function getDeviceType(){
    // const agent = navigator.userAgent.toLowerCase();
    // console.log(agent)
    // if ( isIPad() ) {
    //     return 'iOS';
    // }
    // else if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
    //     return 'iOS';
    // }
    // else if (/android/.test(agent) && /mobile/.test(agent)) {
    //     return 'Android';
    // }
    // else if (/macintosh/.test(agent)) {
    //     return 'Mac';
    // }
    // else if (/windows/.test(agent)) {
    //     return 'Windows';
    // }
    // else if (/linux/.test(agent)) {
    //     return 'Linux';
    // }
    // else {
    //     return 'Other';
    // }


    const agent = navigator.userAgent.toLowerCase();
    // 设备检测规则表（按优先级排序）
    const rules = [
        { test: () => isIPad(agent), type: 'iOS' },
        { test: () => /(iphone|ipod).*mobile/.test(agent), type: 'iOS' },
        { test: () => /android.*mobile/.test(agent), type: 'Android' },
        { test: () => /macintosh/.test(agent), type: 'macOS' },
        { test: () => /windows/.test(agent), type: 'Windows' },
        { test: () => /linux/.test(agent), type: 'Linux' }
    ];
    // 查找匹配的第一个规则
    for (const rule of rules) {
        if (rule.test()) {
            return rule.type;
        }
    }
    return 'Other';
}




//是否是iPad系列设备
//iPad (iPad Air, iPad Pro, iPad mini)类型区分还需要通过屏幕尺寸区分
function isIPad(){
    const agent = navigator.userAgent.toLowerCase();
    const width = window.screen.width;
    const height = window.screen.height;
    // console.log("width:" + width + " height:" + height)

    //ipad mini
    if (/ipad/.test(agent) && /mobile/.test(agent)) {
        return true;
    }
    // ipad air, ipad pro, or macos
    else if ( /macintosh/.test(agent) ) {
        if (width === 1668 && height === 2224) {
            // return 'iPad Air (10.5 inches)';
        } else if (width === 1640 && height === 2360) {
            // return 'iPad Air (10.9 inches)';
        } else if (width === 1668 && height === 2388) {
            // return 'iPad Pro (11 inches)';
        } else if (width === 2048 && height === 2732) {
            // return 'iPad Pro (12.9 inches)';
        } else if (width === 1488 && height === 2266) {
            // return 'iPad mini (8.3 inches)';
        } else if (width === 1536 && height === 2048) {
            // return 'iPad mini (7.9 inches)';
        }
        else if (width === 1024 && height === 1366) {
            // return 'iPad mini (7.9 inches)';
        }
        else if (width === 820 && height === 1180) {
            // return 'iPad mini (7.9 inches)';
        }
        else if (width === 769 && height === 1024) {
            // return 'iPad mini (7.9 inches)';
        }
        //
        //macos 或者 其它尺寸的iPad设备
        else{
            return false;
        }
        //符合预设高与宽的iPad设备
        return true;
    }
    else {
        return false;
    }

}


//是否是移动设备
function isMobile(){
    var w = document.documentElement.clientWidth;
    console.log("device width: "+w)
    if (w < 660) {//460
        return true;
    }
    return false;
}



//https://www.cnblogs.com/zhang-hong/p/13501049.html
function showWithID(id){
    document.getElementById(id).style.display = "block";
}

function hiddenWithID(id){
    document.getElementById(id).style.display = "none";
}



 // 定义事件侦听器函数
function watchWindowSize() {
// 获取窗口的宽度和高度，不包括滚动条
    var w = document.documentElement.clientWidth;
    var h = document.documentElement.clientHeight;
}



/**
 *  功能：生成二维码，中心图片可选
 *  qrcodeText：二维码编码内容
 *  imgID: 提供image图片地址的IMG标签ID，如果不存在则不生成中心图片
 *  PS: https://github.com/555chy/qrcodejs
 **/
function buildQRCodeWithImg(qrcodeText, imgID) {
    var img = document.getElementById(imgID)
    // console.log(qrcodeText)
    // console.log(img.src)
    var qr = new QRCode("qrcode", {
            //二维码内容
            text: qrcodeText,
            width: 170,
            height: 170,
            colorDark: '#000000',
            colorLight: '#ffffff',
            /*!
            容错级别，可设置为：
            QRCode.CorrectLevel.L
            QRCode.CorrectLevel.M
            QRCode.CorrectLevel.Q
            QRCode.CorrectLevel.H
            */
            //容错级别天地可能会失败
            correctLevel: QRCode.CorrectLevel.M,
            //二维码中心图片地址
            iconSrc:img.src,
            iconRadius: 10,
    });
    return qr
}


/**
 *  功能：生成二维码，中心图片可选
 *  qrcodeText：二维码编码内容
 *  url: 二维码中心图片的资源地址，如果不存在则不生成中心图片
 *  PS: https://github.com/555chy/qrcodejs
 **/
function buildQRCodeWithUrl(qrcodeText, url) {
    var img = document.getElementById(imgID)
    // console.log(qrcodeText)
    // console.log(img.src)
    var qr = new QRCode("qrcode", {
            //二维码内容
            text: qrcodeText,
            width: 170,
            height: 170,
            colorDark: '#000000',
            colorLight: '#ffffff',
            /*!
            容错级别，可设置为：
            QRCode.CorrectLevel.L
            QRCode.CorrectLevel.M
            QRCode.CorrectLevel.Q
            QRCode.CorrectLevel.H
            */
            //容错级别天地可能会失败
            correctLevel: QRCode.CorrectLevel.M,
            //二维码中心图片地址
            iconSrc:url,
            iconRadius: 10,
    });
    return qr
}






/**
 * iOS & Androif禁用缩放
 * <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
 * 禁用缩放补充（增强 iOS 兼容性）
 * iOS Safari 的特殊行为：
 * 即使设置 user-scalable=no，仍可能通过双击或手势缩放。
 * 需要额外阻止 touchstart和 gesturestart事件。
 */
function disableZoomSupplement(){
    // <!-- 防止 iOS Safari 双击缩放 -->
    document.addEventListener('touchstart', function(event) {
      if (event.touches.length > 1) {
        event.preventDefault();
      }
    }, { passive: false });

    // 防止 iOS Safari 手势缩放
    document.addEventListener('gesturestart', function(event) {
      event.preventDefault();
    });
}




/**
 * 禁用文本选择功能，包括：
 * 1. 禁用文本选择（除了CSS方法外，添加JS增强）
 * 2. 禁用右键菜单
 * 3. 禁用复制
 * 4. 禁用剪切
 * 5. 禁用拖拽
 * 6. 禁用Ctrl+C
 * 7. 禁用Ctrl+U（查看源代码）
 * 8. 禁用F12和Ctrl+Shift+I（开发者工具）
 **/
function disableTextSelect(){
document.addEventListener('DOMContentLoaded', function() {
        // 禁用文本选择（除了CSS方法外，添加JS增强）
        document.body.addEventListener('selectstart', function(e) {
            e.preventDefault();
            return false;
        });
        
        // 禁用右键菜单
        document.addEventListener('contextmenu', function(e) {
            e.preventDefault();
            showMessage('右键菜单已被禁用');
            return false;
        });
        
        // 禁用复制
        document.addEventListener('copy', function(e) {
            e.preventDefault();
            showMessage('复制功能已被禁用');
            return false;
        });
        
        // 禁用剪切
        document.addEventListener('cut', function(e) {
            e.preventDefault();
            return false;
        });
        
        // 禁用拖拽
        document.addEventListener('dragstart', function(e) {
            e.preventDefault();
            return false;
        });
        
        // 拦截Ctrl+C、Ctrl+U、Ctrl+Shift+I等快捷键
        document.addEventListener('keydown', function(e) {
            // 禁用Ctrl+C
            if (e.ctrlKey && e.keyCode === 67) {
                e.preventDefault();
                showMessage('复制快捷键(Ctrl+C)已被禁用');
                return false;
            }
            
            // 禁用Ctrl+U（查看源代码）
            if (e.ctrlKey && e.keyCode === 85) {
                e.preventDefault();
                showMessage('查看源代码功能已被禁用');
                return false;
            }
            
            // 禁用F12和Ctrl+Shift+I（开发者工具）
            if (e.keyCode === 123 || (e.ctrlKey && e.shiftKey && e.keyCode === 73)) {
                e.preventDefault();
                showMessage('开发者工具已被禁用');
                return false;
            }
        });
        
        function showMessage(msg) {
            console.log(msg)
            // return;

            // 创建消息提示元素
            let messageEl = document.createElement('div');
            messageEl.style.position = 'fixed';
            messageEl.style.top = '20px';
            messageEl.style.left = '50%';
            messageEl.style.transform = 'translateX(-50%)';
            messageEl.style.backgroundColor = 'rgba(255, 71, 87, 0.9)';
            messageEl.style.color = 'white';
            messageEl.style.padding = '10px 20px';
            messageEl.style.borderRadius = '5px';
            messageEl.style.zIndex = '10000';
            messageEl.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
            messageEl.textContent = msg;
            document.body.appendChild(messageEl);
            // 2秒后消失
            setTimeout(function() {
                document.body.removeChild(messageEl);
            }, 1000);
        }
    });
}










