SELECT  event,
        cast(time as timestamp)                         user_time,
        user_id,
        JSON_EXTRACT_SCALAR(c,"$.current")              current_,
        JSON_EXTRACT_SCALAR(c,"$.required")             required,
        JSON_EXTRACT_SCALAR(c,"$.reward_0_type")        reward_0_type,
        JSON_EXTRACT_SCALAR(c,"$.reward_0_amount")      reward_0_amount
        
FROM    `VIKING.EVENTS_*`
WHERE   _TABLE_SUFFIX IN ('20190327','20190328','20190329','20190330')
AND     user_id = 'rof4__cjqpg0m8u0134g0iegds7do1m'
AND     ((event IN ('attack_raid_master_bar_progress','attack_raid_master_bar_progress')) OR (event = 'reward_collected' AND JSON_EXTRACT_SCALAR(c,"$.reward_id")='ATTACK_RAID_MASTER_REWARD'))
AND     IFNULL(JSON_EXTRACT_SCALAR(c,"$.current"),'NA')=IFNULL(JSON_EXTRACT_SCALAR(c,"$.required"),'NA')
ORDER BY 2

*******************************************************

SELECT  case when missiom_complete>reward then 1 else 0 end bug,
        *

FROM (

    SELECT  user_id,
            sum(case when event= 'attack_raid_master_bar_progress' AND JSON_EXTRACT_SCALAR(c,"$.current")=JSON_EXTRACT_SCALAR(c,"$.required") then 1 else 0 end) missiom_complete,
            sum(case when event = 'reward_collected' AND JSON_EXTRACT_SCALAR(c,"$.reward_id")='ATTACK_RAID_MASTER_REWARD' then 1 else 0 end) reward

    FROM    `VIKING.EVENTS_*`
    WHERE   _TABLE_SUFFIX IN ('20190327','20190328','20190329','20190330')
    --AND     user_id = 'rof4__cjqpg0m8u0134g0iegds7do1m'
    AND     event IN ('attack_raid_master_bar_progress','reward_collected')

    GROUP BY 1

)
--Destination table: hallowed-forge-577:TMP.attack_master_bug

*******************************************************

SELECT bug,COUNT(*)

FROM TMP.attack_master_bug
GROUP BY 1
