
    SELECT  CAST(TIMESTAMP_MICROS(t) AS DATE)           server_time,
            user_id,
            profile,
            village,
            JSON_EXTRACT_SCALAR(c,'$.set_name')         set_name,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_type')    reward_1_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_amount')  reward_1_amount,
            B.Spins
            
    FROM    `VIKING.EVENTS_*` A
    JOIN    (
              SELECT DISTINCT Set_Name,Spins
              FROM  `DIM.Cards` 
            ) B ON JSON_EXTRACT_SCALAR(A.c,'$.set_name')=B.Set_Name
    WHERE   _TABLE_SUFFIX >= '20190302'
    AND       event = 'set_complete_collected'
    AND       (JSON_EXTRACT_SCALAR(c,'$.active_special_event_1') = 'set_blast' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_2') = 'set_blast' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_3') = 'set_blast')

--Destination table: hallowed-forge-577:TMP.set_blast_no_extra_reward



*********************************


SELECT  server_time,
        CASE WHEN cast(reward_1_amount as int64)>cast(Spins as int64) THEN 0 ELSE 1 END Bug,
        COUNT(DISTINCT user_id) Users
FROM    TMP.set_blast_no_extra_reward
GROUP BY 1,2
