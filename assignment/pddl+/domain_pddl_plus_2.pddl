(define (domain concurrent_warehouse2)
(:requirements :strips :typing :negative-preconditions :adl :fluents :conditional-effects :durative-actions :continuous-effects)

(:types robot package location)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l1 ?l2 - location)
    (occupied ?l - location)
    (robot_free  ?r - robot)
    (moving ?r - robot)
    (entering ?r - robot ?l - location)
    (waiting ?r - robot ?l - location)    
)


(:functions 
    (speed ?r - robot)
    (distance-remaining ?r - robot)
    (distance ?l1 ?l2 - location) 
)

; move durative-action, move_process process, occupy process, collision event, arrive event, pick-up durative-action, drop action

(:durative-action move
    :parameters ( ?r - robot ?from ?to - location ) 
    :duration (= ?duration (/ (distance ?from ?to) (speed ?r)))
    :condition (and 
        (at start (and 
            (not (moving ?r))
            (in ?r ?from)
            (not (waiting ?r ?to))
            (not (occupied ?to))
        ))
        (over all (and 
            (connect ?from ?to)
        ))
    )
    :effect (and 
        (at start (and 
            (moving ?r)
            (not (in ?r ?from))
            (assign (distance-remaining ?r) (distance ?from ?to))
            (not (occupied ?from))
        ))
        (at end (and 
            (entering ?r ?to)            
            (not (occupied ?from))  
            (not (moving ?r))
        ))
    )
)

(:event enter
    :parameters ( ?r - robot ?l - location)
    :precondition (and 
        (entering ?r ?l)
    )
    :effect (and 
        (when (not (occupied ?l))
            (and 
                (occupied ?l)
                (not (entering ?r ?l))
                (in ?r ?l)
            )
        )
        (when (occupied ?l)
            (and 
                (waiting ?r ?l)
                (not (entering ?r ?l))
            )
        )
    )
)


(:process move_process
    :parameters (?r - robot)
    :precondition (and
        (moving ?r)
        (> (distance-remaining ?r) 0)
    )
    :effect (and
        (decrease (distance-remaining ?r) (* #t (speed ?r)))
    )
)

(:event retry-enter
    :parameters (?r - robot ?l - location)
    :precondition (and 
        (waiting ?r ?l)
        (not (occupied ?l))
    )
    :effect (and 
        (not (waiting ?r ?l))
        (in ?r ?l)
        (occupied ?l)
    )
)

(:durative-action pick-up
    :parameters (?r - robot ?l - location ?p - package)
    :duration (= ?duration 10)
    :condition (and 
        (at start (and 
            (robot_free ?r)
        ))
        (over all (and
            (in ?r ?l)
            (in_pkg ?p ?l)
        ))
    )
    :effect (and 
        (at end (and 
            (carry ?r ?p)
            (not (robot_free  ?r))
            (not (in_pkg ?p ?l))
        ))
    )
)

(:durative-action drop
    :parameters (?r - robot ?p - package ?l - location)
    :duration (= ?duration 10)
    :condition (and 
        (at start (and
            (carry ?r ?p)
        ))
        (over all (and
            (in ?r ?l)
        ))
    )
    :effect (and
        (at end (and
            (not (carry ?r ?p))
            (robot_free  ?r)
            (in_pkg ?p ?l)
        ))
    )
)

)