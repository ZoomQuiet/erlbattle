<wiki"toc/>

# EB:调试 #
> 来源:
    * [饿狼战役：如何开发第一个指挥程序](http://groups.google.com/group/ecug/browse_thread/thread/3f382d7b7b3cf6aa)<sup> - ECUG~erlang中文用户组 | Google 网上论坛</sup>

## debugger ##

Erlang的debugger是一个gui的调试工具。调试要执行下面几步

### 1. 编译 ###
只有编译时加上debug\_info的模块才能被调试
在erlang shell中加上debug\_info标志如下
```
1>c(MODULE, debug_info).
%%使用erlc的例子如下：
erlc +debug_info ms.erl
```

### 2. 启动 ###
调试器的启动可以通过debugger:start()或者im().
启动可以选择模式，默认是global模式即所有已知节点此模块

### 3. 指定要调试模块 ###
  * 如果模块要调试，必须先被interpreted,
  * 可以通过菜单项Module->Interpret选择文件，没有debug信息的文件将提示失败，
  * 加载完成之后，就可以通过Module->MODULE->view查看源代码，在代码行双击即可设置断点。

### 4. 调试 ###
  * 当一个模块别标志为interpreted之后，我们在此模块代码设置断点，之后启动的进程都会进入调试状态。
  * 我们也可以通过菜单Process->Attach，attach到一个运行中的进程。

### 5. 特殊情况 ###
我们使用otp的behavior时，我们自动模块都是一些call back,
正在运行otp behavior的代码，我们看到进程会处于idle状态。


# SEE #
  * [EB:是什么?](EbWhatItIs.md)
  * [EB:释名](EbBattle.md)