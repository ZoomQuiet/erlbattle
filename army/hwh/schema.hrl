


-record(phone,
	{
		channel,
		queue,
		info,
		side,
		grid
	}
).

%% ս����Ϣ
-record(grid_info,
	{
		id,
		friend = [],	%ս�����Ѿ�
		enemy = []		%ս���ڵо�
	}
).