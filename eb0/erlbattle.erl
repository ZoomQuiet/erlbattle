-module(erlbattle).
-export([start/0,timer/3]).

%% ������һ����ӡ������Ϣ�ĺ�
-define(debug_print(Level, Str),
    fun() ->
        case Level of
            fatal   -> io:format("FATAL\t ~p:~p ~n\t~p~n", [?FILE, ?LINE, Str]);
            error   -> io:format("ERROR\t ~p:~p ~n\t~p~n", [?FILE, ?LINE, Str]);
            notice  -> io:format("NOTICE\t ~p:~p ~n\t~p~n",[?FILE, ?LINE, Str]);
            info    -> io:format("INFO\t ~p:~p ~n\t~p~n", [?FILE, ?LINE, Str]);
            true -> ok
        end
    end()).
    
%% �����¼
%% TODO: �������Щ��¼�ͺ궨��ŵ�һ��ͳһ��.hrl�ļ��У���ģ��һ��ʹ��
-record(command, {warrior_id, command_name, execute_time}).

%% ս����ʼ����������
start() ->
    io:format("Server Starting ....~n", []),
	
    %%  TODO: �����������ӵĳ�ʼ״̬
	io:format("Army matching into the battle fileds....~n", []),
	
	%%  TODO: �����Ҫ�Ǻ���������ÿ̨�������ܹ�����ͬ�Ľ�����е�����
	%%  io:format("Testing Computer Speed....~n", [])
	Sleep = 10,

	%% ����һ����ʱ��, ��Ϊս������
	Timer = spawn(erlbattle, timer, [self(),1,Sleep]),

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
			io:format("The winner is blue army ....~n", []);			
		{Timer, time, Time} ->
				%% TODO ս���߼�
				%% do something
				io:format("Time: ~p s ....~n", [Time]),
                                
				%% For Test, ��ETS���ж�ȡ����ʾս��ʱ��
                                %% ���������һ�����⣬���Ұ�timer�����ֵ����25ʱ��
                                %% �������ӡս��ʱ��ʱ����ʱ����Ϊ����
                                %% ����windows�²��Եġ�
                                ?debug_print(info, ets:lookup(battle_timer, clock)),
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
                                        io:format("BlueSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
                                        ets:insert(BlueQueue, CmdRec),
                                        ?debug_print(info, ets:tab2list(BlueQueue)),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue);
                                    %% �췽����������
                                    RedSide ->
                                        io:format("RedSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
                                        ets:insert(RedQueue, CmdRec),
                                        ?debug_print(info, ets:tab2list(RedQueue)),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue);
                                    %% ��֪������һ������������
                                    _ ->
                                        io:format("UnknowSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue)
                                end
	end.

%% Todo: Sleep С����,��Ϣ���ɺ���
timer(Pid, Time,Sleep) -> 
	sleep(Sleep),
	
	%% ս��������еĴ��� 
	MaxTurn = 25,
	%% ��һ����������ʼ��battle_timer��
	if 
		Time == 1 ->
			ets:new(battle_timer, [set, protected, named_table]);
		true -> ok
	end,

	%% ����clockֵ
	ets:insert(battle_timer, {clock, Time}),

	if    
		Time == MaxTurn ->
			Pid!{self(), finish};
		Time < MaxTurn ->
			Pid !{self(), time, Time},
			timer(Pid, Time+1,Sleep)
	end.

	
%% Sleep ���ߺ���
sleep(Sleep) ->
	receive
	
	after Sleep -> true
    
	end.

