-module(erlbattle).
-export([start/0,timer/3]).

%% ս����ʼ����������
start() ->
    io:format("Server Starting ....~n", []),
	
	%%  TODO: �����Ҫ�Ǻ���������ÿ̨�������ܹ�����ͬ�Ľ�����е�����
	%%  io:format("Testing Computer Speed....~n", [])
	Sleep = 10,
	
    %%  TODO: �����������ӵĳ�ʼ״̬
	io:format("Army matching into the battle fileds....~n", []),
	
	%% ����һ����ʱ��, ��Ϊս������
	spawn(erlbattle, timer, [self(),1,Sleep]),
	
	%% �����췽�������ľ��߳���
	%% TODO:  Ϊ�˱���ĳһ��ͨ������Ϣ��Ӱ��Է��� δ��Ҫ�ж�����ͨѶ������ÿ������Ϣ
	io:format("Command Please, Generel....~n", []),
	BlueSide = spawn(feardFarmers, start, [self(), blue]),
	RedSide = spawn(englandArmy, start, [self(), red]),
	
	%% ��ʼս��ѭ��
	run(BlueSide, RedSide).
		

%% ս���߼�������	
run(BlueSide, RedSide) ->
	
	receive 
		finish ->
			BlueSide!finish,
			RedSide!finish,
			io:format("Sun goes down, battle finished!~n", []),
			%% ���ս�����
			io:format("The winner is blue army ....~n", []);			
		{time, Time} ->
				%% TODO ս���߼�
				%% do something
				io:format("Time: ~p s ....~n", [Time]),
				run(BlueSide, RedSide);
		{command,Command} ->
				%% Todo ������Ϣ
				io:format("~p ~n", [Command]),
				run(BlueSide, RedSide)
	end.

%% Todo: Sleep С����,��Ϣ���ɺ���
timer(Pid, Time,Sleep) -> 
	
	sleep(Sleep),
	
	%% ս��������еĴ��� 
	MaxTurn = 20,
	if 
		Time == MaxTurn ->
			Pid!finish;
		Time < MaxTurn ->
			Pid !{time, Time},
			timer(Pid, Time+1,Sleep)
	end.

	
%% Sleep ���ߺ���
sleep(Sleep) ->
	receive
	
	after Sleep -> true
    
	end.

