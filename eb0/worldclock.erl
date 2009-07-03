-module(worldclock).
-include("schema.hrl").
-export([start/3,getTime/0]).

%% Todo: Sleep С����,��Ϣ���ɺ���
start(Pid,0,Sleep) ->
	%% ��һ����������ʼ��battle_timer��
	ets:new(battle_timer, [set, protected, named_table]),
	ets:insert(battle_timer, {clock, 0}),
	loop(Pid, Sleep).

loop(Pid, Sleep) -> 
	tools:sleep(Sleep),
	
	%% ս��������еĴ��� 
	MaxTurn = 5,

	%% ����clockֵ
	Time = ets:update_counter(battle_timer, clock, 1),
	
	if    
		Time == MaxTurn ->
			Pid!{self(), finish},
			ets:delete(battle_timer);
		Time < MaxTurn ->
			Pid !{self(), time, Time},
			loop(Pid, Sleep)
	end.

%% ȡʱ�亯��
getTime() ->
	case ets:lookup(battle_timer, clock) of
		[{clock, Time}] ->
			Time;
		_ -> 
			0
	end.
