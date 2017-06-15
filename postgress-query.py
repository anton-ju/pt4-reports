# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import psycopg2
import pandas as pd
import numpy as np

try:
    conn = psycopg2.connect("dbname='PT4_2017_02_HT6MaX' user='postgres' host='10.0.2.2' password='postgresspass'")
except: 
    print("unable to connect")

cur = conn.cursor()

eff_stack_range35 = '35.01 and 250'
eff_stack_range25 = '25.01 and 35'
eff_stack_range19 = '19.01 and 25'
eff_stack_range14 = '14.01 and 19'
eff_stack_range11 = '11.01 and 14'
eff_stack_range8 = '8.01 and 11'
eff_stack_range5 = '5.01 and 8'
eff_stack_range0 = '0 and 5'

eff_stack_range_list = [eff_stack_range0,
                        eff_stack_range5,
                        eff_stack_range8,
                        eff_stack_range11,
                        eff_stack_range14,
                        eff_stack_range19,
                        eff_stack_range25,
                        eff_stack_range35]
q1 = """(
SELECT ((case when( lookup_positions.flg_sb) then  0 
	else  (case when( lookup_positions.flg_bb) then  1 
	else  (case when( lookup_positions.flg_ep) then  2 
	else  (case when( lookup_positions.flg_mp) then  3 
	else  (case when( lookup_positions.flg_co) then  4 
	else  5 end) end) end) end) end)) as "val_position_type", 
	((case when( lookup_positions.flg_sb) then  'SB' 
	else  (case when( lookup_positions.flg_bb) then  'BB' 
	else  (case when( lookup_positions.flg_ep) then  'EP' 
	else  (case when( lookup_positions.flg_mp) then  'MP' 
	else  (case when( lookup_positions.flg_co) then  'CO' 
	else  'BTN' end) end) end) end) end)) as "str_position_type", 
	(sum((case when(tourney_hand_player_statistics.id_hand > 0) then  1 else  0 end))) as "cnt_hands", 
	round(100 * sum( (CASE WHEN ( tourney_blinds.amt_bb) <> 0 THEN ((tourney_hand_player_statistics.amt_expected_won * 1.0 )/( tourney_blinds.amt_bb)) ELSE 0 END) ) / (sum((case when(tourney_hand_player_statistics.id_hand > 0) then  1 else  0 end))), 2) as "wr_bb100",
	(sum((case when(tourney_hand_player_statistics.flg_p_first_raise AND tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_raise_first_in", 
  (sum((case when(tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_open_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet) then  1 else  0 end))) as "cnt_p_3bet", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_p_3bet_opp", 
  --(sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action LIKE 'R%') then  1 else  0 end))) as "cnt_steal_def_action_raise", 
  --(sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_steal_def_3bet_opp", 
  (sum((case when(tourney_hand_player_statistics.enum_p_3bet_action='F' AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_action_fold_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_def_opp AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_opp_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action = 'F') then  1 else  0 end))) as "cnt_steal_def_action_fold", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp) then  1 else  0 end))) as "cnt_steal_def_opp"
FROM   tourney_table_type, tourney_summary, tourney_hand_summary, tourney_hand_player_statistics , lookup_actions lookup_actions_p, tourney_blinds, lookup_actions lookup_actions_f, lookup_positions 
WHERE  (lookup_actions_p.id_action=tourney_hand_player_statistics.id_action_p)  
	AND (tourney_blinds.id_blinds = tourney_hand_player_statistics.id_blinds)  
	AND (lookup_actions_f.id_action=tourney_hand_player_statistics.id_action_f)  
	AND (lookup_positions."position"=tourney_hand_player_statistics."position"  
	AND lookup_positions.cnt_players=tourney_hand_player_statistics.cnt_players_lookup_position)  
	AND (tourney_hand_summary.cnt_players between 5 AND 6 )
	AND (tourney_hand_summary.id_hand = tourney_hand_player_statistics.id_hand  
	AND tourney_hand_summary.id_blinds = tourney_hand_player_statistics.id_blinds)  
	AND (tourney_blinds.id_blinds = tourney_hand_summary.id_blinds)   
	AND (tourney_hand_player_statistics.id_player = 
		(SELECT id_player FROM player WHERE player_name_search=E'diggerr555'  AND id_site='100'))       
	--AND (tourney_summary.id_tourney = tourney_hand_player_statistics.id_tourney)  
	AND (tourney_summary.id_tourney = tourney_hand_player_statistics.id_tourney  
	AND tourney_summary.id_table_type = tourney_table_type.id_table_type) 
	AND ((tourney_hand_summary.id_gametype = 1)
	AND ((tourney_table_type.description like 'STT%')
	AND (tourney_hand_player_statistics.date_played >= '2017/01/01 03:00:00' 
	AND tourney_hand_player_statistics.date_played <= '2017/06/02 02:59:59')))  
	and tourney_hand_player_statistics.amt_p_effective_stack/tourney_blinds.amt_bb between {eff_stack}
GROUP BY ((case when( lookup_positions.flg_sb) then  0 
	else  (case when( lookup_positions.flg_bb) then  1 
	else  (case when( lookup_positions.flg_ep) then  2 
	else  (case when( lookup_positions.flg_mp) then  3 
	else  (case when( lookup_positions.flg_co) then  4 
	else  5 end) end) end) end) end)), 
	((case when( lookup_positions.flg_sb) then  'SB' 
	else  (case when( lookup_positions.flg_bb) then  'BB' 
	else  (case when( lookup_positions.flg_ep) then  'EP' 
	else  (case when( lookup_positions.flg_mp) then  'MP' 
	else  (case when( lookup_positions.flg_co) then  'CO' 
	else  'BTN' end) end) end) end) end)) 

order by val_position_type
)
"""

