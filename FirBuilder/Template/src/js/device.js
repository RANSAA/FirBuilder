//获取设备类型
function getDeviceName(){
    let agent = navigator.userAgent.toLowerCase();
    if (/windows/.test(agent)) {
        return 'Windows';
    } else if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
        return 'iPhone';
    } else if (/ipad/.test(agent) && /mobile/.test(agent)) {
        return 'iPad';
    } else if (/android/.test(agent) && /mobile/.test(agent)) {
        return 'Android';
    } else if (/linux/.test(agent)) {
    return 'Linux';
    } else if (/mac/.test(agent)) {
        return 'Mac';
    } else {
        return 'other';
    }
}

//获取设备类型
function getDeviceType(){
    let agent = navigator.userAgent.toLowerCase();
    console.log(agent)
    if (/iphone|ipod/.test(agent) && /mobile/.test(agent)) {
        return 'ios';
    } else if (/ipad/.test(agent) && /mobile/.test(agent)) {
        return 'ios';
    } else if (/android/.test(agent) && /mobile/.test(agent)) {
        return 'android';
    } else {
        return 'other';
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
