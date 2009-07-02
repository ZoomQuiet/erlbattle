-module(battlefield).
-author("swingbach@gmail.com").
-export([create/0,get_soldier/2,get_soldier_inbattle/1,test/0]).

-define(error1(Expr, Expected, Actual),
	io:format("~s is ~w instead of ~w at ~w:~w~n",
		  [??Expr, Actual, Expected, ?MODULE, ?LINE])).

-define(match(Expected, Expr),
        fun() ->
		Actual = (catch (Expr)),
		case Actual of
		    Expected ->
			{success, Actual};
		    _ ->
			?error1(Expr, Expected, Actual),
			erlang:error("match failed", Actual)
		end
	end()).

-record(soldier,{
		%%սʿ���, tuple��ʽ{���,����ս��}
		id, 
		%%λ��
		position,
		%%Ѫ��
		hp,
		%%�泯����
		direction,
		%%��ǰ����,
		action,
		%%������Чʱ��
		act_effect_time,
		%%�ж�����(Ŀǰδ���������)
	    act_sequenc e	
	}).


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
				direction=Direction,
				%%TODO action�Լ�direction�ĳ�����ö������
				action="wait"
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
				direction='_',
				action='_'
			},
	case ets:match_object(battle_field,Pattern) of
		[Soldier] ->
			Soldier;
		[]->
			none
	end.

%%���Ը���ID����սʿ����
test10()->
	%%ս�Ӵ���
	?match(none,get_soldier(1,"sdf")),
	%%�ɹ�ȡ����Ϣ
	Soldier=#soldier{
				id={2,"red"},
				position={0,2+2},
				hp=100,
				direction="E",
				action="wait"
			},
	?match(Soldier,get_soldier(2,"red")).

%%���Ը�������λ�ò���սʿ����
test20()->
	?match(none,get_soldier_inbattle({1,14})),
	?match(none,get_soldier_inbattle({14,0})),
	Soldier=#soldier{
			id={7,"blue"},
			position={14,9},
			hp=100,
			direction="W",
			action="wait"
		},
	?match(Soldier,get_soldier_inbattle({14,9})).

test()->
	create(),
	test10(),
	test20().


