-module(erlbattle).
-export([start/0,takeAction/1,getTime/0,calcDestination/3]).
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
	Sleep = 300,
	
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
	BlueSide = spawn_link(channel, start, [self(), "blue",BlueArmy]),
	RedSide = spawn_link(channel, start, [self(), "red", RedArmy]),

	%% ����ս�������¼��,��ע��
	Recorder = spawn_link(battleRecorder,start, [self()]),
	register(recorder, Recorder),
	
	%% ��ͨѶ���еĹ���Ȩ����ͨѶͨ��
	ets:give_away(BlueQueue, BlueSide, none),
	ets:give_away(RedQueue, RedSide,none),
	tools:sleep(1000),
	
	%% ��ʼս��
	loop(BlueSide, RedSide,BlueQueue, RedQueue, Sleep).

%% ս���߼�������
loop(BlueSide, RedSide, BlueQueue, RedQueue, Sleep) ->

	%% ս��������еĴ��� 
	MaxTurn = 100,

	%%��õ�ǰʱ�ӣ� ս���� ��һ�� ��ʼ
	Time = ets:update_counter(battle_timer, clock, 1),
	io:format("~n~n~n--------------Time = ~p s --------------~n", [Time]),
	io:format("Battle Field Status Report ~n ~p ~n", [ets:tab2list(battle_field)]),

	%% ˯һ�ᣬ��ָ�ӳ�����Կ���
	tools:sleep(Sleep),
	
	%% ����������Ч�Ķ���
	takeAction(Time),

	%% ����Ƿ�������һ���Ѿ�ȫ������
	case checkWinner() of

		%% ʤ���ѷ�
		{winner, Winner} ->
			
			io:format("~p army kills all the enemy, they win !! ~n", [Winner]),
			
			%% ������
			record({result, Winner ++ " army kills all the enemy, they win !!"}),
			
			%% �˳�����
			cleanUp(BlueSide, RedSide);
	
		%% ʤ��δ��
		none -> 
			
			%% �ж��Ƿ񳬹���ս������ִ�
			if	
				Time == MaxTurn ->

					%% ����ʤ��
					io:format("Sun goes down, battle finished!~n", []),

					Winner = calcWinner(),
					
					%% ���ս�����
					io:format("~p army win the battle!! ~n", [Winner]),
					
					%% ���ս������ط���־
					if 
						Winner == none -> 
							record({result, "no army win the battle!!"});
						true ->
							record({result, Winner ++ " army win the battle!!"})
					end,
						
					
					%% �˳�����
					cleanUp(BlueSide,RedSide);
					
				
				%% ��ʼ��һ�ֵ�����					
				true ->

					%% ȡ�췽����wait ״̬��սʿ���µĶ�����ִ�У�������ָ��Ӷ�����ɾ��
					RedIdleSoldiers = battlefield:get_idle_soldier("red"),
					RedUsedCommand = command(RedIdleSoldiers,RedQueue,Time),
					RedSide ! {expireCommand, RedUsedCommand},
					
					%% ȡ��������wait ״̬��սʿ���µĶ�����ִ�У�������ָ��Ӷ�����ɾ��					
					BlueIdleSoldiers = battlefield:get_idle_soldier("blue"),
					BlueUsedCommand = command(BlueIdleSoldiers,BlueQueue,Time),
					BlueSide ! {expireCommand, BlueUsedCommand},

					%% �����ǰ����սʿ����һ���ƻ�
					recordPlan(Time),
					
					%% ��һ��ս��
					loop(BlueSide, RedSide, BlueQueue, RedQueue, Sleep)
			end
	end.

%% ���ڴ���wait ״̬��սʿ��ȡ����һ��ָ�����еĻ�������ִ��֮
command([],_Queue,_Time) -> [];
command([Soldier | T], Queue, Time) ->
	
	%% Ѱ�ҵ�ǰսʿ��ָ��, ��ִ��֮
	case getNextCommand(Soldier,Queue,Time) of

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
getNextCommand(Soldier,Queue,Time) ->
    
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
			[C | _T] = Command,
			if
				C#command.execute_time =< Time -> {command,	C};  %% ֻȡҪ�����ڻ���֮ǰִ�еĶ����� �Ժ�Ķ����Ȳ���
				true -> none
			end
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
	
		[SoldierInfo] ->
			
			%% ����Worria �Ķ��������������������˱�ɱ���ͽ����˴�����������
			act(SoldierInfo,Time),
			
			%% �ٶ���һ����Ҫִ�е�սʿ			
			takeAction(Time);
		_ ->
			none
	end.
			
	
	
%% ִ��һ��սʿ�Ķ���
act(SoldierInfo,Time) ->

    %% forward, ���� back, 
	%% ת�� turnSouth, turnNorth, turnWest,turnEast
	%% ���� attack
	%% ԭ�ش��� wait 
	
	{_Id, _Position, _Facing, Action,_Hp} = SoldierInfo,
	
	if 		
		Action == "forward"  -> actMove(SoldierInfo, 1,Time);
		Action == "back" -> actMove(SoldierInfo, -1,Time);
		Action == "turnSouth" ->actTurn(SoldierInfo,"south",Time);
		Action == "turnWest" ->actTurn(SoldierInfo,"west",Time);
		Action == "turnEast" ->actTurn(SoldierInfo,"east",Time);
		Action == "turnNorth" ->actTurn(SoldierInfo,"north",Time);
		Action == "attack" -> actAttack(SoldierInfo,Time);
		true -> none
	end.
	
	
