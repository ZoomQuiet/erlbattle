-module(channel).
-export([start/3]).
-include("schema.hrl").

start(BattleField, Side, ArmyName) ->
	
	process_flag(trap_exit,true),
	
	receive
		
		%% �ȴ���������Ϣ���п���Ȩת������Ȼ������ָ�ӳ���
		{'ETS-TRANSFER',Tab,_FromPid,_GiftData} ->
			io:format("~p plays the ~p Side ~n", [ArmyName, Side]),
			Commander = spawn_link(ArmyName, run, [self(),Side]),
			loop(BattleField, Commander, Tab,1);
		
		_ ->
			start(BattleField, Side, ArmyName)
			
	end.	
	
%% ��Ϣѭ������ָ��ŵ�������
loop(BattleField, Commander, Queue,CommandId) ->
	
	receive
		
		{command,Command,Soldier,Time} ->
			%% ����һ��command ��¼
			CmdRec = #command{
					soldier_id = Soldier,
					name = Command,
					execute_time = Time,
					seq_id = CommandId},
			ets:insert(Queue, CmdRec),
			loop(BattleField, Commander, Queue,CommandId +1);

		%% ������������󣬻ᷢ������Ѿ�ʹ�ù����������Ϣ����Ҫ��������������ظ�����
		%% ��������֮ǰ���Ѿ����µ���Ϣ��������seq_id �Ѿ����£��Ͳ��ᱻ��ɾ
		{expireCommand, CommandIds} ->
			io:format("begin to clear used command ~p.of ~p. ~n",  [CommandIds, ets:tab2list(Queue)]),
			lists:foreach(
				fun(SeqId) ->
					Pattern=#command{
						soldier_id = '_',
						name = '_',
						execute_time = '_',
						seq_id = SeqId},
					ets:match_delete(Queue, Pattern)
				end,
				CommandIds),
			io:format("cleard after of ~p. ~n",  [ets:tab2list(Queue)]),
			loop(BattleField, Commander, Queue,CommandId);
			
		%% ������ʼɱ�ң��Ҿ�ɱ��ҽ���
		{'EXIT', _, _} ->
			exit(Commander, finish), %ɱ���߽���, ���߽����������׽�����Զ��˳�
			tools:sleep(500),
			ets:delete(Queue) % �������
	end.
	
	
	