df = pd.DataFrame()
for stack in eff_stack_range_list:
#stack = eff_stack_range0
    columns = ['val_pos',
           'str_pos',
           'hands',
           stack,
           'rfi',
           'rfi_opp',
           '3bet',
           '3bet_opp',
           '2bet_fold',
           '2bet_fold_opp',
           'fold_to_steal',
           'fold_to_steal_opp']
    cur.execute(q1.format(eff_stack=stack))
        
    rows = cur.fetchall()
    df1 = pd.DataFrame(data=rows, columns=columns, dtype=float)
    df1['rfi'] = df1['rfi']/df1['rfi_opp']
    df1['3bet'] = df1['3bet']/df1['3bet_opp']
    df1['2bet_fold'] = df1['2bet_fold']/df1['2bet_fold_opp']
    df1['fold_to_steal'] = df1['fold_to_steal']/df1['fold_to_steal_opp']
    
    tot_hands = df1.sum(0)['hands']
    
    tot_wr = sum(df1[stack].mul(df1['hands']/tot_hands))
    tot_rfi = sum(df1['rfi'].mul(df1['hands']/tot_hands))
    tot_3bet = sum(df1['3bet'].mul(df1['hands']/tot_hands))
    tot_2bet_fold = sum(df1['2bet_fold'].mul(df1['hands']/tot_hands))
    tot_fold_to_steal = sum(df1['fold_to_steal'].mul(df1['hands']/tot_hands))
    #df2 = df1.T
    df1.index = df1['str_pos']
    df1.drop(['val_pos',
              'str_pos', 
              'rfi_opp', 
              '3bet_opp', 
              '2bet_fold_opp',
              'fold_to_steal_opp'], axis=1, inplace=True)
    
    ro = pd.DataFrame({'hands': tot_hands, 
                       stack :tot_wr,
                       'rfi': tot_rfi,
                       '3bet': tot_3bet,
                       '2bet_fold': tot_2bet_fold,
                       'fold_to_steal': tot_fold_to_steal}, 
                      index=['TOTAL'])
    df1 = pd.concat([df1, ro])
    df1.to_csv('/home/ant/Documents/python-projects/wr'+ stack +'.csv',float_format='%.2F')
#    df = pd.concat([df, df1], axis=1)
#df2.drop(df2.index[0], inplace=True)
#df2['TOTAL'] = [tot_hands, wr]
#df2.index = [stack, stack]
#df.fillna(0,inlplace=True)
#print(df)

#df.to_csv('/home/ant/Documents/python-projects/wr.csv',float_format='%.2F')
#print(wr)

#df2 = pd.DataFrame(data=list(df1.iloc[:,3].values))
#print(df1.iloc[:,3].T)
#print(df2)