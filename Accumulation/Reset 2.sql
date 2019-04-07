SELECT  user_id,
        current_mission_index,
        complete_count,
        collected_count,
        accumulation_event_activated,
        special_event_activated

FROM (

SELECT  A.user_id,
        CAST(CASE WHEN event IN ('accumulation_mission_complete','accumulation_reward_collected') THEN JSON_EXTRACT_SCALAR(c,'$.current_mission_index') END AS INT64)     current_mission_index,
        COUNT(DISTINCT CASE WHEN event = 'accumulation_mission_complete' THEN c END)                                                                                      complete_count,
        COUNT(DISTINCT CASE WHEN event = 'accumulation_reward_collected' THEN c END)                                                                                      collected_count,
        COUNT(DISTINCT CASE WHEN event = 'accumulation_event_activated' THEN c END)                                                                                       accumulation_event_activated,
        COUNT(DISTINCT CASE WHEN event = 'special_event_activated' AND JSON_EXTRACT_SCALAR(c,'$.event_id') LIKE 'accumulation%' THEN c END)                               special_event_activated

FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY   A
JOIN    VIKING.Account                                        B ON A.user_id=B.user_id
WHERE   server_time >= '2019-03-31'
AND     (event IN ('accumulation_mission_complete','accumulation_event_activated','accumulation_reward_collected') 
      OR (event = 'special_event_activated' AND JSON_EXTRACT_SCALAR(c,'$.event_id') LIKE 'accumulation%'))

GROUP BY 1,2
)


--Destination table: hallowed-forge-577:TMP.reset_users_rev


SELECT * FROM (
SELECT  A.user_id,
        max_current_mission_index,
        max_complete_count,
        MAX(accumulation_event_activated) accumulation_event_activated,
        MAX(special_event_activated)      special_event_activated
FROM    `TMP.reset_users_rev`   A

JOIN    (   SELECT  user_id,MAX(complete_count) max_complete_count, max(cast(current_mission_index as int64)) max_current_mission_index
            FROM    TMP.reset_users_rev
            WHERE   collected_count>1
            GROUP BY 1
        ) B ON A.user_id=B.user_id

GROUP BY 1,2,3
)
WHERE accumulation_event_activated = 1
AND   max_complete_count>1

--Destination table: hallowed-forge-577:TMP.reset_users_rev_attacked

SELECT  A.user_id,
        MIN(CASE WHEN CAST(JSON_EXTRACT_SCALAR(c,'$.current_mission_index') AS INT64) = max_current_mission_index THEN server_time END) From_,
        MAX(CASE WHEN CAST(JSON_EXTRACT_SCALAR(c,'$.current_mission_index') AS INT64) = max_current_mission_index THEN server_time END) To_

        
FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY   A
JOIN    `TMP.reset_users_rev_attacked`                        B ON A.user_id=B.user_id

WHERE   server_time >= '2019-03-31'
AND     event IN ('accumulation_reward_collected','accumulation_mission_complete')
GROUP BY 1

--Destination table: hallowed-forge-577:TMP.reset_users_rev_attacked_1



SELECT      A.user_id,
            MIN(From_) server_time,
            MAX(CASE WHEN event = 'bot_raid' THEN 1 ELSE 0 END) bot_raid,
            MAX(CASE WHEN event = 'raid_end' THEN 1 ELSE 0 END) raid_end,
            MAX(CASE WHEN event = 'bot_attack' THEN 1 ELSE 0 END) bot_attack,
            MAX(CASE WHEN event = 'attack_end' THEN 1 ELSE 0 END) attack_end
FROM        TMP.reset_users_rev_attacked_1 A
LEFT JOIN   (

SELECT  attackedPerson,
        server_time,
        event
FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY
WHERE   server_time >= '2019-03-31'
AND     event IN ('raid_end','bot_raid','attack_end','bot_attack')
           
             ) B ON A.user_id=B.attackedPerson AND A.From_<= B.server_time AND A.To_ >= B.server_time
             
GROUP BY 1             

--Destination table: hallowed-forge-577:TMP.reset_users_rev_attacked_2



SELECT  cast(server_time as date) date,
        extract(hour from server_time) hour,
        count(distinct user_id) users,
        count(distinct case when (bot_raid+raid_end+bot_attack+attack_end)>0 then user_id end) attacked_users
FROM    TMP.reset_users_rev_attacked_2
GROUP BY 1,2
