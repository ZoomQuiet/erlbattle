-module(erlbattle).
-export([start/0,takeAction/1]).
-include("schema.hrl").
-include("test.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% ս����ʼ����������
start() ->
    io:format("Server Starting ....~n", []),
	
    %% �����������ӵĳ�ʼ״̬
	io:format("Army matching into the battle fileds....~n", []),
	battlefield:create(),
	
	%%  TODO: �����Ҫ�Ǻ���������ÿ̨�������ܹ�����ͬ�Ľ�����е�����
	%%  io:format("Testing Computer Speed....~n", [])
	Sleep = 10,

	%% ����һ����ʱ��, ��Ϊս������
	Timer = spawn(worldclock, start, [self(),0,Sleep]),

	%% ��������ָ����У� ����������ֻ���ɸ��Կ���
	BlueQueue = ets:new(blueQueue, [{keypos, #command.warrior_id}]),
	RedQueue = ets:new(redQueue, [{keypos, #command.warrior_id}]),
	
	%% �����췽�������ľ��߳���
	%% TODO:  Ϊ�˱���ĳһ��ͨ������Ϣ��Ӱ��Է��� δ��Ҫ�ж�����ͨѶ������ÿ������Ϣ
	io:format("Command Please, Generel....~n", []),
	BlueSide = spawn(feardFarmers, start, [self(), "Blue"]),
	RedSide = spawn(englandArmy, start, [self(), "Red"]),
	

	%% ��ʼս��ѭ��
	run(Timer, BlueSide, RedSide,BlueQueue, RedQueue).
		

%% ս���߼�������
run(Timer, BlueSide, RedSide, BlueQueue, RedQueue) ->
	receive 
		
		{Timer, finish} ->
				BlueSide!finish,
				RedSide!finish,
				io:format("Sun goes down, battle finished!~n", []),
				%% ���ս�����
				io:format("The winner is blue army ....~n", []),
				ets:delete(battle_field);		
				
		{Timer, time, Time} ->
				%% TODO ս���߼�
				%% do something
				io:format("Time: ~p s ....~n", [Time]),
				
				%% ����������Ч�Ķ���
				takeAction(Time),
				
				%% �Ӷ����õ�����wait ״̬��սʿ���µĶ�����������ָ��Ӷ�����ɾ��
				%% do something
				
				%% �ȴ���һ������
				run(Timer, BlueSide, RedSide,BlueQueue, RedQueue);

		{Side, command,Command,Warrior,Time} ->
				%% ����һ��command ��¼
				CmdRec = #command{
						warrior_id = Warrior,
						command_name = Command,
						execute_time = Time},
				case Side of
					%% ��������������
					BlueSide ->
						io:format("BlueSide: warrior ~p want ~p at ~p ~n", [Warrior, Command, Time]),
						ets:insert(BlueQueue, CmdRec),
						?debug_print(true, ets:tab2list(BlueQueue));
					%% �췽����������
					RedSide ->
						io:format("RedSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
						ets:insert(RedQueue, CmdRec),
						?debug_print(true, ets:tab2list(RedQueue));
					%% ��֪������һ������������
					_ ->
						io:format("UnknowSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time])
				end,
				run(Timer, BlueSide, RedSide,BlueQueue, RedQueue)
	end.

	
%% ���㵱ǰ���ģ�������Ҫ��Ч�Ķ���
takeAction(Time) ->
	
	%% ���ȴ�ս��״̬����ȡ����������Ч�Ķ�����ȡ����һ����ʼ����
	case getActingWorriar(Time) of
	
		[Worriar] ->
			
			%% ����Worria �Ķ��������������������˱�ɱ���ͽ����˴�����������
			act(Worriar),
			
			%% �ٶ���һ����Ҫִ�е�սʿ			
			takeAction(Time);
		_ ->
			none
	end.
			
	
	
%% ִ��һ��սʿ�Ķ���
act(WorriarInfo) ->

    %% forward, ���� back, 
	%% ת�� turnSouth, turnNorth, turnWest,turnEast
	%% ���� attack
	%% ԭ�ش��� wait 
	
	{_, _, _, Action} = WorriarInfo,
	
	if 		
		Action == "forward"  -> actMove(WorriarInfo, 1);
		Action == "back" -> actMove(WorriarInfo, -1);
		Action == "turnSouth" ->actTurn(WorriarInfo,"south");
		Action == "turnWest" ->actTurn(WorriarInfo,"west");
		Action == "turnEast" ->actTurn(WorriarInfo,"east");
		Action == "turnNorth" ->actTurn(WorriarInfo,"north");
		Action == "attack" -> actAttack(WorriarInfo);
		true -> none
	end.
	
	
%% ���һ����ǰ������Ҫִ�������սʿ��Ϣ
getActingWorriar(Time) ->

	%% TODO: ����sequence ȡ���Լ������ѡ�췽������˭�ȶ�
	%% ȡ����wait ״̬���Ҷ�����Чʱ�� С�ڵ��ڵ�ǰʱ��� һ��սʿ
	MS = ets:fun2ms(fun({Soldier, Id, Position,Hp,Facing,Action,Act_effect_time,Act_sequence}) 
			when (Action /= "wait" andalso Act_effect_time =< Time)  ->  
							{Id,Position,Facing,Action} end),
	
	try ets:select(battle_field,MS,1) of
		{ActingSoldier, _Other} ->
			ActingSoldier;
		_->
			none
	catch
		_:_ -> none
	end.

%%ת����, ���ܱ���Ӱ��
actTurn(WorriarInfo,Direction) ->
	{Id, _Position, _Facting, _Action} = WorriarInfo,
	ets:update_element(battle_field, Id, [{6, "wait"},{4, Direction}]).

%% �ƶ���������Ҫ��Ŀ������Ƿ��ж���
%% 1 ��ǰ�ߣ� -1 �����	
actMove(WorriarInfo, Direction) ->
	
	{Id, Position, Facing, _Action} = WorriarInfo,
	
	DestPosition = calcDestination(Position, Facing, Direction),
	
	%% ���Ŀ��λ���ǺϷ��ģ����ƶ�������ͷ����ö���,ԭ�ز���
	case positionValid(DestPosition) of
		true ->
			ets:update_element(battle_field, Id, [{6, "wait"},{3, DestPosition}]);
		_ ->
			ets:update_element(battle_field, Id, [{6, "wait"}])
	end.

%%����Ŀ���ƶ�λ��
calcDestination(Position, Facing, Direction) ->
	
	{Px, Py} = Position,
	
	if  
		Facing == "west" -> {Px - Direction, Py};
		Facing == "east" -> {Px + Direction, Py};
		Facing == "north" -> {Px, Py + Direction};
		Facing == "south" -> {Px, Py - Direction};
		true -> {Px,Py}
	end.

%% �ж��Ƿ����ںϷ���Ŀ�ĵ�
positionValid(Position)	->

	{Px, Py} = Position,
	
	%% 1. ��������
	%% 2. Ŀ�ĵ�����վ�ţ������ƶ�
	not ((Px <0 orelse Py < 0 orelse Px >14 orelse Py > 14) orelse
		battlefield:get_soldier_inbattle(Position) /= none).
		
	
%% ��������
actAttack(WorriarInfo) ->
	
	{ID, Position, Facing, _Action} = WorriarInfo,
	{_MyId, MySide} = ID,
	
	DestPosition = calcDestination(Position, Facing, 1),
	
	%% ����ڹ����������е��˵Ļ������㹥�����
	case battlefield:get_soldier_inbattle(DestPosition) of
		[Enemy] -> 
			{EID, _EPosition, EHp, _EFacing, _EAction, _EEffTime, _ESeq} = Enemy,	
			{_Eid, ESide} = EID,
			if 
				%% ֻ�ܹ������ˣ��Լ��˲��ܹ���
				MySide /= ESide ->
					case calcHit(WorriarInfo, Enemy) of
						%% ���hit ���� 0 ����ʾ�õ��˱�ɱ��
						Hit when Hit == 0 ->
							ets:match_delete(battle_field, {EID,'_'});
						%% Hit �����㣬�ۼ����Է���Ѫ
						Hit when Hit > 0 ->
							ets:update_element(battle_field, EID, [{3, EHp - hit}])
					end
			end;
		_ ->
			true
	end,
	
	%% ���Լ��Ķ�������
	ets:update_element(battle_field, ID, [{5, "wait"}]).
	
	
%% ���㹥������
calcHit(WorriarInfo, Enemy) ->
	
	{_EId, EPosition, EHp, EFacing, _EAction, _EEffTime, _ESeq} = Enemy,	
	{_Id, Position, _Facing, _Action} = WorriarInfo,
	
	%% ���������Ե��Ǹ񣬺ͱ�����Ǹ������Ķ��ǲ���
	FacePosition = calcDestination(EPosition,EFacing,1),
	BackPosition = calcDestination(EPosition,EFacing,-1),	

	%% ��������˱���
	case Position of 
		FacePosition -> Hit = 10;
		BackPosition -> Hit = 20;
		_ -> Hit = 15
	end,
	
	%% �������hp �������ͷ����㣬��ʾɱ����
	%% ���򷵻ع�������
	if
		EHp > Hit -> Hit;
		true -> 0
	end.
			
	
	
	
