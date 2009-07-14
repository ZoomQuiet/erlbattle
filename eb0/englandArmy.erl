-module(englandArmy).
-include("schema.hrl").
-export([run/2]).

run(Channel, Side) ->
    
	%% ���Բ�����ֱ���ɸ�����ɱ��
	process_flag(trap_exit, true),
	
	loop(Channel, Side).

loop(Channel, Side) ->
	
	Army = [1,2,3,4,5,6,7,8,9,10],
	
	lists:foreach(
		fun(Soldier) ->   % һֱ��ǰ�� ֱ�������ˣ�Ȼ��ʼ��	
			case someoneAhead(Soldier,Side) of
				true ->
					Channel!{command,"attack",Soldier,0};
				false ->
					Channel!{command,"forward",Soldier,0};
				_ ->
					none
			end
		end,
		Army),
	
	%% �ȴ�����ָ���ʵ���������Ҫ���κ��ƺ�ֻ����Ϊ�����ṩ�����ģ��
	receive
		%% ����ս����������һЩ��β�������˳�������ʲô������
		%% �����Ϣ���Ǳ��봦���
		{'EXIT',_FROM, finish} ->  
			io:format("England Army Go Back To Castle ~n",[]);
					
		_ ->
			loop(Channel, Side)
			
	after 100 -> 
			loop(Channel, Side)
			
	end.


%% ����ĳ����ɫǰ���Ƿ�����
someoneAhead(SoldierId,Side) ->
	
	case battlefield:get_soldier(SoldierId,Side) of
		
		none ->  % ��ɫ�����ڣ��Ѿ��ҵ��ˣ�
			none;
		
		Soldier when is_record(Soldier,soldier) ->  % �ҵ���ɫ

			Position = erlbattle:calcDestination(Soldier#soldier.position, Soldier#soldier.facing, 1),

			case battlefield:get_soldier_by_position(Position) of 
				none ->  		%ǰ��û��
					false;
				_Found ->		%����
					true
			end;
		_->
			none
	end.
					
			
			
	



	