SELECT  reward_1_type,
        reward_1_amount,
        SUBSTR(reward_4_type,0,4) reward_4_type,
        reward_4_amount,
        COUNT(*) N
FROM    (

    SELECT  user_id,
            JSON_EXTRACT_SCALAR(c,'$.missions_total') missions_total,
            JSON_EXTRACT_SCALAR(c,'$.mission_completed') mission_completed,

            JSON_EXTRACT_SCALAR(c,'$.reward_0_type')    reward_0_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_0_amount')  reward_0_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_type')    reward_1_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_amount')  reward_1_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_type')    reward_2_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_amount')  reward_2_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_type')    reward_3_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_amount')  reward_3_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_type')    reward_4_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_amount')  reward_4_amount

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    AND     event IN ('event_slot_reward_collected')
    AND     CAST(JSON_EXTRACT_SCALAR(c,'$.mission_completed') AS INT64) = 10

)
GROUP BY 1,2,3,4


**********************************************************************


SELECT  profile,
        CASE WHEN reward_1_amount = '5000' THEN 1 ELSE 0 END Bug,
        COUNT(*) N
FROM    (

    SELECT  user_id,
            profile,
            JSON_EXTRACT_SCALAR(c,'$.missions_total') missions_total,
            JSON_EXTRACT_SCALAR(c,'$.mission_completed') mission_completed,

            JSON_EXTRACT_SCALAR(c,'$.reward_0_type')    reward_0_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_0_amount')  reward_0_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_type')    reward_1_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_amount')  reward_1_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_type')    reward_2_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_amount')  reward_2_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_type')    reward_3_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_amount')  reward_3_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_type')    reward_4_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_amount')  reward_4_amount

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    AND     event IN ('event_slot_reward_collected')
    AND     CAST(JSON_EXTRACT_SCALAR(c,'$.mission_completed') AS INT64) = 10

)
GROUP BY 1,2


**********************************************************************

SELECT  profile,
        CASE WHEN reward_1_amount = '5000' THEN 1 ELSE 0 END Bug,
        COUNT(*) N
FROM    (

    SELECT  user_id,
            profile,
            JSON_EXTRACT_SCALAR(c,'$.missions_total') missions_total,
            JSON_EXTRACT_SCALAR(c,'$.mission_completed') mission_completed,

            JSON_EXTRACT_SCALAR(c,'$.reward_0_type')    reward_0_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_0_amount')  reward_0_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_type')    reward_1_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_1_amount')  reward_1_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_type')    reward_2_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_2_amount')  reward_2_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_type')    reward_3_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_3_amount')  reward_3_amount,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_type')    reward_4_type,
            JSON_EXTRACT_SCALAR(c,'$.reward_4_amount')  reward_4_amount

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190319','20190320')
    AND     event IN ('event_slot_reward_collected')
    AND     CAST(JSON_EXTRACT_SCALAR(c,'$.mission_completed') AS INT64) = 10

)
GROUP BY 1,2
