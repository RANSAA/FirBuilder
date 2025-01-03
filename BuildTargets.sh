#!/usr/bin/env bash 

#切换进入当前目录
path=$0
first=${path:0:1}
if [[ $first == "/" ]]; then
	path=${path%/*}
	cd "${path}"
fi
clear



## 计算任务执行总时间
startCalculationTime(){
	echo 开始执行任务...... 
	echo "当前路径:$(pwd)"
	start_time=$(date +%s)
}
endCalculationTime(){
	end_time=$(date +%s)
	cost_time=$[$end_time - start_time]
	# cost_time=$((cost_time -1))
	echo
	echo
	echo "任务执行完毕，总共耗时：$(($cost_time)) s"
}
startCalculationTime



echo "开始构建:FirBuilder"
# xcodebuild -project GeneralExec.xcodeproj -target ProperTree 


xcodebuild -workspace FirBuilder.xcworkspace -scheme FirBuilder -configuration Release -derivedDataPath .build



buildPath="$(pwd)/.build/Build/Products/Release"
output="$HOME/Desktop/FirBuilder-$(date)/"


mkdir -p "$output"
cp -rf "${buildPath}/FirBuilder.app" "$output"



#删除构建缓存
rm -rf "$(pwd)/.build"

echo "FirBuilder 构建完毕....."
open "${output}"


endCalculationTime
