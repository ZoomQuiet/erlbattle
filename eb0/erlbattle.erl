-module(erlbattle).
-export([start/0]).
-include("schema.hrl").
-include("test.hrl").

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
			io:format("The winner is blue army ....~n", []);			
		{Timer, time, Time} ->
				%% TODO ս���߼�
				%% do something
				io:format("Time: ~p s ....~n", [Time]),
                                
				%% For Test, ��ETS���ж�ȡ����ʾս��ʱ��
                                %% ���������һ�����⣬���Ұ�timer�����ֵ����25ʱ��
                                %% �������ӡս��ʱ��ʱ����ʱ����Ϊ����
                                %% ����windows�²��Եġ�
				?debug_print(info, timer:getTime()),
				
				%% ����������Ч�Ķ���
				%% do something
				
				%% �Ӷ����õ�����wait ״̬��սʿ���µĶ����������ö���ɾ��
				%% do something
				
				
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
                                        %% io:format("BlueSide: warrior ~p want ~p at ~p ~n", [Warrior, Command, Time]),
                                        ets:insert(BlueQueue, CmdRec),
                                        %% ?debug_print(true, ets:tab2list(BlueQueue)),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue);
                                    %% �췽����������
                                    RedSide ->
                                        %% io:format("RedSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
                                        ets:insert(RedQueue, CmdRec),
                                        %% ?debug_print(true, ets:tab2list(RedQueue)),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue);
                                    %% ��֪������һ������������
                                    _ ->
                                        io:format("UnknowSide: ~p warrior want ~p at ~p ~n", [Warrior, Command, Time]),
                                        run(Timer, BlueSide, RedSide,BlueQueue, RedQueue)
                                end
	end.



