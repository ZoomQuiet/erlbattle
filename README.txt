1 Ŀ¼˵��
root
����doc             �ĵ�Ŀ¼
��  ����docpicture
��  ����kongfu
��  ����logo
+--core
|  +-engine       ����Ŀ¼
|
����army             Դ����Ŀ¼������erlangԴ�����Makefile֮�⣬��Ҫ���������κ��ļ�
��  ����evan.tao     �����Ǹ���AIĿ¼�������Ҫ�½���AI����һ��Ŀ¼��дһ��Makefile
��  ����example_army
��  ����hwh
��  ����laofan
��  ����maddog
��  ����neoedmund
����ebin            beam���Ŀ¼
����make            Makefile��ؽű�
����priv            erlang�����ļ��Լ���һЩ�����нű�
����_fla            flash��ʾ����

2 ����
��Ҫ: erl-otpR12B-5�� ���ص�ַ[http://www.erlang.org/download.html]

2.1 Windows
��Ҫ: nmake, ���ص�ַ[http://erlbattle.googlecode.com/files/nmake.exe]
ִ��������������
D:\erlbattle>configure
D:\erlbattle>nmake

2.2 Linux
��Ҫgnumake
#./configure
#make 

3 ����
3.0 ���������
   erl -nologo -noshell -pz ebin -s erlbattle start
3.1 ����erl
>erl

3.2 ����ebin·��
.beam�ļ���Ҳ����erlang����������������ֽ���
ebinĿ¼������������Щbeam�ļ�
Ҫ������Щ�ļ�����erl��Ҫ��֪����Щ�ļ�����
������erl������ʹ��
1>code:add_pathz("ebin").
�������ǵĴ��루.��erlang���Ľ�����������.

��erl��������������code:getpath().���Կ�����ǰϵͳ�����صĴ���Ŀ¼.

3.3 ����erlbattle
2>erlbattle:start().
ս������򱣴���warfield.txt

3.4 �ۿ����(windows)
3>os:cmd("copy warfield.txt _fla").
4>os:cmd("_fla\\Index.html").

������ϸ������ָ��[http://code.google.com/p/erlbattle/wiki/EbStepByStep]


