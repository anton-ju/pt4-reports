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
  (sum((case when(tourney_hand_player_statistics.flg_vpip) then  1 else  0 end))) as "cnt_vpip", 
  (sum((case when(lookup_actions_p.action = '') then  1  else  0 end))) as "cnt_walks", 
  (sum((case when(tourney_hand_player_statistics.cnt_p_raise > 0) then  1 else  0 end))) as "cnt_pfr", 
  (sum((case when( lookup_actions_p.action LIKE '__%' 
  OR (lookup_actions_p.action LIKE '_' 
  AND (tourney_hand_player_statistics.amt_before > (tourney_blinds.amt_bb + tourney_hand_player_statistics.amt_ante)) 
  AND (tourney_hand_player_statistics.amt_p_raise_facing < (tourney_hand_player_statistics.amt_before - (tourney_hand_player_statistics.amt_blind + tourney_hand_player_statistics.amt_ante))) 
  AND (tourney_hand_player_statistics.flg_p_open_opp OR tourney_hand_player_statistics.cnt_p_face_limpers > 0 
  OR tourney_hand_player_statistics.flg_p_3bet_opp OR tourney_hand_player_statistics.flg_p_4bet_opp) )) then  1 else  0 end))) as "cnt_pfr_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_p_first_raise 
  AND tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_raise_first_in", 
  (sum((case when(tourney_hand_player_statistics.flg_p_open_opp) then  1 else  0 end))) as "cnt_p_open_opp", 
  (sum( (CASE WHEN ( tourney_blinds.amt_bb) <> 0 THEN ((tourney_hand_player_statistics.amt_won * 1.0 )/( tourney_blinds.amt_bb)) 
  ELSE 0 END) )) as "amt_bb_won", 
  (sum( (CASE WHEN ( tourney_blinds.amt_bb) <> 0 THEN ((tourney_hand_player_statistics.amt_expected_won * 1.0 )/( tourney_blinds.amt_bb)) ELSE 0 END) )) as "amt_expected_bb_won", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet) then  1 else  0 end))) as "cnt_p_3bet", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_p_3bet_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action LIKE 'R%') then  1 else  0 end))) as "cnt_steal_def_action_raise", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND tourney_hand_player_statistics.flg_p_3bet_opp) then  1 else  0 end))) as "cnt_steal_def_3bet_opp", 
  (sum((case when(tourney_hand_player_statistics.enum_p_3bet_action='F' AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_action_fold_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_p_3bet_def_opp AND tourney_hand_player_statistics.flg_p_first_raise) then  1 else  0 end))) as "cnt_p_3bet_def_opp_when_open_raised", 
  (sum((case when(tourney_hand_player_statistics.flg_steal_att AND tourney_hand_player_statistics.flg_p_3bet_def_opp AND tourney_hand_player_statistics.enum_p_3bet_action='F') then  1 else  0 end))) as "cnt_steal_3bet_def_action_fold", 
  (sum((case when(tourney_hand_player_statistics.flg_steal_att AND tourney_hand_player_statistics.flg_p_3bet_def_opp ) then  1 else  0 end))) as "cnt_steal_3bet_def_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_p_4bet) then  1 else  0 end))) as "cnt_p_4bet", 
  (sum((case when(tourney_hand_player_statistics.flg_p_4bet_opp) then  1 else  0 end))) as "cnt_p_4bet_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp AND lookup_actions_p.action = 'F') then  1 else  0 end))) as "cnt_steal_def_action_fold", 
  (sum((case when(tourney_hand_player_statistics.flg_blind_def_opp) then  1 else  0 end))) as "cnt_steal_def_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_showdown) then  1 else  0 end))) as "cnt_wtsd", 
  (sum((case when(tourney_hand_player_statistics.flg_f_saw) then  1 else  0 end))) as "cnt_f_saw", 
  (sum((case when(tourney_hand_player_statistics.flg_showdown AND tourney_hand_player_statistics.flg_won_hand) then  1 else  0 end))) as "cnt_wtsd_won", 
  (sum((case when(tourney_hand_player_statistics.flg_f_cbet) then  1 else  0 end))) as "cnt_f_cbet", 
  (sum((case when(tourney_hand_player_statistics.flg_f_cbet_opp) then  1 else  0 end))) as "cnt_f_cbet_opp", 
  (sum((case when(tourney_hand_player_statistics.amt_f_bet_facing > 0 AND (lookup_actions_f.action SIMILAR TO '(F|XF)')) then  1 else  0 end))) as "cnt_f_bet_def_action_fold", 
  (sum((case when(tourney_hand_player_statistics.amt_f_bet_facing > 0) then  1 else  0 end))) as "cnt_f_bet_def_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_t_cbet) then  1 else  0 end))) as "cnt_t_cbet", 
  (sum((case when(tourney_hand_player_statistics.flg_t_cbet_opp) then  1 else  0 end))) as "cnt_t_cbet_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_p_limp) then  1 else  0 end))) as "cnt_p_limp", 
  (sum( (case when( (NOT(tourney_hand_player_statistics.flg_p_face_raise)
  OR (tourney_hand_player_statistics.flg_p_limp) 
  OR (tourney_hand_player_statistics.flg_p_first_raise)) 
  AND NOT(tourney_hand_player_statistics.flg_blind_b)) then  1  else  0  end) )) as "cnt_p_limp_opp", 
  (sum((case when(tourney_hand_player_statistics.flg_p_limp AND lookup_actions_p.action = 'CF') then  1 else  0 end))) as "cnt_p_limp_fold", 
  (sum((case when(tourney_hand_player_statistics.flg_p_limp AND tourney_hand_player_statistics.flg_p_face_raise) then  1 else  0 end))) as "cnt_p_limp_faceraise", 
  (sum( (case when(tourney_hand_player_statistics.val_equity>0 
  AND (tourney_hand_player_statistics.enum_allin='P' 
  OR ((tourney_hand_player_statistics.enum_face_allin='P' 
  OR tourney_hand_player_statistics.enum_face_allin='p') 
  AND tourney_hand_player_statistics.enum_face_allin_action<>'F'))) then  tourney_hand_player_statistics.val_equity else  0 end) )) as "val_p_equity", 
  (sum( (case when(tourney_hand_player_statistics.val_equity>0 
  AND ( tourney_hand_player_statistics.enum_allin='P' 
  OR ((tourney_hand_player_statistics.enum_face_allin='P' 
  OR tourney_hand_player_statistics.enum_face_allin='p') 
  AND tourney_hand_player_statistics.enum_face_allin_action<>'N'
  AND tourney_hand_player_statistics.enum_face_allin_action<>'F'))) then  1 else  0 end) )) as "cnt_p_allin_valid", 
  (sum(tourney_hand_player_statistics.amt_won)) as "amt_chips_won" 
FROM             tourney_hand_summary, tourney_hand_player_statistics , lookup_actions lookup_actions_p, tourney_blinds, lookup_actions lookup_actions_f, lookup_positions 
WHERE  (lookup_actions_p.id_action=tourney_hand_player_statistics.id_action_p)  
AND (tourney_blinds.id_blinds = tourney_hand_player_statistics.id_blinds) 
 AND (lookup_actions_f.id_action=tourney_hand_player_statistics.id_action_f)  
 AND (lookup_positions."position"=tourney_hand_player_statistics."position"  
 AND lookup_positions.cnt_players=tourney_hand_player_statistics.cnt_players_lookup_position)  
 AND (tourney_hand_summary.id_hand = tourney_hand_player_statistics.id_hand  
 ND tourney_hand_summary.id_blinds = tourney_hand_player_statistics.id_blinds)  
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
