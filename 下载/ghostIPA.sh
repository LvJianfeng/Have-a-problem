#!/bin/bash
echo "鬼知道刚才发生了什么..."
echo "伪自动化打包，准备开始..."
for i in 1 2 3; do
	#statements
	echo "---------------------"
done

#
time=$(date -u +%m%d%s)

echo "请问项目是否有pod管理(默认y)？y/n"
read isPod

echo "选择输出模式（默认app）：1 = app， 2 = archive"
read isOutMethod

echo "请输入项目工程名：（例如：Demo.xcworkspace = Demo）"
read projectName

if [[ $projectName = "" ]]; then
	echo "工程名称必须输入！！！"
	exit
fi

echo "请输入Target name: (不输入则为工程名)"
read targetName

if [[ $targetName = "" ]]; then
	targetName=$projectName
fi

echo "请输入ipa输出目录地址（结尾/）："
read outputPath
echo "你输入的地址为：$outputPath"

if [[ ! -n "$outputPath" ]]; then
	echo "输出地址不存在，系统已自动创建！"
fi


echo "注意注意，请输入项目路径："
read filepath 

if [[ $filepath = "" ]]; then
	echo "回车太快了，项目文件没有输入！！！"
	exit
fi

cd $filepath

xcodebuild clean

if [[ $isPod = "n" ]]; then
	if [[ $isOutMethod = 2 ]]; then
		xcodebuild archive -project $projectName.xcworkspace -scheme $targetName -archivePath $outputPath/$projectName$time.xcarchive
	else
		xcodebuild -project $projectName.xcworkspace -target $targetName build
	fi
else
	if [[ $isOutMethod = 2 ]]; then
		xcodebuild archive -workspace $projectName.xcworkspace -scheme $targetName -archivePath $outputPath/$projectName$time.xcarchive
	else
		xcodebuild -workspace $projectName.xcworkspace -scheme $targetName build
	fi
fi

if [[ $isOutMethod = 2 ]]; then
		if [[ -n "$projectName/info.plist" ]]; then
			xcodebuild -exportArchive -archivePath $outputPath/$projectName$time.xcarchive -exportPath $outputPath/$projectName$time.ipa -exportOptionsPlist $projectName/info.plist
		else
			echo "当前目录：$pwd,没有找到info.plist地址，请输入："
			read plistPATH
			if [[ $plistPATH = "" ]]; then
				echo "回车太快了，还没有输入！！！"
				exit
			fi
			xcodebuild -exportArchive -archivePath $outputPath/$projectName$time.xcarchive -exportPath $outputPath/$projectName$time.ipa -exportOptionsPlist $plistPATH/info.plist
		fi
else
	echo "等一下："
	echo "请输入App地址告诉我：(Validate 后面的地址...)"
	read appfilepath

	if [[ $appfilepath = "" ]]; then
		echo "地址不存在或为空！！！"
		exit
	fi

	xcrun -sdk iphoneos -v PackageApplication $appfilepath -o  $outputPath/$projectName$time.ipa
fi

#删除
unset isPod
unset projectName
unset targetName
unset filepath

echo "伪自动化打包结束"
exit


