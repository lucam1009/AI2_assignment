(define (domain concurrent_warehouse)
(:requirements :strips :typing :negative-preconditions)

(:types robot package location)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l1 ?l2 - location)
    (occupied ?l - location)
    (robot_free  ?r - robot)
)


(:functions 
)

(:action move
    :parameters (?r - robot ?l1 ?l2 - location)
    :precondition (and 
        (in ?r ?l1)
        (not (in ?r ?l2))
        (connect ?l1 ?l2)
        (not (occupied ?l2))
    )
    :effect (and 
        (in ?r ?l2)
        (not (in ?r ?l1))
        (occupied ?l2)
        (not (occupied ?l1))
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