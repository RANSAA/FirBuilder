//获取设备类型
function getDeviceName(){
    let agent = navigator.userAgent.toLowerCase();
    console.log(agent)

    if ( isIPad() ) {
        return "ipad"
    }
    else if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
        return 'iphone';
    }
    else if (/android/.test(agent) && /mobile/.test(agent)) {
        return 'android';
    }
    else if (/macintosh/.test(agent)) {
        return 'mac';
    }
    else if (/windows/.test(agent)) {
        return 'windows';
    }
    else if (/linux/.test(agent)) {
        return 'linux';
    }
    else {
        return 'other';
    }
}


/**
 * 获取设备类型：iOS，Android，macOS，Windows，Linux
 **/
function getDeviceType(){
    const agent = navigator.userAgent.toLowerCase();
    console.log(agent)

    if ( isIPad() ) {
        return 'iOS';
    }
    else if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
        return 'iOS';
    }
    else if (/android/.test(agent) && /mobile/.test(agent)) {
        return 'android';
    }
    else if (/macintosh/.test(agent)) {
        return 'mac';
    }
    else if (/windows/.test(agent)) {
        return 'windows';
    }
    else if (/linux/.test(agent)) {
        return 'linux';
    }
    else {
        return 'other';
    }
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
