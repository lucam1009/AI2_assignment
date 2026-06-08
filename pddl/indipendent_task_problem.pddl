(define (problem indipendent_task) 
    (:domain concurrent_warehouse)
(:objects
    r1 r2 - robot
    l1 l2 l3 l4 - location
    p1 p2 - package
)

(:init
    (in r1 l1)
    (in r2 l2)
    (in_pkg p1 l3)
    (in_pkg p2 l4)
    (connect l1 l3)
    (connect l3 l1)
    (connect l2 l4)
    (connect l4 l2)
    (occupied l1)
    (occupied l2)
    (not (occupied l3))
    (not (occupied l4))
    (robot_free r1)
    (robot_free  r2)
)

(:goal (and
    (in_pkg p1 l1)
    (in_pkg p2 l2)
))

)
