
-record(soldier,{
		%%սʿ���, tuple��ʽ{���,����ս��}
		id, 
		%%λ��
		position,
		%%Ѫ��
		hp,
		%%�泯����
		direction,
		%%��ǰ����,
		action,
		%%������Чʱ��
		act_effect_time,
		%%�ж�����(Ŀǰδ���������)
	    act_sequence	
	}).

%% �����¼
-record(command, {warrior_id, command_name, execute_time}).
