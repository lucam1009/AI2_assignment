(define (problem concurrent_task) (:domain concurrent_warehouse)
(:objects 
    r1 r2 - robot
    l1 l2 l3 l4 l5 l6 - location
    p1 p2 p3 - package
)

(:init
    (in r1 l1)
    (in r2 l2)
    (in_pkg p1 l6)
    (in_pkg p2 l4)
    (in_pkg p3 l6)
    (connect l1 l3)
    (connect l3 l5)
    (connect l5 l6)
    (connect l6 l4)
    (connect l4 l2)
    (connect l2 l1)
    (connect l2 l4)
    (connect l4 l3)
    (connect l3 l1)
    (connect l1 l2)
    (occupied l1)
    (occupied l2)
    (not (occupied l3))
    (not (occupied l4))
    (not (occupied l5))
    (not (occupied l6))
    (robot_free  r1)
    (robot_free  r2)

)

(:goal (and
    (in_pkg p1 l1)
    (in_pkg p2 l2)
    (in_pkg p3 l5)
))

)
