

# 老范随笔 #

## erlang 的 if ##

```
if 
   a ->  do a
   b ->  do b
   true -> do c
end.
```

如果转换为其他语言的代码：

```
if a {
   do a
   }  
else {
   if b {
      do b 
   } 
   else {
      do c
   }
```

在最简单的if 语法上就有巨大区别。不知道为什么这么多主流语言都用后面的模式， 而erlang 选择了一个极其简单的模式。

## 编译子目录文件 ##
我摸索了老半天，猜出来的。
```
c("laofan/abc"). 
```

其中 abc  的module 要定义为：   `laofan.abc`

## 如何开发第一个指挥程序 ##
[饿狼战役：如何开发第一个指挥程序](http://groups.google.com/group/ecug/browse_thread/thread/3f382d7b7b3cf6aa) <sup>- ECUG~erlang中文用户组 | Google 网上论坛</sup>

## 如何应对erl 的程序缓冲? ##
`现象`:
  * 老范:今天改erlbattle 一个小bug， 改了老半天都没效果； 后来发现把erlang 的console 关掉，重新打开就好了。 竟然是erlbattle 程序被缓冲了， 新的修改不生效！以前调试的时候重来没这个问题， 差别在于原来在源码目录里编译，并运行。 现在用nmake 编译， 在ebin 目录中运行。   是会这样的吗？

`对策`:
  * Evan Tao:我用的是make:all([load](load.md))。这样应该自动执行了code:load\_file/1
    * erlang 不会自动加载编译后产生新的beam文件，要用code:load\_file/1手工加载
    * 在shell里面使用c/1也可以达到同样的目的。不过make:all/1可以使用emakefile编译多个文件，相比起来c/1没那么方便。




### 问题 ###
ZoomQuiet::  比如说，老范是如何从无到有开发 MadDog 的？
  * - 如何先自行调试,组合行动指挥的?
  * - 如何再结合 erlbattle 进行对战调试的?

### 体验 ###
第一次编写指挥程序的步骤

  1. 首先务必要把自己的环境搞好， 能够运行 erlbattle:start()  ,   让农民和英格兰卫兵打一场。 然后观看录像
  1. 试着运行erlbattle:start(englandArmy, englandArmy)  , 让英格兰卫兵互相打一场
  1. （现在可以了） 试着运行 erlbattle:start(englandArmy,  madDog)   让英格兰卫兵和疯狗战阵打一场，看看效果
  1. 按照以下顺序阅读【feardFarmers】---> 【englandArmy】----->【madDog】 代码
    * （如果有兴趣还可以去看看wiki 上各篇文档，不看文档也行）
  1. 模仿现有的这几个开始编写你自己的指挥程序。 可以稍微改一点，看看效果，然后再改一点。。。直到做出来。 不要先想的过于复杂，先从简单入手


erlbattle 接口非常非常简单。
  * 就是有一个battle\_field 表可以查战场状态，（ 一个clock 表查时钟。 一个queue
表查自己已经发出的指令。 这两个其实不查都可以，疯狗就没用）。
  * 然后就一个用于发送消息指令的通道。 你把你的指令算好，通过通道发出去就行了。

### 调试疯狗的过程： ###

我现在还不知道erlang 如何做debug,  所以代码写好了，都是一点点写io:format(...) 去调试的。  直到全部调试通过。
还是蛮花时间的。

  * 调试都是打： erlbattle:start(englandArmy,  madDog)   这个命令，去调试的。
  * 最后都通了， englandArmy 被全部干掉了。 程序也就好了。没什么技巧。

老范


# ZQ 记要 #


# Discuss #
`常见其它开发/语法/理解问题...`