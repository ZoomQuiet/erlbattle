
-record(soldier,{
		
		%%սʿ���, tuple��ʽ{���,����ս��}
		id, 
		
		%%λ��
		position,
		
		%%Ѫ�� 0 - 100
		hp,
		
		%%�泯����
		%%north,west,south,east
		facing,
		
		%%��ǰ����
		%% ǰ��forward, ���� back, 
		%% ת�� turnSouth, turnNorth, turnWest,turnEast
		%% ���� attack
		%% ԭ�ش��� wait 
		action,
		
		%%������Чʱ��
		act_effect_time,
		
		%%�ж�����(Ŀǰδ���������)
	    act_sequence	
	}).

%% �����¼
-record(command, {
		
		%% սʿ�ţ����ô�side
		soldier_id, 
		
		%% ָ������
		name,
		
		%% Ҫ��ִ��ʱ��
		execute_time,
		
		%% ������ţ�����ʶ����Щָ�ִ�й����Ա����
		seq_id
	}).
