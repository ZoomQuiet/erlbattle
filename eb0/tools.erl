-module(tools).
-export([sleep/1]).

%% Sleep ���ߺ���
sleep(Sleep) ->
	receive
	
	after Sleep -> true
    
	end.