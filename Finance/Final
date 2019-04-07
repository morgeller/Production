SELECT  *,
        CASE  WHEN UPPER(Category) LIKE '%SPIN%' AND Purchase_On_Last_Event=1        THEN spins
              WHEN Used_Spins IS NULL                                                                                           THEN NULL
              WHEN Used_Spins>=spins+spins_inv                                                                                  THEN NULL
              WHEN Used_Spins<=spins_inv                                                                                        THEN spins
        ELSE spins+spins_inv-Used_Spins END                                                                                                     Spins_Balance,
            
        CASE  WHEN UPPER(Category) LIKE '%COIN%' AND Purchase_On_Last_Event=1                                                   THEN coins
              WHEN Used_Coins IS NULL                                                                                           THEN NULL
              WHEN Used_Coins>=coins+coins_inv                                                                                  THEN NULL
              WHEN Used_Coins<=coins_inv                                                                                        THEN coins
        ELSE coins+coins_inv-Used_Coins END                                                                                                     Coins_Balance,
        
        CASE  WHEN UPPER(Category) LIKE '%FOOD%' AND Purchase_On_Last_Event=1                                                   THEN pet_food
              WHEN Used_Food IS NULL                                                                                            THEN NULL
              WHEN Used_Food>=pet_food+pet_food_inv                                                                             THEN NULL
              WHEN Used_Food<=pet_food_inv                                                                                      THEN pet_food
        ELSE pet_food+pet_food_inv-Used_Food END                                                                                                Food_Balance,
        
        CASE  WHEN UPPER(Category) LIKE '%XP%' AND Purchase_On_Last_Event=1                                                     THEN pet_xp
              WHEN Used_XP IS NULL                                                                                              THEN NULL
              WHEN Used_XP>=pet_xp+pet_xp_inv                                                                                   THEN NULL
              WHEN Used_XP<=pet_xp                                                                                              THEN pet_xp
        ELSE pet_xp+pet_xp_inv-Used_XP END                                                                                                      XP_Balance,
        
        CASE  WHEN Category IN ('Spins','Coins','Wheel','Pet_Food','Pet_xp','Spins&Chest','Coins&Chest')    THEN COALESCE(Spins_Wheel_PackEnd,Coins_PackEnd,Food_PackEnd,XP_PackEnd)
              WHEN Category = 'Spins&Coins'                                                                 THEN GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd)
              WHEN Category = 'Spins&Coins&Xp&Chest'                                                        THEN GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd,XP_PackEnd)
              WHEN Category = 'Spins&Food&Xp'                                                               THEN GREATEST(Spins_Wheel_PackEnd,Food_PackEnd,XP_PackEnd)
              WHEN Category = 'Spins&Coins&Chest'                                                           THEN GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd)
              WHEN Category = 'Spins&Xp'                                                                    THEN GREATEST(Spins_Wheel_PackEnd,XP_PackEnd)
        END FianlEndDate,
        
        CASE  WHEN Category = 'Else' THEN 'No Usage'
              WHEN Category IN ('Spins','Coins','Wheel','Pet_Food','Pet_xp','Spins&Chest','Coins&Chest') AND COALESCE(Spins_Wheel_PackEnd,Coins_PackEnd,Food_PackEnd,XP_PackEnd) IS NOT NULL THEN 'Fully Used'
              WHEN Category = 'Spins&Coins'           AND GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd) IS NOT NULL THEN 'Fully Used'
              WHEN Category = 'Spins&Coins&Xp&Chest'  AND GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd,XP_PackEnd) IS NOT NULL THEN 'Fully Used'
              WHEN Category = 'Spins&Food&Xp'         AND GREATEST(Spins_Wheel_PackEnd,Food_PackEnd,XP_PackEnd) IS NOT NULL THEN 'Fully Used'
              WHEN Category = 'Spins&Coins&Chest'     AND GREATEST(Spins_Wheel_PackEnd,Coins_PackEnd) IS NOT NULL THEN 'Fully Used'
              WHEN Category = 'Spins&Xp'              AND GREATEST(Spins_Wheel_PackEnd,XP_PackEnd) IS NOT NULL THEN 'Fully Used' 
        ELSE 'Not Fully Used' END Used_Category

