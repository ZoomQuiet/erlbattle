-module(englandArmy).
-export([run/2]).

run(Channel, Side) ->
    
	Channel!{command,"forward",1,0},
	Channel!{command,"forward",2,0},
	Channel!{command,"forward",3,0},
	Channel!{command,"forward",4,0},
	Channel!{command,"forward",5,0},
	Channel!{command,"forward",6,0},
	Channel!{command,"forward",7,0},
	Channel!{command,"forward",8,0},
	Channel!{command,"forward",9,0},
	Channel!{command,"forward",10,0},
	
	tools:sleep(100),

	%% ����ս����������һЩ��β�������˳�������ʲô������
	%% �����Ϣ���Ǳ��봦���
	receive
		{'EXIT',_FROM, finish} ->  
			true;
		
		_ ->
			run(Channel, Side)
			
	after 1 -> 
			run(Channel, Side)
	end.
	