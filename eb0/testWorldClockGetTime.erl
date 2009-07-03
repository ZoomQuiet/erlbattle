-module(testWorldClockGetTime).
-export([test/0]).

%% ����getTime()
test() ->
	test1(),
	test2(),
	test3().
	
%% �������
test1() ->
	ets:new(battle_timer, [set, protected, named_table]),
	ets:insert(battle_timer, {clock, 23}),
	case worldclock:getTime() of 
		23 ->
			true;
		_ ->
			erlang:error("time not correct")
	end,
	ets:delete(battle_timer).

%% �ձ��� 0	
test2() ->
	ets:new(battle_timer, [set, protected, named_table]),
	case worldclock:getTime() of 
		0 ->
			true;
		_ ->
			erlang:error("time2 not correct")
	end,
	ets:delete(battle_timer).

%% û�б��ʱ�򷵻� -1	
test3() ->
	case worldclock:getTime() of 
		-1 ->
			true;
		_ ->
			erlang:error("time3 not correct")
	end.
