-module(feardFarmers).
-export([run/2]).

%% ����һ����򵥵�����
%% ũ�����ŵĳ���������ʲôս��ָ�û�з���ȥ��ԭ�ز������ű�����ɱ
run(Channel, Side) ->
	
	io:format("don't kill us , we are poor farmers ~n",[]),
	
	tools:sleep(1000),
	
	run(Channel,Side).
	