(define (domain concurrent_warehouse)
(:requirements :strips :typing :negative-preconditions :adl :fluents :time)

(:types robot package location)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l1 ?l2 - location)
    (occupied ?l - location)
    (robot_free  ?r - robot)
    (speed ?r - robot)
    (distance ?l - location)
    (moving ?r - robot)
)


(:functions 
    (speed ?r - robot)
    (distance ?from ?to - location)
    (distance-remaining ?r - robot)
    (time-moving ?r - robot) 
)

(:action start_crossing
    :parameters (?r - robot ?from ?to - location)
    :precondition (and 
        (in ?r ?from)
        (not (in ?r ?to))
        (connect ?from ?to)
        (not (occupied ?to))
    )
    :effect (and 
        (moving ?r)
        (assign (distance-remaining ?r) (distance ?from ?to))
        (assign (time-moving ?r) 0)
    )
)

(:process crossing
    :parameters (?r - robot)
    :precondition (and
        (moving ?r)
        (> (distance-remaining ?r) 0)
    )
    :effect (and
        (decrease (distance-remaining ?r) (* #t (speed ?r)))
        (increase(time-moving ?r) (* #t 1))
    )
)

(:event arrive
    :parameters (?r - robot ?to - location)
    :precondition (and
        (moving ?r)
        (<= (distance-remaining ?r) 0)
    )
    :effect (and
        (not(moving ?r))
        (in ?r ?to)
        (assign (distance-remaining ?r) 0)
    )
)



(:action pick_up
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (in ?r ?l)
        (in_pkg ?p ?l)
        (robot_free ?r)
    )
    :effect (and 
        (carry ?r ?p)
        (not (robot_free  ?r))
        (not (in_pkg ?p ?l))
    )
)

(:action drop
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (carry ?r ?p)
        (in ?r ?l)
    )
    :effect (and 
        (not (carry ?r ?p))
        (robot_free  ?r)
        (in_pkg ?p ?l)
    )
)


)