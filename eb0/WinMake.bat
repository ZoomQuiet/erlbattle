::������뼰���Խ����WinMake.log���ļ����������
@echo off
set mypath="C:\Documents and Settings\%username%\����"
echo ���ڱ��룬���Ե�...... 
echo %date% %time% >> %mypath%\WinMake.log
::ɾ�����ڵ�beam��dump�ļ���Ȼ���������erl�ļ�
del *.beam *.dump
erlc -W erlbattle.erl battlefield.erl tools.erl worldclock.erl englandArmy.erl feardFarmers.erl >> %mypath%\WinMake.log
erlc -W testAll.erl testWorldClockGetTime.erl testBattleFieldCreate.erl testErlBattleTakeAction.erl >> %mypath%\WinMake.log
erl -noshell -s testAll test -s init stop >> %mypath%\WinMake.log
echo ������ɣ���鿴WinMake.log