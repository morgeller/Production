SELECT  user_id,
        sum(cast(REPLACE(JSON_EXTRACT_SCALAR(c,"$.bet"),'X','') as int64))  raid_count,
        sum(case when JSON_EXTRACT_SCALAR(c,"$.current")=JSON_EXTRACT_SCALAR(c,"$.required") then 1 else 0 end) complete,
        count(distinct case when event = 'event_attack_raid_master_collected' then c end) rewards_collected,
        count(distinct case when event = 'event_attack_raid_master_collected' then 
              IFNULL(cast(JSON_EXTRACT_SCALAR(c,'$.reward_coins') as int64),0)+
              IFNULL(cast(JSON_EXTRACT_SCALAR(c,'$.reward_spins') as int64),0)+
              IFNULL(cast(JSON_EXTRACT_SCALAR(c,'$.reward_pet_xp_bank') as int64),0)
              
              end) dis_rewards_collected

FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY
WHERE   server_time >= '2019-04-04' AND server_time < '2019-04-08'
AND     event IN('attack_raid_master_bar_progress','event_attack_raid_master_collected','raid_end','reward_collected')
AND     (JSON_EXTRACT_SCALAR(c,'$.active_special_event_1') = 'raid_master' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_2') = 'raid_master' OR JSON_EXTRACT_SCALAR(c,'$.active_special_event_3') = 'raid_master')
--AND     user_id = 'B_cjjuyhvkm0mmds2jxb9ef8tof'
GROUP BY 1

--Destination table: hallowed-forge-577:TMP.attack_master_reset


select *

from TMP.attack_master_reset

where dis_rewards_collected<rewards_collected





SELECT  user_id,
        time,
        server_time,
        event,
        coins,
        spins,
        JSON_EXTRACT_SCALAR(c,"$.bet")                bet,
        JSON_EXTRACT_SCALAR(c,'$.reward_coins')       reward_coins,
        JSON_EXTRACT_SCALAR(c,'$.reward_spins')       reward_spins,
        JSON_EXTRACT_SCALAR(c,'$.reward_pet_xp_bank') reward_pet_xp_bank,
        JSON_EXTRACT_SCALAR(c,"$.current")            current_,
        JSON_EXTRACT_SCALAR(c,"$.required")           required,
        c
FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY
WHERE   server_time >= '2019-04-04' AND server_time < '2019-04-08'
AND     event IN('attack_raid_master_bar_progress','event_attack_raid_master_collected','raid_end','reward_collected')
AND     user_id = 'B_cjcc49fly0027ikm9wkchps3z'
--GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 2,3



SELECT  user_id,
        time,
        server_time,
        event,
        coins,
        spins
FROM    streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY
WHERE   server_time >= '2019-04-05' AND server_time < '2019-04-06'
AND     attackedPerson = 'B_cjcc49fly0027ikm9wkchps3z'
ORDER BY 2,3


