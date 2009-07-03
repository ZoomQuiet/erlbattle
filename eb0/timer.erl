-module(timer).
-export([timer/3,getTime/0]).

%% Todo: Sleep С����,��Ϣ���ɺ���
timer(Pid, 0, Sleep) ->
	%% ��һ����������ʼ��battle_timer��
	ets:new(battle_timer, [set, protected, named_table]),
	ets:insert(battle_timer, {clock, 0}),
	timer(Pid, Sleep).

timer(Pid, Sleep) -> 
	tools:sleep(Sleep),
	
	%% ս��������еĴ��� 
	MaxTurn = 5,

	%% ����clockֵ
	Time = ets:update_counter(battle_timer, clock, 1),

	if    
		Time == MaxTurn ->
			Pid!{self(), finish};
		Time < MaxTurn ->
			Pid !{self(), time, Time},
			timer(Pid, Sleep)
	end.

%% ȡʱ�亯��
getTime() ->
	case ets:lookup(battle_timer, clock) of
		[{clock, Time}] ->
			Time;
		_ -> 
			0
	end.
