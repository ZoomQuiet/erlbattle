详细的EB 开始教程 ...


# 预习 #
EB 不是一个单纯的对战游戏，而是为了引导大家在游戏中学习 Erlang 这门面向未来的奇妙语言;
  * 要享受EB 的魅力，你得拿出全部想象力和智力来，为自个儿编写战队，来投入 **[恶狼战役](ErlBattle.md)** 和其它战队进行生死较量！
  * 所以，参加者必须有以下最最最基本知识储备:
    1. 认识E文,只要`1.618级`水平就成 <sup>认得足26个字母，会查字典</sup>
    1. 有电脑编程体验,任何一种语言都可以 (不过在EB中，注定是得全面颠覆的;-)
    1. 有足够的好奇心，愿意探寻 Erlang 的世界
    1. 有足够开放的心态，愿意主动咨询，也愿意分享经验！

## 好书 ##
**"[Erlang程序设计](http://www.douban.com/subject/3260311/)"** <sup>(豆瓣)</sup>


# Ubuntu #
`假定在 8.04 环境中`

## 快入流程 ##
需要: [erl-otpR12B-5~下载地址](http://www.erlang.org/download.html)

# Linux
需要gnumake
```
#./configure
#make
```

# 启动erl
```
>erl
```

# 加载ebin路径
  * .beam文件，也就是erlang代码所编译出来的字节码
  * ebin目录包含了所有这些beam文件
  * 要运行这些文件首先erl需要在知道这些文件在那
  * 可以在erl环境下使用
```
1>code:add_pathz("ebin").
```
加载我们的代码（.是erlang语句的结束符不能少.

在erl交互环境下输入`code:getpath().`可以看到当前系统所加载的代码目录.

# 启动erlbattle
```
2>erlbattle:start().
```
战斗结果或保存于warfield.txt

# 观看结果(windows)
```
3>os:cmd("copy warfield.txt _fla").
4>os:cmd("_fla\\Index.html").
```

## 环境准备 ##
`推荐使用 Debian 系的有良好软件仓库支持的发行版本`
~ 这里以 ubuntu 8.04 为例进行说明
### 安装 erl ###
#### apt ####
```
$sudo apt-get install erlang
```

或是在`新立得`中搜索 erlang 并安装

![http://erlbattle.googlecode.com/files/2009-07-18-154413_544x245_scrot.png](http://erlbattle.googlecode.com/files/2009-07-18-154413_544x245_scrot.png)

  * 输入命令 erl 就进入了 Erlang shell
```
~> erl
Erlang (BEAM) emulator version 5.5.5 [source] [async-threads:0] [kernel-poll:false]

Eshell V5.5.5  (abort with ^G)
```

`即 R11B5`

#### CEAN ####
**[Comprehensive Erlang Archive Network](http://cean.process-one.net/doc/)**
  * Erlang软件收藏库
  * 效仿[CPAN](http://www.cpan.org/) 的又一个规范的友好的可无限扩展的 Erlang 作品发布平台!
  * 跨平台的轻易安装,并通过一致性的命令安装/升级/卸载 软件!
  * 唯一要注意的是CEAN 可能默认的没有安装编译器,那么只要:
```
cean:install(compiler).
```
当然可以先查看安装了什么软件:
```
 cean:installed().
["appmon","asn1","cean","common_test","compiler","cosEvent",
 "cosEventDomain","cosFileTransfer","cosNotification",
 "cosProperty","cosTime","cosTransactions","crypto",
 "debugger","dialyzer","docbuilder","edoc","et","gs","hipe",
 "ibrowse","ic","inets","inviso","jinterface","kernel",
 "megaco","mnesia",
 [...]|...]
```


下载: http://cean.process-one.net/downloads

搜索: http://cean.process-one.net/packages/

运行:
```
/opt/bin/cean> ./start.sh 
Erlang (BEAM) emulator version 5.6.4 [source] [smp:2] [async-threads:0] [kernel-poll:false]

Eshell V5.6.4  (abort with ^G)
```

`即 R12B`

> 建议::
    * EB 稳定后,也可发布到 CEAN 中! 这样,安装 EB 就可以简单的
```
cean:install(erlbattle).
```



### 安装 svn ###
```
$sudo apt-get install subversion
```
检查安装的版本
```
l> svn --version
svn，版本 1.5.1 (r32289)
   编译于 Oct  6 2008，12:54:52

版权所有 (C) 2000-2008 CollabNet。
Subversion 是开放源代码软件，请参阅 http://subversion.tigris.org/ 站点。
此产品包含由 CollabNet(http://www.Collab.Net/) 开发的软件。

可使用以下的版本库访问模块: 

* ra_neon : 通过 WebDAV 协议使用 neon 访问版本库的模块。
  - 处理“http”方案
  - 处理“https”方案
* ra_svn : 使用 svn 网络协议访问版本库的模块。  - 使用 Cyrus SASL 认证
  - 处理“svn”方案
* ra_local : 访问本地磁盘的版本库模块。
  - 处理“file”方案
```



### 下载代码 ###
```
$ svn checkout http://erlbattle.googlecode.com/svn/trunk/ erlbattle-read-only
```

### 运行EB ###
> 预测试::
```
$ cd /path/to/u/erlbattle-read-only
$ ./configure
$ cd eb0
$ make test
rm -rf .//erlbattle.beam .//battlefield.beam .//tools.beam .//channel.beam .//battleRecorder.beam .//englandArmy.beam .//feardFarmers.beam .//testAll.beam .//testBattleFieldCreate.beam .//testErlBattleTakeAction.beam .//testErlBattleGetTime.beam 
erlc -W +debug_info -o./ erlbattle.erl
erlc -W +debug_info -o./ battlefield.erl
erlc -W +debug_info -o./ tools.erl
erlc -W +debug_info -o./ channel.erl
erlc -W +debug_info -o./ battleRecorder.erl
erlc -W +debug_info -o./ englandArmy.erl
erlc -W +debug_info -o./ feardFarmers.erl
...
```


运行游戏!
```
$ erl -noshell -s erlbattle start
Battle Begin ....
Army matching into the battle fileds....
don't kill us , we are poor farmers 
Battle Recorder Begin to Run 
don't kill us , we are poor farmers 
don't kill us , we are poor farmers 
...
```

#### Linux 中使用虚拟机 ####
`经过测试，发觉eb0 当前只能运行在 R13B01 版本中！如果 在Linux 中无法编译成功的话，只能使用虚拟机进行体验`

  * 正常的下载和安装官方 for M$ 的 [otp\_win32\_R13B.exe](http://erlang.org/download/otp_win32_R13B.exe)
  * 使用默认配置:
![http://erlbattle.googlecode.com/files/2009-07-19-211114_385x299_scrot.png](http://erlbattle.googlecode.com/files/2009-07-19-211114_385x299_scrot.png)

**注意！**
  * 默认安装后， cmd 中无法识别 erl/erlc 等等命令
  * **必须手工在环境变量 path 中追加当前 erlang 的执行程序目录**
![http://erlbattle.googlecode.com/files/2009-07-19-213447_1274x602_scrot.png](http://erlbattle.googlecode.com/files/2009-07-19-213447_1274x602_scrot.png)
  * 然后就可以按照前述步骤进行配置/测试了...
![http://erlbattle.googlecode.com/files/2009-07-19-214212_659x477_scrot.png](http://erlbattle.googlecode.com/files/2009-07-19-214212_659x477_scrot.png)
  * 可惜当前 [r369](https://code.google.com/p/erlbattle/source/detail?r=369) 版本的 eb0 无法运行
![http://erlbattle.googlecode.com/files/2009-07-19-214548_504x486_scrot.png](http://erlbattle.googlecode.com/files/2009-07-19-214548_504x486_scrot.png)


## 编译问题 ##
`eb0当前只能支持 R12B5 以上版本 erl`所以,可能需要自行编译安装:

> 参考::
    * [http://argan.javaeye.com/blog/424110 在ubuntu上编译erlang with wx - 阿干的个人博客 - JavaEye技术网站](.md)
    * [问下UTF-8 编码的erl 文件如何编译和运行 - Erlang China | Google 网上论坛](http://groups.google.com/group/erlang-china/browse_thread/thread/acd8efea64e35e2)
    * 根据:[Erlang 安装手记 - magixyu？magixyu！](http://magixyu.javaeye.com/blog/268998)

### 失败情景 ###
  * 配置时依然..
```
$ ./configure
...
*********************************************************************
**********************  APPLICATIONS DISABLED  **********************
*********************************************************************

odbc           : ODBC library - link check failed

*********************************************************************
*********************************************************************
**********************  APPLICATIONS INFORMATION  *******************
*********************************************************************

wx             : Can not link the wx driver, wx will NOT be useable

*********************************************************************
```
  * 强行编译将:
```
...
23 problems (5 errors, 18 warnings)
make[4]: *** [/usr/local/tmp/0day/otp_src_R13B01/lib/jinterface/priv/com/ericsson/otp/erlang/OtpErlangExit.class] 错误 1
make[4]:正在离开目录 `/usr/local/tmp/0day/otp_src_R13B01/lib/jinterface/java_src/com/ericsson/otp/erlang'
make[3]: *** [opt] 错误 2
make[3]:正在离开目录 `/usr/local/tmp/0day/otp_src_R13B01/lib/jinterface/java_src'
make[2]: *** [opt] 错误 2
make[2]:正在离开目录 `/usr/local/tmp/0day/otp_src_R13B01/lib/jinterface'
make[1]: *** [opt] 错误 2
make[1]:正在离开目录 `/usr/local/tmp/0day/otp_src_R13B01/lib'
make: *** [fourth_bootstrap_build] 错误 2
```

### 只能R12B5 ###
逐一尝试 R13B1/R13B/R12B5 的本地编译后,确认只能成功 R12B5,虽然期间有N多,有关JAVA 的编译错误...
