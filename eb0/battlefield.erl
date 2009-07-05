-module(battlefield).
-author("swingbach@gmail.com").
-export([create/0,get_soldier/2,get_soldier_inbattle/1]).
-include("schema.hrl").

create() ->
	%%����ս����Ϣ�����ڲ���սʿ��Ϣ����ĳ�������Ϣ
	ets:new(battle_field,[named_table,protected,{keypos,#soldier.id}]),
    %%��ʼ��ʿ����λ��
	init_soldier("red",0,2,"E"),
	init_soldier("blue",14,2,"W").

init_soldier(Army,X,Y,Direction)->
	Soldiers=[1,2,3,4,5,6,7,8,9,10],
	lists:foreach(
		fun(Id) ->
			Soldier=#soldier{
				id={Id,Army},
				position={X,Y+Id},
				hp=100,
				facing = Direction,
				%%TODO action�Լ�direction�ĳ�����ö������
				action="wait",
				act_effect_time = 0,
				act_sequence =0
			},
			ets:insert(battle_field,Soldier)
		end,
		Soldiers).

%%����սʿ��ż�ս�ӵõ���սʿ��Ϣ
get_soldier(Id,Side) ->
	case ets:lookup(battle_field,{Id,Side}) of
		[Soldier] ->
			Soldier;
		[]->
			none
	end.

%%�õ�ĳ���������սʿȫ����Ϣ
get_soldier_inbattle(Position) ->
	Pattern=#soldier{
				id='_',
				position=Position,
				hp='_',
				facing='_',
				action='_'
			},
	case ets:match_object(battle_field,Pattern) of
		[Soldier] ->
			Soldier;
		[]->
			none
	end.




