# eb0.1:开发任务进度表 #

**复杂任务的详细需求请参看：[EB:开发任务需求和算法详细描述](EbTaskDoc.md)**

`请大家主动在表格对应位置注明自个儿的名字，标识认领，并及时主动注明进度和对应的 Changeset`
|＃ | 任务 | 认领 | 进度 | 备注<sup>Changeset , Issue 相关链接...</sup> |
|:---|:-------|:-------|:-------|:---------------------------------------------------|
|eb0-19 | 编写标准的日志工具，要把日志先全部写在内存中，在退出的时候保存到日志文件，以免调试输出所花的时间，影响战斗结果| Karl Ma | 100% | 建议另外起一个进程，写日志就是向这个进程发消息。<br>完成了日志记录器的功能。<br>使用日志记录的模块只需要包含schema.hrl就可以，接口使用情况在testEbLogger中有详细的说明。<br>
<tr><td>eb0-20 </td><td> 使用上述内存日志工具，改写现有的调试代码</td><td> Karl Ma </td><td> ？？% </td><td>依赖任务19 </td></tr>
<tr><td>  eb0-31 </td><td> 在主战场初始化阶段，判断是否有模块重名冲突，如果有，则退出游戏 </td><td> ？？ </td><td> ？？% </td><td> 以后队伍多的话，模块有可能冲突的啦。我只知道能用code:clash/1查看，其他的不是很熟悉了 </td></tr>
<tr><td><del>eb0-33</del> </td><td> <del>所有目录的编译结果均放置到ebin目录</del> </td><td> hwh008 </td><td> 100% </td><td> 游戏引擎的编译结果放在ebin目录下，test相关的代码放在ebin/test目录下，其他各个队伍的编译结果放在ebin/队伍名的目录下<br> <a href='https://code.google.com/p/erlbattle/source/detail?r=605'>r605</a>  <a href='https://code.google.com/p/erlbattle/source/detail?r=647'>r647</a></td></tr>
<tr><td><del>eb0-34</del> </td><td> <del>保护channel不被决策程序异常退出拉下来</del></td><td> 老范 </td><td> 100% </td><td> 现在channel 和玩家决策程序是link 在一起的。 原来希望channel结束时能自动关掉子程序， 现在反过来如果子程序关掉，channel 也被拉下来了。 需要修改channel 对于退出消息的处理机制，解决这个问题。（这种情况战斗应该继续进行，相当于一方指挥官死亡，他的部队被对方屠杀）</td></tr>
<tr><td><del>eb0-35</del> </td><td> <del>把attack, red,blue 等全部改为用atom ， 在代码中使用宏，不要写死</del> </td><td> Evan </td><td> 100% </td><td> <a href='https://code.google.com/p/erlbattle/source/detail?r=712'>r712</a> </td></tr>
<tr><td>eb0-36 </td><td> 发布bin 运行包，将编译好的环境以及回放器打包 </td><td> Evan </td><td> 30% </td><td>便于新手快速能够看到效果，然后能够逐步介入</td></tr>
<tr><td><del>eb0-37</del> </td><td> <del>清理所有其他make 文件，完全走make:all() 模式</del> </td><td> 老范 </td><td> 100% </td><td>同时需要修改文档</td></tr>
<tr><td>＃ </td><td> 任务 </td><td> 认领 </td><td> 进度 </td><td> 备注<sup>Changeset , Issue 相关链接...</sup> </td></tr></tbody></table>

<b>除了服务器的开发任务外，欢迎大家编写指挥程序，和现有的部队进行对战</b>