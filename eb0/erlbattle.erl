-module(erlbattle).
-export([start/0,takeAction/1,getTime/0]).
-include("schema.hrl").
-include("test.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% ս����ʼ����������
start() ->
    
	io:format("Battle Begin ....~n", []),
	
	%% ���Ҫ�������ֵĻ����޸�����
	BlueArmy = feardFarmers,
	RedArmy = englandArmy,

	%%  TODO: �����Ҫ�Ǻ���������ÿ̨�������ܹ�����ͬ�Ľ�����е�����
	Sleep = 1000,
	
	%% ����һ��ս��ʱ�ӱ�����Ϊ��
	ets:new(battle_timer, [set, protected, named_table]),
	ets:insert(battle_timer, {clock, 0}),
	
    %% �����������ӵĳ�ʼ״̬
	io:format("Army matching into the battle fileds....~n", []),
	battlefield:create(),

	%% ����ͨѶ����
	BlueQueue = ets:new(blueQueue, [{keypos, #command.soldier_id}]),	
	RedQueue = ets:new(blueQueue, [{keypos, #command.soldier_id}]),	
	
	%% �����췽��������ͨѶͨ��
	BlueSide = spawn(channel, start, [self(), "blue",BlueArmy]),
	RedSide = spawn(channel, start, [self(), "red", RedArmy]),
	
	%% ��ͨѶ���еĹ���Ȩ����ͨѶͨ��
	ets:give_away(BlueQueue, BlueSide, none),
	ets:give_away(RedQueue, RedSide,none),
	
	%% ��ʼս��
	loop(BlueSide, RedSide,BlueQueue, RedQueue, Sleep).

%% ս���߼�������
loop(BlueSide, RedSide, BlueQueue, RedQueue, Sleep) ->

	%% ս��������еĴ��� 
	MaxTurn = 5,

	%%��õ�ǰʱ�ӣ� ս���� ��һ�� ��ʼ
	Time = ets:update_counter(battle_timer, clock, 1),

	%% ˯һ�ᣬ��ָ�ӳ�����Կ���
	tools:sleep(Sleep),
	
	%% ����������Ч�Ķ���
	takeAction(Time),

	%% ����Ƿ�������һ���Ѿ�ȫ������
	case checkWinner() of

		%% ʤ���ѷ�
		{winner, Winner} ->
			io:format("~p army kills all the enemy, they win !! ~n", [Winner]);
	
		%% ʤ��δ��
		none -> 
			
			%% �ж��Ƿ񳬹���ս������ִ�
			if	
				Time == MaxTurn ->

					%% ����ʤ��
					io:format("Sun goes down, battle finished!~n", []),

					%% ���ս�����
					io:format("~p army win the battle!! ~n", [calcWinner()]),
					
					%% �˳�����
					cleanUp(BlueSide,RedSide);
					
				
				%% ��ʼ��һ�ֵ�����					
				true ->

					%% ȡ�췽����wait ״̬��սʿ���µĶ�����ִ�У�������ָ��Ӷ�����ɾ��
					RedIdleSoldiers = battlefield:get_idle_soldier("Red"),
					RedUsedCommand = command(RedIdleSoldiers,RedQueue,Time),
					RedSide ! {expireCommand, RedUsedCommand},
					
					%% ȡ��������wait ״̬��սʿ���µĶ�����ִ�У�������ָ��Ӷ�����ɾ��					
					BlueIdleSoldiers = battlefield:get_idle_soldier("Blue"),
					BlueUsedCommand = command(BlueIdleSoldiers,BlueQueue,Time),
					BlueSide ! {expireCommand, BlueUsedCommand},

					%% ��һ��ս��
					loop(BlueSide, RedSide, BlueQueue, RedQueue, Sleep)
			end
	end.

%% ���ڴ���wait ״̬��սʿ��ȡ����һ��ָ�����еĻ�������ִ��֮
command([],_Queue,_Time) -> [];
command([Soldier, T], Queue,Time) ->
	
	%% Ѱ�ҵ�ǰսʿ��ָ��, ��ִ��֮
	case getNextCommand(Soldier,Queue) of

		%% �ҵ�ָ��
		{command, Command} ->
			
			%% ����սʿ����
			NewSoldier = Soldier#soldier{action = Command#command.name, act_effect_time = Time + calcActionTime(Command#command.name)},
			ets:insert(battle_field, NewSoldier),
			
			%% ��¼ָ�����
			ID = [Command#command.seq_id];
		
		%% û�ҵ�ָ��
		_ ->
			ID = []
	end,
	ID ++ command(T,Queue,Time).
	

%% ���һ��սʿ��һ���Ķ���ָ��	
getNextCommand(Soldier,Queue) ->
    
	%% ��ȡSoldier �ţ�Queue�����Ƿֿ��ģ�����ҪSide ���
	{SoldierId, _Side} = Soldier#soldier.id,
	Pattern=#command{
		soldier_id = SoldierId,
		name = '_',
		execute_time = '_',
		seq_id = '_'},
	Command = ets:match_object(Queue, Pattern),
	if
		length(Command) == 0 -> none;
		true ->
			[C, _T] = Command,
			C
	end.

%% ���岻ͬ������Ч��ʱ��
calcActionTime(Action) ->

	if
		Action == "forward"  -> 2;
		Action == "back" -> 4;
		Action == "turnSouth" -> 1;
		Action == "turnWest" -> 1;
		Action == "turnEast" -> 1;
		Action == "turnNorth" -> 1;
		Action == "attack" -> 2;
		true -> 0
	end.
	
%% ���㵱ǰ���ģ�������Ҫ��Ч�Ķ���
takeAction(Time) ->
	
	%% ���ȴ�ս��״̬����ȡ����������Ч�Ķ�����ȡ����һ����ʼ����
	case getActingSoldier(Time) of
	
		[Soldier] ->
			
			%% ����Worria �Ķ��������������������˱�ɱ���ͽ����˴�����������
			act(Soldier),
			
			%% �ٶ���һ����Ҫִ�е�սʿ			
			takeAction(Time);
		_ ->
			none
	end.
			
	
	
%% ִ��һ��սʿ�Ķ���
act(SoldierInfo) ->

    %% forward, ���� back, 
	%% ת�� turnSouth, turnNorth, turnWest,turnEast
	%% ���� attack
	%% ԭ�ش��� wait 
	
	{_, _, _, Action} = SoldierInfo,
	
	if 		
		Action == "forward"  -> actMove(SoldierInfo, 1);
		Action == "back" -> actMove(SoldierInfo, -1);
		Action == "turnSouth" ->actTurn(SoldierInfo,"south");
		Action == "turnWest" ->actTurn(SoldierInfo,"west");
		Action == "turnEast" ->actTurn(SoldierInfo,"east");
		Action == "turnNorth" ->actTurn(SoldierInfo,"north");
		Action == "attack" -> actAttack(SoldierInfo);
		true -> none
	end.
	
	
%% ���һ����ǰ������Ҫִ�������սʿ��Ϣ
getActingSoldier(Time) ->

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
actTurn(SoldierInfo,Direction) ->
	{Id, _Position, _Facting, _Action} = SoldierInfo,
	ets:update_element(battle_field, Id, [{6, "wait"},{5, Direction}]).

%% �ƶ���������Ҫ��Ŀ������Ƿ��ж���
%% 1 ��ǰ�ߣ� -1 �����	
actMove(SoldierInfo, Direction) ->
	
	{Id, Position, Facing, _Action} = SoldierInfo,
	
	DestPosition = calcDestination(Position, Facing, Direction),
	
	%% ���Ŀ��λ���ǺϷ��ģ����ƶ�������ͷ����ö���,ԭ�ز���
	Valid = positionValid(DestPosition),
		
	if 		
		Valid == true ->  
			ets:update_element(battle_field, Id, [{6, "wait"},{3, DestPosition}]);
		true ->
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
	%% 2. Ŀ�ĵز���������
	(Px >=0) and (Py>=0) and (Px =<14) and (Py =<14) and  
		(battlefield:get_soldier_by_position(Position) ==none).
	
%% ��������
actAttack(SoldierInfo) ->
	
	{ID, Position, Facing, _Action} = SoldierInfo,
	{_MyId, MySide} = ID,
	
	DestPosition = calcDestination(Position, Facing, 1),

	case battlefield:get_soldier_by_position(DestPosition) of 
		
		Enemy when is_record(Enemy,soldier) -> 

			{_Key, EID, _EPosition, EHp, _EFacing, _EAction, _EEffTime, _ESeq} = Enemy,
			{_Eid, ESide} = EID,

			if 
				%% ֻ�ܹ������ˣ��Լ��˲��ܹ���
				MySide /= ESide ->
					case calcHit(SoldierInfo, Enemy) of
						%% ���hit ���� 0 ����ʾ�õ��˱�ɱ��
						Hit when Hit == 0 ->
							ets:match_delete(battle_field, Enemy);
						%% Hit �����㣬�ۼ����Է���Ѫ
						Hit when Hit > 0 ->
							ets:update_element(battle_field, EID, [{4, EHp - Hit}])
					end;
				true -> true
			end;	
		_ -> 
			none
	end,

	
	%% ���Լ��Ķ�������
	ets:update_element(battle_field, ID, [{6, "wait"}]).
	
	
%% ���㹥������
calcHit(SoldierInfo, EnemyInfo) ->
	
	{_Key, _EId, EPosition, EHp, EFacing, _EAction, _EEffTime, _ESeq} = EnemyInfo,	
	{_Id, Position, _Facing, _Action} = SoldierInfo,
	
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
			
%% ȡʱ�亯��
getTime() ->
	
	try ets:lookup(battle_timer, clock) of
	
		[{clock, Time}] ->
			Time;
		_ -> 0		
	catch
		_:_ -> -1			
	end.
	
%% TODO ʵ��ս����Ӯ�ж�
%% �ȿ�ʣ�������� Ȼ���ۼ�Ѫ���������һ������Ϊƽ��
calcWinner() ->
	
	RedArmy = battlefield:get_soldier_by_side("Red"),
	BlueArmy = battlefield:get_soldier_by_side("Blue"),
	
	RedCount = length(RedArmy),
	BlueCount = length(BlueArmy),
	
	if 
		RedCount == BlueCount ->
			%% �Ƚ�Ѫ��
			RedBlood = calcBlood(RedArmy),
			BlueBlood = calcBlood(BlueArmy),
			if 
				RedBlood > BlueBlood ->
					{winner, "Red"};
				RedBlood < BlueBlood ->
					{winner, "Blue"};
				true ->
					none
			end;
		RedCount < BlueCount ->
			{winner, "Blue"};
		true ->
			{winner, "Red"}
	end.

%% ���ս���Ƿ��Ѿ�����
checkWinner() ->

	case battlefield:get_soldier_by_side("red") of 
		[] ->
			{winner,"blue"};
		_ ->
			case battlefield:get_soldier_by_side("blue") of
				[] ->
					{winer, "red"};
				_ ->
					none
			end
	end.
		

%% ����һ���������Ѫ��
calcBlood([]) -> 0;
calcBlood([Soldier | T]) ->
	Soldier#soldier.hp + calcBlood(T).
	
%% �˳�ǰ��������
cleanUp(BlueSide, RedSide) ->

	io:format("begin to clean the battle field ~n",[]),	
	exit(RedSide, normal),
	exit(BlueSide, normal),
	
	%% ���������̶�������Ȼ��ʼ������
	tools:sleep(5000),
	ets:delete(battle_field),
	ets:delete(battle_timer).
