-module(feardFarmers).
-export([start/2]).

start(BattleField, Side) ->
    
	io:format("FeardFarmers begin to run on ~p army....~n", [Side]),
	run(BattleField,Side).
	
run(BattleField, Side) ->
	
	io:format("don't kill us , we are poor farmers ~n",[]),
	
	receive
		finish ->  % �˳���Ϣ���Ա����������ܹ�����ս��
			BattleField!{command, Side ++ " Side: finish battle"}
	after 1 -> 
			run(BattleField, Side)
	end.
	