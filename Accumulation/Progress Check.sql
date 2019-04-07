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
    WHERE   _TABLE_SUFFIX IN ('20190324','20190325')
    AND     user_id = 'A_cjac11xpn001en6m3hbimchwt'
    AND     (event IN ('attack_end','raid_end','accumulation_event_action_complete','accumulation_reward_collected') OR (event='spin' AND spin_result='accumulation'))
    ORDER BY  2
