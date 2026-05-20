(define (problem test_warehouse_bottleneck)
(:domain concurrent_warehouse_official)

(:objects
    r1 r2 - robot
    p1 p2 - package
    l1 l2 l3 l4 - location
)

(:init
    ;; --- TOPOLOGIA DELLA MAPPA ---
    ;; l2 è il "collo di bottiglia". l1 e l4 portano a l2. Solo l2 porta a l3.
    (connect l1 l2) (connect l2 l1)
    (connect l4 l2) (connect l2 l4)
    (connect l2 l3) (connect l3 l2)
    
    ;; --- DISTANZE ---
    (= (distance l1 l2) 100)
    (= (distance l2 l1) 100)
    (= (distance l4 l2) 80)
    (= (distance l2 l4) 80)
    (= (distance l2 l3) 50)
    (= (distance l3 l2) 50)
    
    ;; --- VELOCITA' DEI ROBOT ---
    ;; r2 è due volte più veloce, quindi arriverà all'incrocio per primo
    (= (speed r1) 10)
    (= (speed r2) 20)
    
    ;; --- INIZIALIZZAZIONE VARIABILI NUMERICHE ---
    (= (distance-remaining r1) 0)
    (= (distance-remaining r2) 0)
    
    ;; I timer necessari per il nuovo sistema di pick-up/drop senza durative actions
    (= (operation-timer r1) 0)
    (= (operation-timer r2) 0)
    
    ;; --- STATO INIZIALE ROBOT 1 ---
    (in r1 l1)
    (occupied l1)
    (robot_free r1)
    
    ;; --- STATO INIZIALE ROBOT 2 ---
    (in r2 l1)
    (occupied l1)
    (robot_free r2)
    
    ;; --- STATO INIZIALE DEI PACCHI ---
    (in_pkg p1 l2) 
    (in_pkg p2 l2) 
)

(:goal
    (and
        ;; Obiettivo: entrambi i pacchi devono trovarsi nella stanza l3 alla fine
        (in_pkg p1 l3)
        (in_pkg p2 l3)
    )
)
)