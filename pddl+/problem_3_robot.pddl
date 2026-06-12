(define (problem test_warehouse_three_robot)
(:domain concurrent_warehouse_official)

(:objects
    r1 r2 r3 - robot
    p1 p2 p3 - package
    l1 l2 l3 l4 l5 l6 - location
)

(:init
    (connect l1 l2) (connect l2 l1)
    (connect l4 l2) (connect l2 l4)
    (connect l2 l3) (connect l3 l2)
    (connect l3 l5) (connect l5 l3)
    (connect l4 l6) (connect l6 l4)
    
    (= (distance l1 l2) 100)
    (= (distance l2 l1) 100)
    (= (distance l4 l2) 80)
    (= (distance l2 l4) 80)
    (= (distance l2 l3) 50)
    (= (distance l3 l2) 50)
    (= (distance l3 l5) 70)
    (= (distance l5 l3) 70)
    (= (distance l4 l6) 30)
    (= (distance l6 l4) 30)
    
    (= (speed r1) 10)
    (= (speed r2) 20)
    (= (speed r3) 20)
    
    (= (distance-remaining r1) 0)
    (= (distance-remaining r2) 0)
    (= (distance-remaining r3) 0)
    
    (= (operation-timer r1) 0)
    (= (operation-timer r2) 0)
    (= (operation-timer r3) 0)
    
    (in r1 l1)
    (occupied l1)
    (robot_free r1)
    
    (in r2 l4)
    (occupied l4)
    (robot_free r2)

    (in r3 l3)
    (occupied l3)
    (robot_free r3)
    
    (in_pkg p1 l6) 
    (in_pkg p2 l2)
    (in_pkg p3 l4) 
)

(:goal
    (and

        (in_pkg p1 l3)
        (in_pkg p2 l3)
        (in_pkg p3 l5)
    )
)
)