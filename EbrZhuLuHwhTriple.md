

> SEE: [恶狼对战大赛](EbRaces.md)
    1. [EBR:triple 的核心指挥艺术](EbrZhuLuHwhTriple.md)
    1. [EBR:战胜triple 的neoe](EbrZhuLuTripleNeoe.md)
    1. [EBR:平triple 的randomArmy](EbrZhuLuTripleRandomArmy.md)

# EBR:triple 的核心指挥艺术 #
[恶狼战役：hwh 冠军程序 triple 全揭秘](http://groups.google.com/group/erlbattle/browse_thread/thread/1826cf55c6ed76ab)<sup> - ErlBattle | Google 网上论坛</sup>

通读了Triple 程序， hwh 同志为了隐藏算法的真谛，关键地方没有写注释。但是仍然逃不脱被揭秘的命运
```
1. 在triple 的关键地方增加了注释
2. 在此揭秘 Triple 核心指挥艺术
```

## 策略一： 条状战区划分策略 ##

hwh 把战场按照纵坐标划分为三个条状的战区
  * 0-4，
  * 5-9，
  * 10-14 ；
`如果该战区中没有敌人，或者我方人数超过敌人一倍以上；`
  * 就开始自由追击敌人；
  * 否则保持向前压的态势。避免阵形破坏；
  * 阵形都是保持了坑型，能够围攻敌人的形状

## 策略二： 触敌后迎战策略 ##
```
如果前面有敌人就砍
如果前面两格有敌人也砍
```
此时hwh 率先使用了`act_sequence` 参数。
如果前一格有敌人，出刀，att\_sequence 取 0，确保抢先出刀，免得敌人走开了砍空。

如果前二格有敌人，出刀，att\_sequence 取 4，避免出刀的时候敌人还没到造成砍空；

```
如果前两格都没人，则看周围1格内有没有敌人，
    如果有的话，优先转向背对我的敌人，因为攻击加成×4。
```

## 策略三： 寻路算法 ##
`util:astar` 编写了一个启发式搜索寻路算法(A★)<br>
使得战士能够找到最合理的路径走到目标位置，途中的障碍物也得到了充分考虑<br>
<pre><code>FirstOpn = #opn<br>
    {<br>
        pos = Src,                %当前位置<br>
        parent = [],              %走到当前位置前面经历的节点<br>
        fcos = 0,                 %走到当前位置的开销（含转身）<br>
        gcos = dist(Src, Dest),   %已知开销+理论开销； 这个值用于评估方案的优劣<br>
        facing = Facing           %当前朝向<br>
    },<br>
</code></pre>
算法的核心数据结构我做了注释，大家应该很容易能够看懂了。<br>
<br>
<h2>总结</h2>
通过这些算法HWH 的程序赢得真不是偶然的。<br>
<ul><li>策略1 保证了战略态势上的优势，<br>
</li><li>策略2保证了迎战时精确的控制，<br>
</li><li>策略3保证了行军的最优化。</li></ul>

各方面都考虑得很周到。