SELECT      user_id,
            
            max(case when cast(JSON_EXTRACT_SCALAR(c,'$.fox_pay') as int64)>0 then 1 else 0 end) foxy,
            
            
            sum(case when event = 'raid_end' 
                then 1 else 0 end) total_raids,
                
            sum(case when event = 'accumulation_event_action_complete' 
                      and JSON_EXTRACT_SCALAR(c,'$.action_name') in ('raid','perfect_raid')
                then 1 else 0 end) accumulation_raid,    
            
            sum(case when event = 'raid_end' 
                      and cast(JSON_EXTRACT_SCALAR(c,'$.amount_total') as int64)=(pay-cast(JSON_EXTRACT_SCALAR(c,'$.fox_pay') as int64)) 
                then 1 else 0 end) perfect_raid,
            
            sum(case when event = 'accumulation_event_action_complete' 
                      and JSON_EXTRACT_SCALAR(c,'$.action_name') = 'perfect_raid'
                then 1 else 0 end) accumulation_perfect_raid
           

FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX IN ('20190324','20190325','20190326')
--AND     user_id = 'B_cjja4q3xs0m5qsjjvsn5x9yut'
AND     event IN ('raid_end','accumulation_event_action_complete')
GROUP BY 1
ORDER BY  1,2

--Destination table: hallowed-forge-577:TMP.accumulation_perfect_raids_3


**************************************************************************

SELECT  CASE WHEN perfect_raid<>accumulation_perfect_raid THEN 1 ELSE 0 END,
        foxy,
        COUNT(*) N

FROM    TMP.accumulation_perfect_raids
WHERE   total_raids=accumulation_raid
GROUP BY 1,2


**************************************************************************

SELECT      TIMESTAMP_MICROS(t)           server_time,
            time,
            event,
            spins,
            coins,
            village,
            atk_result,
            JSON_EXTRACT_SCALAR(c,'$.amount_total')                 amount_total,
            pay-cast(JSON_EXTRACT_SCALAR(c,'$.fox_pay') as int64)   pay,
            JSON_EXTRACT_SCALAR(c,'$.fox_pay')                      fox_pay,
            
            JSON_EXTRACT_SCALAR(c,'$.action_name')            action_name,
            JSON_EXTRACT_SCALAR(c,'$.current_mission_index')  current_mission_index,
            JSON_EXTRACT_SCALAR(c,'$.current_amount')         current_amount,
            JSON_EXTRACT_SCALAR(c,'$.received_amount')        received_amount,
            replace(coalesce(JSON_EXTRACT_SCALAR(c,'$.bet_type'),JSON_EXTRACT_SCALAR(c,'$.bet'),JSON_EXTRACT_SCALAR(c,'$.bet_multiplier')),'X','') bet,
            JSON_EXTRACT_SCALAR(c,'$.required_amount')        required_amount,
            JSON_EXTRACT_SCALAR(c,'$.final_mission_index')    final_mission_index

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190324','20190325','20190326')
    AND     user_id = 'B_cjja4q3xs0m5qsjjvsn5x9yut'
    AND     (event IN ('attack_end','raid_end','accumulation_event_action_complete','accumulation_reward_collected') OR (event='spin' AND spin_result='accumulation'))
    ORDER BY  1,2
