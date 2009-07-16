-module(battleRecorder).
-export([start/1]).

start(Pid) ->
	
	process_flag(trap_exit, true),
	
	io:format("Battle Recorder Begin to Run ~n",[]),
	
	%% �������ڻ���ط���־�ı�
	ets:new(battle_record,[ordered_set,named_table,private]),

	run(Pid,1).

%% ѭ���ȴ���������	
run(Pid, Seq) ->

	receive
		%% �˳�ʱ������л�����Ϣ
		{'EXIT', Pid , _Msg} ->  
			recordBattle();	
		{Pid,Record} ->
			ets:insert(battle_record, {Seq, Record} ),
			run(Pid, Seq + 1);
		_ ->
			run(Pid,Seq)   %% �����Ƿ���Ϣ�ӵ�
	end.

%% ���ڴ������м�¼��������ļ���
recordBattle() ->
	
	%%��ȡ��Ϣ�������
	Records = ets:tab2list(battle_record),
	ets:delete(battle_record),
	
	%% open file
	{_Ok, Io} = file:open("erlbattle.warlog",[write]),		
	
	%% ��ʼ��ս��
	initBattleField(Io),
	
	%% ���ڴ��еļ����¼�����չ淶���
	lists:foreach(
		fun(RawRecord) ->
			{_Seq, Record} = RawRecord,
			case Record of 
				{action, Time, Id, Action, Position, Facing, Hp}->
					{X,Y} = Position,
					io:fwrite(Io,"~p,~p,~p,~p,~p,~p,~p,0~n" , [Time, Action, X, Y, uniqueId(Id), Facing, Hp]);
				{plan, Id, Action, ActionEffectTime} ->
					if 
						Action == "wait"  ->
							io:fwrite(Io,"plan,~p,[]~n" , [uniqueId(Id)]);
						true ->
							io:fwrite(Io,"plan,~p,~p@~p~n" , [uniqueId(Id), Action, ActionEffectTime])
					end;
				{status,Time, Id, Position, Facing, Hp, HpLost} ->
					{X,Y} = Position,
					io:fwrite(Io,"~p,~p,~p,~p,~p,~p,~p,~p~n" , [Time,"status", X,Y, uniqueId(Id), Facing, Hp, HpLost]);
				{result, Result}->
					io:fwrite(Io,"result,~p~n" , [Result]);
				_ ->
					none
				end
			end,
			Records),

	%% close file
	file:close(Io).	

%% ���ָ���˫�����ӽ���ս��	
initBattleField(Io) ->

	Army = [1,2,3,4,5,6,7,8,9,10],
	
	%% ׼���췽λ��
	lists:foreach(
		fun(Id) ->
			io:fwrite(Io,"~p,~p,~p,~p,~p,~p,~p,~p~n" , [0,"status", 0,1+Id, Id, "east", 100, 0])
		end,
		Army),

	%% ׼������λ��
	lists:foreach(
		fun(Id) ->
			io:fwrite(Io,"~p,~p,~p,~p,~p,~p,~p,~p~n" , [0,"status", 14,1+Id, Id+10, "west", 100, 0])
		end,
		Army).
		
			
%% record ���Э��Ҫ���������� id =10 ���
uniqueId(Id) ->

	{Sid, Side} = Id,
	
	if 
		Side == "blue" ->
			Sid + 10;
		true ->
			Sid
	end.
	