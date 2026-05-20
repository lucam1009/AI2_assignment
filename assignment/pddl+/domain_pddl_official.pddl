(define (domain concurrent_warehouse_official)
(:requirements :strips :typing :negative-preconditions :adl :fluents :conditional-effects :durative-actions :continuous-effects :time)

(:types robot package location)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l1 ?l2 - location)
    (occupied ?l - location)
    (robot_free  ?r - robot)
    (moving ?r - robot) 
    (blocked ?r - robot)  
)


(:functions 
    (speed ?r - robot)
    (distance-remaining ?r - robot)
    (distance ?l1 ?l2 - location) 
)

(:action start-moving
    :parameters (?r - robot ?from ?to - location )
    :precondition (and 
        (not (moving ?r))
        (in ?r ?from)
        (connect ?from ?to)
    )
    :effect (and 
        (moving ?r)
        (not (in ?r ?from))
        (assign (distance-remaining ?r) (distance ?from ?to))
        (not (occupied ?from))
    )
)


(:event enter
    :parameters ( ?r - robot ?l - location ?w - waiting-room)
    :precondition (and 
        (moving ?r)
        (not (occupied ?l))
        (<= (distance-remaining ?r) 0)
    )
    :effect (and 
        (not (moving ?r))
        (occupied ?l)
        (in ?r ?l)
    )
)

(:process move_process
    :parameters (?r - robot ?l - location)
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

(:event block
    :parameters (?r - robot ?l - location)
    :precondition (and
        (moving ?r)
        (<= (distance-remaining ?r) 0)
        (occupied ?l)
    )
    :effect (and
        (blocked ?r)
        (not (moving ?r))
    )
)

(:event unblock-and-enter
    :parameters (?r - robot ?l - location)
    :precondition (and
        (blocked ?r ?l)
        (not (occupied ?l))
    )
    :effect (and
        (not (blocked ?r ?l))
        (in ?r ?l)
        (occupied ?l)
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

