

> SEE: [恶狼对战大赛](EbRaces.md)
    1. [EBR:triple 的核心指挥艺术](EbrZhuLuHwhTriple.md)
    1. [EBR:战胜triple 的neoe](EbrZhuLuTripleNeoe.md)
    1. [EBR:平triple 的randomArmy](EbrZhuLuTripleRandomArmy.md)

# EBR:平triple 的randomArmy #
[恶狼战役：比赛中和triple 平局的randomArmy 全揭秘](http://groups.google.com/group/erlbattle/browse_thread/thread/8e7a1f4eb213b81b)<sup> - ErlBattle | Google 网上论坛</sup>


randomArmy 也是一个简单程序，但确是在8/1 日那天晚上唯一和triple 打成平局的一个部队。

## 算法： ##
```
1. randomArmy 完全不管全局战略， 当周边没人的时候，就随机走一个方向
2. 当周边有敌人的时候， 战士会很快掉过头来，砍人； 如果前方有敌人的话，会一直砍
```

由于他的行为不确定性（不是一直超前冲），triple 的攻击陷阱不会对他产生影响； triple 在向前运动时，有一定几率被他从侧面打到。 triple
也缺乏围攻的算法来发挥自己在局部的优势。 最终造成结果不确定性。

而和soldierGo 的比赛中，soldierGo 本身的行走不稳定的缺陷和randomArmy 的乱走互相抵消，但soldierGo
有一定的横向围攻的趋势，因此randomArmy 无法战胜soldierGo. 但是能够逼平triple.


```
Regards

老范 
```