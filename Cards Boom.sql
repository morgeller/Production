SELECT  CAST(TIMESTAMP_MICROS(t) AS DATE)           server_time,
        user_id,
        profile,
        village,
        JSON_EXTRACT_SCALAR(c,'$.chest_type')       chest_type,
        amount,
        count(*) chests
        
        
FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX >= '20190302'
AND     event = 'chest_found'
AND     (JSON_EXTRACT_SCALAR(c,'$.active_special_event_1') = 'cards_boom' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_2') = 'cards_boom' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_3') = 'cards_boom')

GROUP BY 1,2,3,4,5,6


************************************

SELECT  server_time,
        profile,
        CASE  WHEN chest_type = 'wooden'  AND amount=2 THEN 1
              WHEN chest_type = 'golden'  AND amount=4 THEN 1
              WHEN chest_type = 'magical' AND amount=8 THEN 1
        ELSE 0 END Bug,
        SUM(chests) chests,
        COUNT(DISTINCT user_id) Users
FROM    TMP.cards_boom_no_extra_reward
GROUP BY 1,2,3
