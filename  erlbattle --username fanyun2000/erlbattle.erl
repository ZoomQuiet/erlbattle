-module(erlbattle).
-export([start/0,run/0,timer/3]).

%% ս����ʼ����������
start() ->
    io:format("Server Starting ....~n", []),
	
	%%  TODO: �����Ҫ�Ǻ���������ÿ̨�������ܹ�����ͬ�Ľ�����е�����
	%%  io:format("Testing Computer Speed....~n", [])
	Sleep = 10,
	
    %%  TODO: �����������ӵĳ�ʼ״̬
	io:format("Army matching into the battle fileds....~n", []),
	
	%% ��ʼս��ѭ��
	BattleFiled_PID = spawn(erlbattle, run,[]),
	
	%% ����һ����ʱ��
	spawn(erlbattle, timer, [BattleFiled_PID,1,Sleep]),
	
	%% �����췽�������ľ��߳���
	%% TODO:  Ϊ�˱���ĳһ��ͨ������Ϣ��Ӱ��Է��� δ��Ҫ�ж�����ͨѶ������ÿ������Ϣ
	io:format("Command Please, Generel....~n", []),
	spawn(army, start, [BattleFiled_PID, blue, feardFarmers]),
	spawn(army, start, [BattleFiled_PID, red, englandArmy]).
	

%% ս���߼�������	
run() ->
	
	receive 
		finish ->
			io:format("Sun goes down, battle finished!~n", []),
			%% ���ս�����
			io:format("The winner is blue army ....~n", []);			
		{time, Time} ->
				%% TODO ս���߼�
				%% do something
				io:format("Time: ~p s ....~n", [Time]),
				run();
		{command,Command} ->
				%% Todo ������Ϣ
				io:format("Command: ~p ~n", [Command]),
				run()
	end.

%% Todo: Sleep С����,��Ϣ���ɺ���
timer(Pid, Time,Sleep) -> 

	%% ս��������еĴ��� 
	MaxTurn = 20,
	if 
		Time == MaxTurn ->
			Pid!finish;
		Time < MaxTurn ->
			Pid !{time, Time},
			timer(Pid, Time+1,Sleep)
	end.
		