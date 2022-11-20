# FirBuilder
App分发平台静态网页生成器

# 窗口模式
直接打开app即可

# cli模式
直接在终端中运行：
运行方式:
```
xxxx/FirBuilder.app/Contents/MacOS/FirBuilder -h
```
使用参数：
```
-h,-help           :帮助
-win               :强制使用窗口模式运行程序
-cli               :强制使用Command模式运行程序
-buildPath         :自定义FirBuilder资源输出路径，示例：-buildPath=/Users/kimi/Downloads/FirBuilder
-serverRoot        :自定义服务器资源存储路径，示例：-serverRoot=https://fir.netlify.app
-inputPath         :自定义需要解析app的文件路径，示例：-inputPath=/Users/kimi/Desktop/AnLinux-App-v6.50.apk
-html              :重新构建所有HTML页面
-sync              :生成同步目录,同步目录不含应用包
-d                 :删除指定BundleID对应的App，示例：-d=com.package.name
-ios,-android      :删除应用时指定App的类型，如果没有该参数表示删除所有符合-d的应用，只有指定-d时该参数才有效。
```