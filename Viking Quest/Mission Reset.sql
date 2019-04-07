
    SELECT  user_id,
            JSON_EXTRACT_SCALAR(c,'$.missions_total') missions_total,
            JSON_EXTRACT_SCALAR(c,'$.mission_completed') mission_completed,
            MAX(village) max_village,
            MIN(village) min_village,
            MAX(profile)profile,
            COUNT(DISTINCT C) N

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    AND     event IN ('event_slot_reward_collected')
    
    GROUP BY 1,2,3



    SELECT  
        CASE WHEN N>1 THEN 1 ELSE 0 END Bug,
        max_village,
        count(distinct user_id) Users

    FROM    TMP.viking_q_mission_reset_rev
    WHERE N>1
    GROUP BY 1,2
