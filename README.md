# hookfile
微信抢红包dylib

#脱壳

直接从 xx助手 市场里下载越狱应用可用。
用 dumpdecrypted 进行砸壳

#注入

如果是拿到 .ipa，进行解压即可找到 Payload 文件夹，可安装 iOSOpenDev 来创建工程，使用 CaptainHook 轻松方便写 Hook 代码。

生成动态库(.dylib)后使用 yololib 工具进行注入，不知为何使用 [KJCracks/yololib] Release 中的 yololib-Mac 最终会在设备上闪退，
使用 Urinx/iOSAppHook 则没有问题，一条命令对 .app 中的二进制进行 .dylib 注入，再把注入的 .dylib 拖到目录里即可。
注入成功后可以用 MachOView 程序查看整个 MachO 文件的结构，便可看到注入的 dylib 会在 Load Commands 区段中。

yololib xxx.app/xxx LocationFaker.dylib

#重签名

重签名也是很重要的一个步骤，签名错误或者失败都会导致应用无法安装使用。我比较喜欢用图形化界面的 iOS App Signer 来重签名，自动加载出本机的证书和 PP 文件，相当方便；当然也有命令行工具，比如 Urinx/iOSAppHook 中的 AppResign 或者 Fastlane sign ，前提还是一样需要把设备的 UDID 加进 Provisioning Profile 中，一般来说 Bundle identifier 不需要改变即可，也有应用内做了相关检测手段导致重签名或者更改 Bundle identifier 后无法使用的情况，那就需要更多其他的手段进行反攻了。

#打包

对 Payload 文件夹右键压缩，改名 xx.ipa 即可，推荐用 Xcode (Window->Device) 安装，失败还有错误信息可看。