%% ���һ����ǰ������Ҫִ�������սʿ��Ϣ
getActingSoldier(Time) ->

	%% TODO: ����sequence ȡ���Լ������ѡ�췽������˭�ȶ�
	%% ȡ����wait ״̬���Ҷ�����Чʱ�� С�ڵ��ڵ�ǰʱ��� һ��սʿ
	MS = ets:fun2ms(fun({Soldier, Id, Position,Hp,Facing,Action,Act_effect_time,Act_sequence}) 
			when (Action /= "wait" andalso Act_effect_time =< Time)  ->  
							{Id,Position,Facing,Action,Hp} end),
	
	try ets:select(battle_field,MS,1) of
		{SoldierInfo, _Other} ->
			SoldierInfo;
		_->
			none
	catch
		_:_ -> none
	end.

%%ת����, ���ܱ���Ӱ��
actTurn(SoldierInfo, Direction, Time) ->
	{Id, Position, Facing, _Action,Hp} = SoldierInfo,
	ets:update_element(battle_field, Id, [{6, "wait"},{5, Direction}]),
	record({action, Time, Id, addTurn(Direction), Position, Facing, Hp}).
	

%% �ƶ���������Ҫ��Ŀ������Ƿ��ж���
%% Direction : 1 ��ǰ�ߣ� -1 �����	
actMove(SoldierInfo, Direction, Time) ->
	
	{Id, Position, Facing, _Action, Hp} = SoldierInfo,
	
	DestPosition = calcDestination(Position, Facing, Direction),
	
	%% ���Ŀ��λ���ǺϷ��ģ����ƶ�������ͷ����ö���,ԭ�ز���
	Valid = positionValid(DestPosition),
		
	if 		
		Valid == true ->  
			ets:update_element(battle_field, Id, [{6, "wait"},{3, DestPosition}]);
		true ->
			ets:update_element(battle_field, Id, [{6, "wait"}])
	end,
	
	%% ������߶���
	record({action, Time, Id, "move", DestPosition, Facing, Hp}).

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
actAttack(SoldierInfo,Time) ->
	
	{ID, Position, Facing, _Action,Hp} = SoldierInfo,
	{_MyId, MySide} = ID,
	
	DestPosition = calcDestination(Position, Facing, 1),

	case battlefield:get_soldier_by_position(DestPosition) of 
		
		Enemy when is_record(Enemy,soldier) -> 

			{_Key, EID, _EPosition, EHp, _EFacing, _EAction, _EEffTime, _ESeq} = Enemy,
			{_Eid, ESide} = EID,

			if 
				%% ֻ�ܹ������ˣ��Լ��˲��ܹ���
				MySide /= ESide ->
					%% �����սʿ��������
					record({action, Time, ID, "attack", Position, Facing, Hp}),

					case calcHit(SoldierInfo, Enemy) of
						%% ���hit ���� 0 ����ʾ�õ��˱�ɱ��
						Hit when Hit == 0 ->
							ets:match_delete(battle_field, Enemy),
							%% �����������״̬
							record({status, Time, Enemy#soldier.id, Enemy#soldier.position, Enemy#soldier.facing, 0, Enemy#soldier.hp});
	
						%% Hit �����㣬�ۼ����Է���Ѫ
						Hit when Hit > 0 ->
							ets:update_element(battle_field, EID, [{4, EHp - Hit}]),
							record({status, Time, Enemy#soldier.id, Enemy#soldier.position, Enemy#soldier.facing, Enemy#soldier.hp - Hit, Hit})
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
	{_Id, Position, _Facing, _Action, _Hp} = SoldierInfo,
	
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
					{winner, "red"};
				_ ->
					none
			end
	end.
		

%% ����һ���������Ѫ��
calcBlood([]) -> 0;
calcBlood([Soldier | T]) ->
	Soldier#soldier.hp + calcBlood(T).

	
%% ��¼��ɫ�ƻ�����
record(Record) ->
	recorder! {self(),Record}.
	
%% ��¼����սʿ����һ�������ƻ�
recordPlan(Time) ->
	
	Soldiers = ets:tab2list(battle_field),
	
	lists:foreach(
		fun(Soldier) -> 
			record({plan, Soldier#soldier.id, Soldier#soldier.action, Soldier#soldier.act_effect_time - Time})
		end,
		Soldiers).

%% ���ձ�׼��ʽ�����turnWest ��״̬	
addTurn(Direction) ->
	if 
		Direction == "west" -> "turnWest";
		Direction == "east" -> "turnEast";
		Direction == "south" -> "turnSouth";
		Direction == "north" -> "turnNorth";
		true -> "wait"
	end.

	
%% �˳�ǰ��������
cleanUp(BlueSide, RedSide) ->

	io:format("begin to clean the battle field ~n",[]),	
	exit(RedSide, normal),
	exit(BlueSide, normal),
	exit(whereis(recorder), normal),
	
	%% ���������̶�������Ȼ��ʼ������
	tools:sleep(3000),
	ets:delete(battle_field),
	ets:delete(battle_timer).	
	
	