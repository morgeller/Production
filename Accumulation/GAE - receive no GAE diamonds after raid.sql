--user check:

SELECT      TIMESTAMP_MICROS(t)           server_time,
            time,
            event,
            spins,
            coins,
            village,
            atk_result,
            JSON_EXTRACT_SCALAR(c,'$.action_name')            action_name,
            JSON_EXTRACT_SCALAR(c,'$.current_mission_index')  current_mission_index,
            JSON_EXTRACT_SCALAR(c,'$.current_amount')         current_amount,
            JSON_EXTRACT_SCALAR(c,'$.received_amount')        received_amount,
            replace(coalesce(JSON_EXTRACT_SCALAR(c,'$.bet_type'),JSON_EXTRACT_SCALAR(c,'$.bet'),JSON_EXTRACT_SCALAR(c,'$.bet_multiplier')),'X','') bet,
            JSON_EXTRACT_SCALAR(c,'$.required_amount')        required_amount,
            JSON_EXTRACT_SCALAR(c,'$.final_mission_index')    final_mission_index

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190408')
    AND     user_id = 'B_cjju6nqnf07mgu3iifb7zzpua'
    AND     (event IN ('attack_end','raid_end','accumulation_event_action_complete'/*,'accumulation_reward_collected'*/) OR (event='spin' AND spin_result='accumulation'))
    AND     (JSON_EXTRACT_SCALAR(c,'$.active_special_event_1')= 'accumulation' OR 
             JSON_EXTRACT_SCALAR(c,'$.active_special_event_2')= 'accumulation' OR 
             JSON_EXTRACT_SCALAR(c,'$.active_special_event_3')= 'accumulation' OR
             event = 'accumulation_event_action_complete')
    ORDER BY  1
    
    
    
    --user list:
SELECT  user_id,
        profile,
        village,
        max(app_version) app_version,
        count(distinct case when event = 'raid_end' then c end)                                                                                                     raid,
        count(distinct case when event = 'accumulation_event_action_complete' and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('raid','perfect_raid') then c end)     raid_prog,
        count(distinct case when event='chest_found' AND source='raid' then c end)     raid_chest,
        
        count(distinct case when event = 'attack_end' then c end)                                                                                                   attack,
        count(distinct case when event = 'accumulation_event_action_complete' and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('attack','attack_block') then c end)   attack_prog,
        
        count(distinct case when event = 'attack_end' and atk_result = 'ok' then c end)                                                                             attack_hit,
        count(distinct case when event = 'accumulation_event_action_complete' and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('attack') then c end)                  attack_hit_prog,
        
        count(distinct case when event = 'attack_end' and atk_result <> 'ok' then c end)                                                                            attack_block,
        count(distinct case when event = 'accumulation_event_action_complete' and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('attack_block') then c end)            attack_block_prog,
        
        count(distinct case when event = 'attack_end' and atk_result = 'sync' then c end)                                                                           attack_sync,
        count(distinct case when event = 'attack_end' and atk_result = 'no_item' then c end)                                                                        attack_no_item,
        
        count(distinct case when event='spin' AND spin_result='accumulation' then c end)                                                                            spin,
        count(distinct case when event = 'accumulation_event_action_complete' and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('match_3') then c end)                 spin_prog
        
FROM    `VIKING.EVENTS_*`

WHERE   _TABLE_SUFFIX IN ('20190408','20190409','20190410')
AND     (event IN ('attack_end','raid_end','accumulation_event_action_complete') OR (event='spin' AND spin_result='accumulation') OR (event='chest_found' AND source='raid'))
AND     (JSON_EXTRACT_SCALAR(c,'$.active_special_event_1')= 'accumulation' OR 
         JSON_EXTRACT_SCALAR(c,'$.active_special_event_2')= 'accumulation' OR 
         JSON_EXTRACT_SCALAR(c,'$.active_special_event_3')= 'accumulation' OR
         event = 'accumulation_event_action_complete')

GROUP BY  1,2,3
                                                                                                                                      
--Destination table: hallowed-forge-577:TMP.accumulation_bug_rev
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      
--sum:
SELECT  count(distinct user_id) users,
        count(distinct case when raid_prog<raid then user_id end)       raid_bug,
        count(distinct case when attack_prog<attack then user_id end)   attack_bug,
        count(distinct case when spin_prog<spin then user_id end)       spin_bug,
        count(distinct case when raid_prog<raid or attack_prog<attack or spin_prog<spin then user_id end)       any_bug
FROM    TMP.accumulation_bug_rev
                                                                                                                                      
                                                                                                                                      
SELECT  case when raid_chest>0 then 1 else 0 end chest_ind,
        count(distinct user_id) users,
        count(distinct case when raid_prog<raid then user_id end)       raid_bug,
        count(distinct case when attack_prog<attack then user_id end)   attack_bug,
        count(distinct case when spin_prog<spin then user_id end)       spin_bug,
        count(distinct case when raid_prog<raid or attack_prog<attack or spin_prog<spin then user_id end)       any_bug
FROM    TMP.accumulation_bug_rev
GROUP BY 1
