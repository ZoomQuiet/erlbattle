= EB:����Ŀ¼ʹ��˵�� =

����:
�汾:
    090801 houmingyuan ����;ZoomQuiet ��ʽ����


== Ŀ¼Լ�� ==
/ (http://erlbattle.googlecode.com/svn/trunk/)
����doc             �ĵ�Ŀ¼
��  ����docpicture
��  ����kongfu
��  ����logo
+--core             �������
|  +-engine         ����Ŀ¼|
����army             ս�Ӵ���Ŀ¼; ����erlangԴ�����Makefile֮�⣬��Ҫ���������κ��ļ�
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


== ����EB ==
��Ҫ: erl-otp_R11B-5 ���ϣ� ���ص�ַ[http://www.erlang.org/download.html]

@Windows
����: nmake, ���ص�ַ[http://erlbattle.googlecode.com/files/nmake.exe]
ִ��������������
D:\erlbattle>configure
D:\erlbattle>nmake
����ִ����������
>make.bat

@Linux
����:gnu make (һ�㶼�Դ�0\)
#./configure
#make.sh

���������,������ֱ��:
   erl -nologo -noshell -pz ebin -s erlbattle start

=== ��erl shell �� ===
# ����erl
>erl

# ����ebin·��
    .beam�ļ���Ҳ����erlang����������������ֽ���
    ebinĿ¼������������Щbeam�ļ�
    Ҫ������Щ�ļ�����erl��Ҫ��֪����Щ�ļ�����
    ������erl������ʹ��
1>code:add_pathz("ebin").
    �������ǵĴ��루.��erlang���Ľ�����������.
    ����Ƿ�ɹ�׷��·��:
    ��erl��������������
2>code:get_path().
    ���Կ�����ǰϵͳ�����صĴ���Ŀ¼.
    ���̫����[..|..] �Ľ�β����˵��û�ж���ʾ�������Ϳ�����:
3>io:format("~p", [code:get_path()]).
    ��ȫչʾ.

# ����erlbattle
3>erlbattle:start().
    ս�����ֱ����� , ��ͬʱ������warfield.txt

# �ۿ����(windows)
3>os:cmd("copy warfield.txt _fla").
4>os:cmd("_fla\\Index.html").


= others =
������ϸ������ָ��[http://code.google.com/p/erlbattle/wiki/EbStepByStep]