FROM (

SELECT    Category,
          timestamp,
          user_id,
          description,
          currency,
          usd_org_price,
          spins_inv,
          coins_inv,
          pet_food_inv,
          pet_xp_inv,
          purchase_number,
          spins,
          coins,
          pet_food,
          pet_xp,
          MIN_RT_Spend_Spins,
          MIN_RT_Spend_Coins,
          MIN_RT_Spend_Food,
          MIN_RT_Spend_XP,
          Purchase_On_Last_Event,
          MIN(CASE WHEN UPPER(Category) = 'WHEEL' THEN timestamp 
                   WHEN UPPER(Category) LIKE '%SPIN%'   AND RT_Spend_Spins-MIN_RT_Spend_Spins >= spins_inv+spins THEN U_timestamp END)      Spins_Wheel_PackEnd,
          MIN(CASE WHEN UPPER(Category) LIKE '%COIN%'   AND RT_Spend_Coins-MIN_RT_Spend_Coins >= coins_inv+coins THEN U_timestamp END)      Coins_PackEnd,
          MIN(CASE WHEN UPPER(Category) LIKE '%FOOD%'   AND RT_Spend_Food-MIN_RT_Spend_Food >= pet_food_inv+pet_food THEN U_timestamp END)  Food_PackEnd,
          MIN(CASE WHEN UPPER(Category) LIKE '%XP%'     AND RT_Spend_XP-MIN_RT_Spend_XP >= pet_xp_inv+pet_xp THEN U_timestamp END)          XP_PackEnd,
          MIN(CASE WHEN RankDesc = 1 AND UPPER(Category) LIKE '%SPIN%'  THEN RT_Spend_Spins END - MIN_RT_Spend_Spins)                       Used_Spins,
          MIN(CASE WHEN RankDesc = 1 AND UPPER(Category) LIKE '%COIN%'  THEN RT_Spend_Coins END - MIN_RT_Spend_Coins)                       Used_Coins,
          MIN(CASE WHEN RankDesc = 1 AND UPPER(Category) LIKE '%FOOD%'  THEN RT_Spend_Food END - MIN_RT_Spend_Food)                         Used_Food,
          MIN(CASE WHEN RankDesc = 1 AND UPPER(Category) LIKE '%XP%'    THEN RT_Spend_XP END - MIN_RT_Spend_XP)                             Used_XP

FROM  (
SELECT    Category,
          timestamp,
          user_id,
          description,
          currency,
          usd_org_price,
          spins_inv,
          coins_inv,
          pet_food_inv,
          pet_xp_inv,
          purchase_number,
          spins,
          coins,
          pet_food,
          pet_xp,
          CASE WHEN RankDesc = 1 THEN 1 ELSE 0 END        Purchase_On_Last_Event,
          MIN(RT_Spend_Spins)                             MIN_RT_Spend_Spins,
          MIN(RT_Spend_Coins)                             MIN_RT_Spend_Coins,
          MIN(RT_Spend_Food)                              MIN_RT_Spend_Food,
          MIN(RT_Spend_XP)                                MIN_RT_Spend_XP
FROM      `Finance.InApp_*`           A
LEFT JOIN `Finance.Usage_2019_Q1`     B ON A.user_id=B.U_user_id AND B.U_timestamp=A.timestamp AND A.coins_inv=B.U_Inv_Coins AND A.spins_inv=B.U_Inv_Spins
WHERE     _TABLE_SUFFIX >= '20190101'
AND       _TABLE_SUFFIX < '20190401'
AND       U_event = 'Purchase'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
) A
LEFT JOIN `Finance.Usage_2019_Q1`   B ON A.user_id=B.U_user_id AND B.U_timestamp>A.timestamp
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
