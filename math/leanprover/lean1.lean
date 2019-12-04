import system.io 
open io

def get_file (fn : io char_buffer): io char_buffer :=
    fs.read_file "/home/sippycups/learning/math/leanprover/" ++ fn


def hello_world : io unit :=
do s <- get_file, 
    put_str s.to_string

-- #check (@put_str : string → io unit)

-- #check(@get_line : io string)


#eval hello_world

-- theorem and_com (p q : Prop) : p ∧ q → q ∧ p :=
-- assume hpq : p ∧ q,
-- have hp : p, from and.left hpq,
-- have hq : q, from and.right hpq, 
-- show q ∧ p, from and.intro hq hp

-- inductive partial_order (n : nat, q : order)