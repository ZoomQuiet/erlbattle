-module(englandArmy).
-export([start/2]).

start(BattleField, Side) ->
    
	io:format("englandArmy begin to run on ~p army....~n", [Side]),
	run(BattleField,Side).
	
run(BattleField, Side) ->
	
	BattleField!{command,"forward",1,0},
	BattleField!{command,"forward",2,0},
	BattleField!{command,"forward",3,0},
	BattleField!{command,"forward",4,0},
	BattleField!{command,"forward",5,0},
	BattleField!{command,"forward",6,0},
	BattleField!{command,"forward",7,0},
	BattleField!{command,"forward",8,0},
	BattleField!{command,"forward",9,0},
	BattleField!{command,"forward",10,0},
	
	receive
		finish ->  % �˳���Ϣ���Ա����������ܹ�����ս��
			BattleField!{command, Side ++ " Side: finish battle"}
	after 1 -> 
			run(BattleField, Side)
	end.
	