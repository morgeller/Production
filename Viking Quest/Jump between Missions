
SELECT  user_id,
        COALESCE(CASE WHEN event = 'event_slot_reward_collected' THEN JSON_EXTRACT_SCALAR(c,"$.mission_completed") END,
                  CASE WHEN event = 'event_slot_spin' THEN JSON_EXTRACT_SCALAR(c,"$.mission_current") END,
                      CASE WHEN event = 'event_vqst_mission_complete' THEN JSON_EXTRACT_SCALAR(c,"$.mission") END) mission,
        
        IFNULL(COUNT(DISTINCT CASE WHEN event = 'event_vqst_mission_complete' THEN cast(JSON_EXTRACT_SCALAR(c,"$.mission") as int64) END),0)    event_vqst_mission_complete,
        IFNULL(COUNT(DISTINCT CASE WHEN event = 'event_slot_reward_collected' THEN cast(JSON_EXTRACT_SCALAR(c,"$.mission_completed") as int64) END),0)    event_slot_reward_collected,
        MAX(CASE WHEN event = 'event_slot_spin' THEN 1 ELSE 0 END)                event_slot_spin
FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
AND     event IN ('event_slot_reward_collected','event_slot_spin','event_vqst_mission_complete')
GROUP BY 1,2
ORDER BY 1,2

-- TMP.vq_jump_between_the_mission

****************************************************************


SELECT * FROM (
    SELECT  user_id,
            sum(event_vqst_mission_complete) event_vqst_mission_complete,
            sum(case when event_slot_spin>0 then 1 else 0 end) event_slot_spin

    FROM    TMP.vq_jump_between_the_mission
    WHERE   event_vqst_mission_complete>0
    --AND     event_slot_spin=0
    GROUP BY 1
    
)
WHERE event_vqst_mission_complete>event_slot_spin
ORDER BY event_slot_spin DESC

****************************************************************


SELECT  COALESCE(CASE WHEN event = 'event_slot_reward_collected' THEN JSON_EXTRACT_SCALAR(c,"$.mission_completed") END,
                  CASE WHEN event = 'event_slot_spin' THEN JSON_EXTRACT_SCALAR(c,"$.mission_current") END,
                      CASE WHEN event = 'event_vqst_mission_complete' THEN JSON_EXTRACT_SCALAR(c,"$.mission") END) mission,
        
        *
FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
AND     user_id = 'B_cjceuf4il00kwsxm2rwnfyn6t'
