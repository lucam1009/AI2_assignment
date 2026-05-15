(define (domain robot-world)
    (:requirements :typing)
    
    (:types robot location)
    
    (:predicates 
        (in ?r - robot ?l - location)
        (connect ?l1 - location ?l2 - location)
        (charging_station ?l - location)
    )

    (:action move
        :parameters (?r - robot ?from - location ?to - location)
        :precondition (and (in ?r ?from) (connect ?from ?to) (>= (battery-level) (move-cost)))
        :effect (and 
            (not (in ?r ?from))
            (in ?r ?to)
            (decrease (battery-level) (move-cost))
        )
    )

    (:action recharge
        :parameters (?r -robot ?l - location)
        :precondition (and(in ?r ?l) (charging_station ?l))
        :effect (and 
            (assign(battery-level) 100)
        )
    )

)