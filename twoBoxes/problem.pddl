(define (problem move)
    (:domain robot-world)
    
    (:objects 
        r1 r2 r3 - location
        robot1 - robot
    )
    
    (:init 
        (in robot1 r1)
        (connect r1 r2)
        (connect r2 r3)
        (connect r1 r3)
        (connect r2 r1)
        (connect r3 r1)
        (connect r3 r2)
        (charging_station r2)

        (=(battery-level) 100)
        (=(move-cost) 70)
    )
    
    (:goal (and 
        (in robot1 r3)
    ))
)