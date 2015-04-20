最快的开始...<sup>假设你已经安装了erl 环境，并且会用svn, 使用M$ 或者 linux 环境</sup>

### 首次战斗体验 ###
  1. [播放器和战斗录像下载](http://erlbattle.googlecode.com/files/war-2.zip)<sup>内有readme.txt</sup>
  1. 观看录像，获得饿狼战役战斗的直观感觉

### 开始安装和编译 ###
  1. 按装 erl v5.7.2(R13B1)
  1. 用svn下载代码到你的机器上。 http://erlbattle.googlecode.com/svn/trunk
  1. 在/erlbattle 目录下， 进入Erlang shell
  1. 编译代码: `make:all([load]).`
  1. 启动游戏: `erlbattle:start().`
  1. 系统就启动了. 并且在你反应过来之前就结束了。
  1. 这是你观看的第一场战斗，发生在feardFarmers【恐惧的农民】 和englandArmy【英格兰卫兵】 之间的战斗。
  1. 把输出的 warfield.txt用第一步下载的播放器播放这个战斗
  1. 尝试运行 erlbattle:start(englandArmy,englandArmy)  让两个【英格兰卫兵】比赛
  1. 把输出的 warfield.txt用第一步下载的播放器播放这个战斗

### 开始深入学习 ###
  1. 阅读战场程序代码，或者动手编写你的第一个指挥程序
    * [EB:接口定义](EbInterface.md)**<sup>玩家指挥程序编写指南</sup>**

> 。。。。enjoy it.