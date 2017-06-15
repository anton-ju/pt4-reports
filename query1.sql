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
  (sum((case when(tourney_hand_player_statistics.id_hand > 0) then  1 
  else  0 end))) as "cnt_hands", 
  (sum((case when(tourney_hand_player_statistics.flg_p_first_raise 
  AND tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_raise_first_in", 
  (sum((case when(tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_open_opp", 
  (sum( (CASE WHEN ( tourney_blinds.amt_bb) <> 0 THEN ((tourney_hand_player_statistics.amt_expected_won * 1.0 )/( tourney_blinds.amt_bb)) ELSE 0 END) )) as "amt_expected_bb_won", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet) then  1 else  0 end))) as "cnt_p_3bet", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_p_3bet_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action LIKE 'R%') then  1 else  0 end))) as "cnt_steal_def_action_raise", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_steal_def_3bet_opp", 
  (sum((case when(tourney_hand_player_statistics.enum_p_3bet_action='F' AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_action_fold_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_def_opp AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_opp_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action = 'F') then  1 else  0 end))) as "cnt_steal_def_action_fold", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp) then  1 else  0 end))) as "cnt_steal_def_opp"
 


FROM             tourney_hand_summary, tourney_hand_player_statistics , lookup_actions lookup_actions_p, tourney_blinds, lookup_actions lookup_actions_f, lookup_positions 
WHERE  (lookup_actions_p.id_action=tourney_hand_player_statistics.id_action_p)  
AND (tourney_blinds.id_blinds = tourney_hand_player_statistics.id_blinds) 
 AND (lookup_actions_f.id_action=tourney_hand_player_statistics.id_action_f)  
 AND (lookup_positions."position"=tourney_hand_player_statistics."position"  
 AND lookup_positions.cnt_players=tourney_hand_player_statistics.cnt_players_lookup_position)  
 AND (tourney_hand_summary.id_hand = tourney_hand_player_statistics.id_hand  
 AND tourney_hand_summary.id_blinds = tourney_hand_player_statistics.id_blinds)  
 AND (tourney_blinds.id_blinds = tourney_hand_summary.id_blinds)   
 AND (tourney_hand_player_statistics.id_player = 
 (SELECT id_player FROM player WHERE player_name_search=E'diggerr555'  AND id_site='100'))       
 AND ((tourney_hand_summary.id_gametype = 1)
 AND ((((((tourney_hand_summary.cnt_players BETWEEN 5 and 6)))))
 AND (((((( (CASE WHEN ( tourney_blinds.amt_bb) <> 0 THEN ((tourney_hand_player_statistics.amt_p_effective_stack )/( tourney_blinds.amt_bb)) ELSE 0 END) ) BETWEEN 8.01 and 11.00)))))))  
GROUP BY ((case when( lookup_positions.flg_sb) then  0 else  
(case when( lookup_positions.flg_bb) then  1 else  
(case when( lookup_positions.flg_ep) then  2 else 
 (case when( lookup_positions.flg_mp) then  3 else  
 (case when( lookup_positions.flg_co) then  4 else  5 end) end) end) end) end)), 
 ((case when( lookup_positions.flg_sb) then  'SB' else  
 (case when( lookup_positions.flg_bb) then  'BB' else  
 (case when( lookup_positions.flg_ep) then  'EP' else  
 (case when( lookup_positions.flg_mp) then  'MP' else  
 (case when( lookup_positions.flg_co) then  'CO' else  
 'BTN' end) end) end) end) end)) 
