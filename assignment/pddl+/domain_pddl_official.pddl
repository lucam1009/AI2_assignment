(define (domain concurrent_warehouse_official)
(:requirements :strips :typing :negative-preconditions :adl :fluents :conditional-effects :continuous-effects)

(:types robot package location)

(:predicates
    (carry ?r - robot ?p - package)
    (in ?r - robot ?l - location)
    (in_pkg ?p - package ?l - location)
    (connect ?l1 ?l2 - location)
    (occupied ?l - location)
    (robot_free ?r - robot)
    (moving ?r - robot ?to - location) 
    (blocked ?r - robot ?to - location) 
    (busy ?r - robot)
    (picking ?r - robot ?p - package ?l - location)
    (dropping ?r - robot ?p - package ?l - location)
)

(:functions 
    (speed ?r - robot)
    (distance-remaining ?r - robot)
    (distance ?l1 ?l2 - location) 
    (operation-timer ?r - robot)
)

(:action start-moving
    :parameters (?r - robot ?from ?to - location )
    :precondition (and 
        (in ?r ?from)
        (connect ?from ?to)
        (not (busy ?r))
    )
    :effect (and 
        (moving ?r ?to)
        (not (in ?r ?from))
        (assign (distance-remaining ?r) (distance ?from ?to))
        (not (occupied ?from))
    )
)

(:event enter
    :parameters ( ?r - robot ?l - location)
    :precondition (and 
        (moving ?r ?l)
        (not (occupied ?l))
        (<= (distance-remaining ?r) 0)
    )
    :effect (and 
        (not (moving ?r ?l))
        (occupied ?l)
        (in ?r ?l)
    )
)

(:process move_process
    :parameters (?r - robot ?l - location)
    :precondition (and
        (moving ?r ?l)
        (> (distance-remaining ?r) 0)
    )
    :effect (and
        (decrease (distance-remaining ?r) (* #t (speed ?r)))
    )
)

(:action block
    :parameters (?r - robot ?l - location)
    :precondition (and
        (moving ?r ?l)
        (<= (distance-remaining ?r) 0)
        (occupied ?l)
    )
    :effect (and
        (blocked ?r ?l)
        (not (moving ?r ?l))
    )
)

(:action unblock-and-enter
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

(:action start-pick-up
    :parameters (?r - robot ?l - location ?p - package)
    :precondition (and 
        (robot_free ?r)
        (not (busy ?r))
        (in ?r ?l)
        (in_pkg ?p ?l)
    )
    :effect (and 
        (busy ?r)
        (picking ?r ?p ?l)
        (assign (operation-timer ?r) 0)
    )
)

(:process picking_process
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (picking ?r ?p ?l))
    :effect (and (increase (operation-timer ?r) (* #t 1)))
)

(:event end-pick-up
    :parameters (?r - robot ?l - location ?p - package)
    :precondition (and
        (picking ?r ?p ?l)
        (>= (operation-timer ?r) 100)
    )
    :effect (and
        (not (picking ?r ?p ?l))
        (not (busy ?r))
        (carry ?r ?p)
        (not (robot_free ?r))
        (not (in_pkg ?p ?l))
    )
)

(:action start-drop
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and 
        (carry ?r ?p)
        (not (busy ?r))
        (in ?r ?l)
    )
    :effect (and
        (busy ?r)
        (dropping ?r ?p ?l)
        (assign (operation-timer ?r) 0)
    )
)

(:process dropping_process
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and (dropping ?r ?p ?l))
    :effect (and (increase (operation-timer ?r) (* #t 1)))
)

(:event end-drop
    :parameters (?r - robot ?p - package ?l - location)
    :precondition (and
        (dropping ?r ?p ?l)
        (>= (operation-timer ?r) 10)
    )
    :effect (and
        (not (dropping ?r ?p ?l))
        (not (busy ?r))
        (not (carry ?r ?p))
        (robot_free ?r)
        (in_pkg ?p ?l)
    )
)

)