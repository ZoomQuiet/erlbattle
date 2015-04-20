# Introduction #

Eb 使用Makefile来进行工程配置。这里简单介绍Makfile的原理，
以及EB是如何增加新模块。


**Makefile基本概念****target 是Makefile最基础要素，是目标，是Makefile要完成的工作，一个Makefile可能拥有很多target, 如compile, clean, rpm, install等等。
```
 #make compile
```
执行make命令是，可以加上target参数**

  1. 可以为target指定行为，下面例子中就是将clean行为指定为删除当前目录所有beam文件
```
clean:
     rm -rf *.beam
```
  1. 可以为target指定依赖关系,下面一句就是all这个target依赖于target compile和test
```
all: compile test
```
  1. 合起来的例子
```
test: test.o
   $(LINK) -o $@ $< $(LINK_FLAGS)
```
> 这个例子就是说：test依赖于test.o，如果test.o就绪之后，可以执行下面连接指令。

上面例子中$(LINK)形式的字符串，是Makefile中另外一个重要概念宏变量
```
LINK = g++
```
指定变量LINK值是g++，通过$(LINK)可以使用此变量。
Makefile中有一些是默认的宏变量
  1. @ target
  1. < 是第一个依赖

宏替换:
```
EBIN = ../ebin
MODULE = a b 
BEAMS = %MODULE(%=$(EBIN)/%.beam)
# 替换后的结果就是 ERL = ../ebin/a.beam ../ebin/b.beam
```
非常悲剧是Nmake不支持替换的过程使用宏所以在我们的target.mk.win里面有很dirty的方式替换的完成
```
TmpObjs0 = $(MODULES: =.beam )
TmpObjs1 = $(TmpObjs0).beam
TmpObjs2 = $(TmpObjs1: = ..\..\ebin\)
TARGETS = $(EBIN)\$(TmpObjs2)
```

宏替换加上target，就成为一个规则
```
$(EBIN)/%.beam: ./%.erl
	$(ERLC) $(ERL_COMPILE_FLAGS) -o$(EBIN) $<
```
所有EBIN目录下beam文件的生成规则。
nmake 有不同的语法来做同样的事情
```
.erl{$(EBIN)}.beam:
	erlc $(ERLC_FLAGS) -o $(EBIN) $<
```
# EB 中Makefile使用 #

在EB中，每个目录有单独的Makfile，这个Makefile有四个要素
  1. 指定EB\_TOP宏变量，即EB根目录，这一条要放在文件第一行
```
EB_TOP = ../
```
  1. 包含全局makefile模板，这一条放在文件最后
```
include ../make/target.mk
# 如果gnu make可以写为include $(EB_TOP)/make/target.mk
# 可是nmake不支持include里面使用宏变量
```
  1. 指定模块
```
MODULES = a b c 
```
  1. 指定子目录
```
SUBDIRS = dir1 dir2 dir3 
```

如果以make compile为例，make程序对此Makefile的执行过程是：
```
compile: $(TARGET_FILESS)	 	
	 $(SUBDIR_CMD)
```
compile依赖于$(TARGETS),先构建$(TARGET\_FILESS),在执行$(SBUDIR\_CMD)
```
EBIN = $(EB_TOP)ebin
TARGET_FILES= $(MODULES:%=$(EBIN)/%.beam)
```
上面的宏替换，TARGETS\_FILES最终替换结果为../ebin/a.beam ../ebin/b.beam
```
$(EBIN)/%.beam: ./%.erl
	$(ERLC) $(ERL_COMPILE_FLAGS) -o$(EBIN) $<
```
beam文件要依赖于上面规则
实际会执行下面指令

依赖完成之后，就会进行$(SUBDIR\_CMD)
windows用了for命令来进入每个子目录，并调用make
```
!IFDEF SUBDIRS
SUBDIR_CMD = for %%1 in ($(SUBDIRS)) do cd %%1 && $(MAKE) $@ && cd ..
!ENDIF
```
Linux使用shell脚本来递归子目录，这一段是来自于otp
```
SUBDIR_CMD = @set -e ; \
            for d in $(SUBDIRS); do                    \
            if test -f $$d/SKIP ; then                                  \
                echo "=== Skipping subdir $$d, reason:" ;               \
                cat $$d/SKIP ;                                          \
                echo "===" ;                                            \
            else                                                        \
                if test ! -d $$d ; then                                 \
                    echo "=== Skipping subdir $$d, it is missing" ;     \
                else                                                    \
                    xflag="" ;                                          \
                    if test -f $$d/ignore_config_record.inf; then       \
                        xflag=$$tflag ;                                 \
                    fi ;                                                \
                    (cd $$d && $(MAKE) $$xflag $@) || exit $$? ;        \
                fi ;                                                    \
            fi ;                                                        \
        done ;                                                          \
```


