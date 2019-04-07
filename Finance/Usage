SELECT  *, 
        SUM(U_Spend_Spins) over (partition by U_user_id order by U_all_time_spins)                                          RT_Spend_Spins,
        SUM(U_Spend_Coins) over (partition by U_user_id order by U_all_time_spins,U_timestamp,U_U_timestamp)                RT_Spend_Coins,
        SUM(U_Spend_XP) over (partition by U_user_id order by U_all_time_spins,U_timestamp,U_U_timestamp)                   RT_Spend_XP,
        SUM(U_Spend_Food) over (partition by U_user_id order by U_all_time_spins,U_timestamp,U_U_timestamp)                 RT_Spend_Food,
        DENSE_RANK() over (partition by U_user_id order by U_all_time_spins,U_timestamp,U_U_timestamp)                      Rank,
        DENSE_RANK() over (partition by U_user_id order by U_all_time_spins DESC,U_timestamp DESC,U_U_timestamp DESC)       RankDesc
 
FROM ( 
SELECT  TIMESTAMP_MICROS(t)                                                                                                                         U_timestamp,
        time                                                                                                                                        U_U_timestamp,
        A.user_id                                                                                                                                   U_user_id,
        CASE  WHEN event = 'in_app_purchase' THEN 'Purchase' 
              WHEN event = 'pets_feed' THEN 'Pet Food'
              WHEN event = 'pets_xp' THEN 'Pet XP'
              WHEN event <> 'spin' THEN 'Spend' ELSE 'Spin' END                                                                                     U_event,
        all_time_spins                                                                                                                              U_all_time_spins,
        transactionID                                                                                                                               U_transactionID,

        spins                                                                                                                                       U_Inv_Spins,
        coins                                                                                                                                       U_Inv_Coins,
        IFNULL(CAST(JSON_EXTRACT_SCALAR(c,'$.pet_xp_bank') AS INT64),0)                                                                             U_Inv_XP,
        IFNULL((CAST(JSON_EXTRACT_SCALAR(c,'$.pet_food_bank') AS INT64)/14400000),0)                                                                U_Inv_Food,
        
        IFNULL((CASE WHEN event = 'spin' THEN CAST(REPLACE(JSON_EXTRACT_SCALAR(c,"$.bet_type"),'X','') AS INT64) ELSE 0 END),0)                     U_Spend_Spins,
        IFNULL(CASE WHEN event IN ('build','repair','chest_found','event_slot_spin') 
                      THEN IFNULL(price,CAST(REPLACE(JSON_EXTRACT_SCALAR(c,"$.bet"),'X','') AS INT64)) ELSE 0 END,0)                                U_Spend_Coins,
        CASE WHEN event = 'pets_xp' THEN amount ELSE 0 END                                                                                          U_Spend_XP,
        CASE WHEN event = 'pets_feed' THEN amount ELSE 0 END                                                                                        U_Spend_Food
FROM    `VIKING.EVENTS_*`                                                           A
JOIN    `VIKING.Account`                                                            B ON A.user_id=B.user_id
JOIN    ( SELECT user_id 
          FROM `Finance.InApp_*` 
          WHERE  _TABLE_SUFFIX >= '20190101' AND _TABLE_SUFFIX < '20190401'
          GROUP BY 1)                                                               D ON A.user_id=D.user_id
WHERE   event IN ('spin','build','repair','chest_found','event_slot_spin','in_app_purchase','pets_feed','pets_xp')
AND     _TABLE_SUFFIX >= '20190101'
AND     _TABLE_SUFFIX < '20190401'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
)
