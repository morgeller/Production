SELECT  Category,
        EXTRACT(YEAR FROM timestamp)      Year,
        EXTRACT(MONTH FROM timestamp)     Month,
        EXTRACT(QUARTER FROM timestamp)   Quarter,
        description                       Pack_Name,
        spins                             Spins,
        coins                             Coins,
        pet_food                          Pet_food,
        pet_xp                            Pet_xp,
        usd_org_price                     USD_Price,
        Used_Category,
        CASE WHEN Used_Category = 'Fully Used' AND DATE(timestamp)=DATE(FianlEndDate) THEN 'Used the same day'
             WHEN Used_Category = 'Fully Used' AND DATE_ADD(DATE(timestamp),INTERVAL 1 DAY)=DATE(FianlEndDate) THEN 'Used the day after'
        ELSE 'Else' END                   Use_Time,
        COUNT(*)                          Deposits,
        SUM(usd_org_price)                Income,
        SUM(IFNULL(Spins_Balance,0))      Spins_Inventory,
        SUM(IFNULL(Coins_Balance,0))      Coins_Inventory,
        SUM(IFNULL(Food_Balance,0))       Food_Inventory,
        SUM(IFNULL(XP_Balance,0))         XP_Inventory,
        
        IFNULL(SUM(CASE  WHEN Category IN ('Coins&Chest','Coins') THEN (usd_org_price/coins)*(IFNULL(Coins_Balance,0))
                         WHEN Category = 'Spins&Coins'            THEN (usd_org_price/2/coins)*(IFNULL(Coins_Balance,0))
                         WHEN Category = 'Spins&Coins&Xp&Chest'   THEN (usd_org_price/3/coins)*(IFNULL(Coins_Balance,0)) 
                         WHEN Category = 'Spins&Coins&Chest'      THEN (usd_org_price/2/coins)*(IFNULL(Coins_Balance,0)) 
                         END),0)      Coins_Inventory_Amount,
        
        IFNULL(SUM(CASE  WHEN Category IN ('Spins','Spins&Chest') THEN (usd_org_price/spins)*(IFNULL(Spins_Balance,0))
                         WHEN Category = 'Spins&Coins'            THEN (usd_org_price/2/spins)*(IFNULL(Spins_Balance,0)) 
                         WHEN Category = 'Spins&Coins&Xp&Chest'   THEN (usd_org_price/3/spins)*(IFNULL(Spins_Balance,0)) 
                         WHEN Category = 'Spins&Food&Xp'          THEN (usd_org_price/3/spins)*(IFNULL(Spins_Balance,0)) 
                         WHEN Category = 'Spins&Coins&Chest'      THEN (usd_org_price/2/spins)*(IFNULL(Spins_Balance,0)) 
                         WHEN Category = 'Spins&Xp'               THEN (usd_org_price/2/spins)*(IFNULL(Spins_Balance,0))
                         END),0)      Spins_Inventory_Amount,
                  
        IFNULL(SUM(CASE WHEN Category = 'Pet_Food'               THEN (usd_org_price/pet_food)*(IFNULL(Food_Balance,0)) 
                        WHEN Category = 'Spins&Food&Xp'          THEN (usd_org_price/2/pet_food)*(IFNULL(Food_Balance,0))
                        END),0)   Pet_Food_Inventory_Amount,
                  
        IFNULL(SUM(CASE WHEN Category = 'Pet_xp'                 THEN (usd_org_price/pet_xp)*(IFNULL(XP_Balance,0)) 
                        WHEN Category = 'Spins&Coins&Xp&Chest'   THEN (usd_org_price/3/pet_xp)*(IFNULL(XP_Balance,0))
                        WHEN Category = 'Spins&Food&Xp'          THEN (usd_org_price/3/pet_xp)*(IFNULL(XP_Balance,0))
                        WHEN Category = 'Spins&Xp'               THEN (usd_org_price/3/pet_xp)*(IFNULL(XP_Balance,0))
                        END),0)         Pet_xp_Inventory_Amount
        
FROM    `Finance.Final_*`
WHERE   user_id NOT IN ('B_cjiadz2mo0emfsoicakkql3d7','B_cjibj0yls00sht6jzyt6j3sff')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
