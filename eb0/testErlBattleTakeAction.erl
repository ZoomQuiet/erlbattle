-module(testErlBattleTakeAction).
-export([test/0]).
-include("test.hrl").
-include("schema.hrl").

%% ����getTime()
test() ->
	ets:new(battle_field,[named_table,protected,{keypos,#soldier.id}]),
	
	test1(), % ��ǰһ��
	test2(), % ���һ��
	test3(), % ���˲�����
	test4(), % �����߿�����
	test5(), % ת�����
	test6(), % ���湥������
	test7(), % ���󹥻�����
	test8(), % ���湥������
	test9(), % û��,��������
	test10(), % ����һ��,��������
	test11(), % ���������Լ���
	
	ets:delete(battle_field).

%% ������ǰ��һ��
test1() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "west",
				action="forward",
				act_effect_time = 10,
				act_sequence =0
			},
	ets:insert(battle_field,Soldier),
	erlbattle:takeAction(10),
	Soldier2 = Soldier#soldier{position={9,10},action="wait"},
	Soldier3 = battlefield:get_soldier(10,"red"),
	?match(Soldier2,Soldier3).
	
%% ���������һ��
test2() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="back",
				act_effect_time = 10,
				act_sequence =0
			},
	ets:insert(battle_field,Soldier),
	erlbattle:takeAction(10),
	Soldier2 = Soldier#soldier{position={10,9},action="wait"},
	Soldier3 = battlefield:get_soldier(10,"red"),
	?match(Soldier2,Soldier3).	

%% �������˵�ס��ʱ������
test3() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="back",
				act_effect_time = 10,
				act_sequence =0
			},
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,9},action="wait"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3).	
	
%% ���Գ����߿�����
test4() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={14,8},
				hp=100,
				facing = "east",
				action="forward",
				act_effect_time = 10,
				act_sequence =0
			},
	ets:insert(battle_field,Soldier),
	erlbattle:takeAction(10),
	Soldier2 = battlefield:get_soldier(10,"red"),
	Soldier3 = Soldier#soldier{action="wait"},
	?match(Soldier2,Soldier3).	
	
%% ����ת��
test5() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "east",
				action="turnWest",
				act_effect_time = 10,
				act_sequence =0
			},
	ets:insert(battle_field,Soldier),
	erlbattle:takeAction(10),
	Soldier2 = battlefield:get_soldier(10,"red"),
	Soldier3 = Soldier#soldier{action="wait",facing="west"},
	?match(Soldier2,Soldier3).		
	
%% ���湥������
test6() ->	
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,11},action="wait",facing = "south"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	Soldier5 = battlefield:get_soldier(9,"blue"),
	Soldier6 = Soldier2#soldier{hp=90},
	?match(Soldier6,Soldier5).		

%% ���󹥻�����	
test7() ->
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,11},action="wait"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	Soldier5 = battlefield:get_soldier(9,"blue"),
	Soldier6 = Soldier2#soldier{hp=80},
	?match(Soldier6,Soldier5).	

%% ���湥������	
test8()->
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,11},action="wait",facing = "east"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	Soldier5 = battlefield:get_soldier(9,"blue"),
	Soldier6 = Soldier2#soldier{hp=85},
	?match(Soldier6,Soldier5).
	
%% û��,��������	
test9()->
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,12},action="wait",facing = "east"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	Soldier5 = battlefield:get_soldier(9,"blue"),
	Soldier6 = Soldier2#soldier{hp=100},
	?match(Soldier6,Soldier5).
	
%% ����һ��,��������	
test10()->
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"blue"},position={10,11},action="wait",facing = "east",hp=13},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	case battlefield:get_soldier(9,"blue") of 
		
		Enemy when is_record(Enemy,soldier) ->
			? match(Enemy, "not killed");
		none ->
			true;
		_ ->
			? match("get soldier result" , "unkown")
	end.
	
%% ���������Լ���
test11()->
	ets:delete_all_objects(battle_field),
	Soldier=#soldier{
				id={10,"red"},
				position={10,10},
				hp=100,
				facing = "north",
				action="attack",
				act_effect_time = 10,
				act_sequence =0
			},
	
	ets:insert(battle_field,Soldier),
	Soldier2 = Soldier#soldier{id={9,"red"},position={10,11},action="wait",facing = "south"},
	ets:insert(battle_field,Soldier2),
	
	erlbattle:takeAction(10),
	Soldier3 = battlefield:get_soldier(10,"red"),
	Soldier4 = Soldier#soldier{action="wait"},
	?match(Soldier4,Soldier3),

	Soldier5 = battlefield:get_soldier(9,"red"),
	?match(Soldier2,Soldier5).