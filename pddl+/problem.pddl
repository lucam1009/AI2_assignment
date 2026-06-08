(define (problem test_warehouse_bottleneck)
(:domain concurrent_warehouse_official)

(:objects
    r1 r2 - robot
    p1 p2 - package
    l1 l2 l3 l4 - location
)

(:init

    (connect l1 l2) (connect l2 l1)
    (connect l4 l2) (connect l2 l4)
    (connect l2 l3) (connect l3 l2)
    
    (= (distance l1 l2) 100)
    (= (distance l2 l1) 100)
    (= (distance l4 l2) 70)
    (= (distance l2 l4) 70)
    (= (distance l2 l3) 50)
    (= (distance l3 l2) 50)
    
    (= (speed r1) 10)
    (= (speed r2) 20)
    
    (= (distance-remaining r1) 0)
    (= (distance-remaining r2) 0)
    
    (= (operation-timer r1) 0)
    (= (operation-timer r2) 0)
    
    (in r1 l1)
    (occupied l1)
    (robot_free r1)
    
    (in r2 l1)
    (occupied l1)
    (robot_free r2)
    
    (in_pkg p1 l2) 
    (in_pkg p2 l2) 
)

(:goal
    (and

        (in_pkg p1 l3)
        (in_pkg p2 l3)
    )
)
)