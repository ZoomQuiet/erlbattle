

> SEE: [恶狼对战大赛](EbRaces.md)
    1. [EBR:triple 的核心指挥艺术](EbrZhuLuHwhTriple.md)
    1. [EBR:战胜triple 的neoe](EbrZhuLuTripleNeoe.md)
    1. [EBR:平triple 的randomArmy](EbrZhuLuTripleRandomArmy.md)

# EBR:neoe 战胜 triple 揭秘 #
[恶狼战役：neoe 战胜 triple 揭秘](http://groups.google.com/group/erlbattle/browse_thread/thread/d178d53e8ed66b00)<sup> - ErlBattle | Google 网上论坛</sup>

neoe 的代码很简单，比triple 简单无穷多倍，但是可以轻松战胜triple.

## neoe 的算法： ##
```
1.  一号战士：   这个战士是正常行进的，前方如果没人就向前一步。直到碰到人，就砍
2.  其他战士：   这些战士看前三格，如果前三格都没人，就向前一步。否则就原地砍。等别人上来送死
3. 当部队走到底线后， 转身，继续上述循环
```

## 对战分析 ##
上次我们谈过triple 的算法；
```
1. triple 在发现前面两格有敌人的时候， 就会开始砍，否则前进
```
如果按照算法而言， 他们的战斗会以neoe 失败告终。 应为1号战士会冲上去，被triple先砍一刀。 其他9个会僵局。 最后1000回合后，neoe
失败。

但是结果不是这样的。 结果是neoe 每轮都赢。

看录像：
```
1. 按照逻辑预想的9vs9 僵局并没有出现， 两军还是很快的碰到一起，打起来了
2. 这9个战士基本上都是neoe 先出刀。
```
因此neoe 总是能够战胜triple.

其实这样的战局是triple 存在一个bug, hwh 尚未意识到。  什么bug 我就不说了， 那是 hwh 自己的事了。

```
Regards

老范 
```