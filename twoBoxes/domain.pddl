(define (domain box-world)
    (:requirements :typing)
    
    (:types box)
    
    (:predicates 
        (on ?x - box ?y - box)      ; Box x is on top of Box y
        (ontable ?x - box)          ; Box x is on the table
        (clear ?x - box)            ; Nothing is on top of Box x
        (handempty)                 ; The robotic hand is empty
        (holding ?x - box)          ; The robotic hand is holding Box x
    )

    ;; Action to pick up a box from the table
    (:action pick-up
        :parameters (?x - box)
        :precondition (and (clear ?x) (ontable ?x) (handempty))
        :effect (and 
            (not (ontable ?x))
            (not (clear ?x))
            (not (handempty))
            (holding ?x)
        )
    )

    ;; Action to put a box down on the table
    (:action put-down
        :parameters (?x - box)
        :precondition (holding ?x)
        :effect (and 
            (not (holding ?x))
            (clear ?x)
            (handempty)
            (ontable ?x)
        )
    )

    ;; Action to unstack a box from another box
    (:action unstack
        :parameters (?x - box ?y - box)
        :precondition (and (on ?x ?y) (clear ?x) (handempty))
        :effect (and 
            (holding ?x)
            (clear ?y)
            (not (clear ?x))
            (not (handempty))
            (not (on ?x ?y))
        )
    )

    ;; Action to stack a box on top of another box
    (:action stack
        :parameters (?x - box ?y - box)
        :precondition (and (holding ?x) (clear ?y))
        :effect (and 
            (not (holding ?x))
            (not (clear ?y))
            (clear ?x)
            (handempty)
            (on ?x ?y)
        )
    )
)