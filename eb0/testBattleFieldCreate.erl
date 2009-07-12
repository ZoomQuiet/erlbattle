-module(testBattleFieldCreate).
-export([test/0]).
-include("test.hrl").
-include("schema.hrl").

%% ����
test()->
	battlefield:create(),
	test10(),
	test20(),
	ets:delete(battle_field).
	
%%���Ը���ID����սʿ����
test10()->
	%%ս�Ӵ���
	?match(none,battlefield:get_soldier(1,"sdf")),
	%%�ɹ�ȡ����Ϣ
	Soldier=#soldier{
				id={2,"red"},
				position={0,2+2},
				hp=100,
				facing="east",
				action="wait",
				act_effect_time=0,
				act_sequence=0
			},
	?match(Soldier,battlefield:get_soldier(2,"red")).

%%���Ը�������λ�ò���սʿ����
test20()->
	?match(none,battlefield:get_soldier_by_position({1,14})),
	?match(none,battlefield:get_soldier_by_position({14,0})),
	Soldier=#soldier{
			id={7,"blue"},
			position={14,9},
			hp=100,
			facing="west",
			action="wait",
			act_effect_time=0,
			act_sequence=0
			},
	?match(Soldier,battlefield:get_soldier_by_position({14,9})).

