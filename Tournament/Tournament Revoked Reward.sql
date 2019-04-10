Tournament Revoked Reward

--usre check: 

    SELECT  event,
            user_id,
            time,
            server_time,
            all_time_spins,
            profile,
            village,
            spins,
            coins,
            source,
            JSON_EXTRACT_SCALAR(c,'$.bet')                    bet,
            JSON_EXTRACT_SCALAR(c,'$.reward_id')              reward_id,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_0_type')  reward_0_type,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_0_amount')reward_0_amount,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_1_type')  reward_1_type,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_1_amount')reward_1_amount,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_2_type')  reward_2_type,
            JSON_EXTRACT_SCALAR(c,'$.rewards.reward_2_amount')reward_2_amount
            
    FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`
    WHERE   server_time >= '2019-04-07' AND server_time < '2019-04-08'
    AND     (user_id = 'rof4__cjr81sd5r007qw5l84kpsnxzu' /*OR attackedPerson = 'rof5__cjsf7cgc8045x8zlf2jzt41ey'*/)
    AND     event not in ('gifts_coins_collected','gifts_spins_collected','fb_found_friends','asset_bundle_download_finished','asset_bundle_download_started','gifts_coins_sent','gifts_spins_sent',
                          'gifts_popup_closed','gifts_popup_opened','retro_pay_fix','build_pay3','fb_friend_joined','fb_friend_joined_no_reward')
    ORDER BY time


--user_list:

    SELECT  A.user_id,        
            max(case when event = 'tourn_final_leaderboard_popup_closed' then spins end) spins_inv_before,
            max(case when event = 'tourn_final_leaderboard_popup_closed' then coins end) coins_inv_before,
            
            max(case when event = 'tourn_reward_collected' then spins end) spins_inv_reward,
            max(case when event = 'tourn_reward_collected' then coins end) coins_inv_reward,
            
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_0_type'))  reward_0_type,
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_0_amount'))reward_0_amount,
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_1_type'))  reward_1_type,
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_1_amount'))reward_1_amount,
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_2_type'))  reward_2_type,
            max(JSON_EXTRACT_SCALAR(c,'$.rewards.reward_2_amount'))reward_2_amount,
            
            max(time) max_tour_date_user,
            max(server_time) max_tour_date,
            
            sum(case when event = 'tourn_reward_collected' then 1 else 0 end) rewards
            
    FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY` A
    JOIN    (
                SELECT  user_id,
                        max(server_time) B_server_time
                FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`
                WHERE   server_time >= '2019-04-05' AND server_time < '2019-04-08' 
                AND     event = 'tournament_action_progress'
                AND     JSON_EXTRACT_SCALAR(c,'$.event_id') = 'tournaments_2019-04-05T08:05'
                GROUP BY 1
    
            ) B ON A.user_id=B.user_id AND A.server_time>=B.B_server_time
    WHERE   server_time >= '2019-04-07' AND server_time < '2019-04-08' 
    AND     (event in ('tourn_final_leaderboard_popup_closed','tourn_final_leaderboard_popup_closed','tourn_reward_collected'))
    GROUP BY 1

--Destination table: hallowed-forge-577:TMP.tour_max_date_rev


SELECT  user_id,
        case when reward_0_type='spins' then reward_0_amount
             when reward_1_type='spins' then reward_1_amount
             when reward_2_type='spins' then reward_2_amount
        end spins_reward,
        spins_inv_reward,
        spins_inv_before    spins_before,
        spins               spins_after,
        case when reward_0_type='coins' then reward_0_amount
             when reward_1_type='coins' then reward_1_amount
             when reward_2_type='coins' then reward_2_amount
        end coins_reward,
        coins_inv_reward,
        coins_inv_before    coins_before,
        coins               coins_after,
        max_tour_date_user
        
FROM (

    SELECT  B.*,
            spins,
            coins,
            ROW_NUMBER() OVER (Partition by A.user_id order by time) rownum
            
    FROM    `streamingdata.CM_STR_EVENT.EVENT_STREAM_PROD_LEGACY`   A
    JOIN    `TMP.tour_max_date_rev`                                 B ON A.user_id=B.user_id AND time>max_tour_date_user
    WHERE   server_time >= '2019-04-07' AND server_time < '2019-04-08' 
    AND     (source <> 'TournamentRewardPopup' or source is null)
    AND     event NOT LIKE '%tourn%'
    AND     event NOT IN ('network_error','super_bet_upgrade','asset_bundle_download_finished','asset_bundle_download_started','set_complete_opened','set_complete_collected')
    AND     spins IS NOT NULL
    AND     rewards = 1
)
WHERE rownum=2

--Destination table: hallowed-forge-577:TMP.tour_max_date_rev_2



SELECT  case when spins_after<=spins_before+5 then 1 else 0 end bug,
        count(*) n
FROM    TMP.tour_max_date_rev_2
WHERE   cast(spins_reward as int64) > 0
AND     spins_before IS NOT NULL
GROUP BY 1
