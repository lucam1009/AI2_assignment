(define (domain concurrent_warehouse)
(:requirements :strips :typing :negative-preconditions :adl :fluents :conditional-effects :durative-actions :continuous-effects)

(:types robot package location waiting-room)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l ?w - location)
    (connect-waiting ?w - waiting-room ?l - location)
    (occupied ?l - location)
    (robot_free  ?r - robot)
    (moving ?r - robot)
    (waiting ?r - robot ?w - waiting-room)    
)


(:functions 
    (speed ?r - robot)
    (distance-remaining ?r - robot)
    (distance ?l1 ?l2 - location) 
)


(:durative-action move
    :parameters ( ?r - robot ?from ?to - location ?w - waiting-room) 
    :duration (= ?duration (/ (distance ?from ?to) (speed ?r)))
    :condition (and
        (at start (not (moving ?r)))
        (at start (in ?r ?from))
        (at start (not (waiting ?r ?w)))
        (at start (not (occupied ?to)))
        (at start (connect ?from ?w))
        (at start (connect-waiting ?w ?to))
        )
    :effect (and
        (at start (moving ?r))
        (at start (not (in ?r ?from)))
        (at start (assign (distance-remaining ?r) (distance ?from ?to)))
        (at start (not (occupied ?from)))
        (at end (waiting ?r ?w))        
        (at end (not (occupied ?from)))
        (at end (not (moving ?r)))
        
    )
)

(:event enter
    :parameters ( ?r - robot ?l - location ?w - waiting-room)
    :precondition (and 
        (waiting ?r ?w)
        (not (occupied ?l))
    )
    :effect (and 
        (occupied ?l)
        (not (waiting ?r ?w))
        (in ?r ?l)
    )
)

(:durative-action leave
    :parameters (?r - robot ?l - location ?w - waiting-room)
    :duration (= ?duration 5)
    :condition (at start 
        (in ?r ?l)
    )
    :effect (at end (and 
        (not (in ?r ?l))
        (not (occupied ?l))
        (waiting ?r ?w)
    ))
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

