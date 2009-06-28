-module(feardFarmers).
-export([start/2]).

start(BattleField, Side) ->
    
	io:format("~p begin to run on ~p army....~n", ["FeardFarmers", Side]),
	run(BattleField,Side).
	
run(BattleField, Side) ->
	
	BattleField!{command, Side ++ " Side: dont kill us, we are poor farmers"},

	receive
		finish ->  % �˳���Ϣ���Ա����������ܹ�����ս��
			BattleField!{command, Side ++ " Side: finish battle"}
	after 1 -> 
			run(BattleField, Side)
	end.
	