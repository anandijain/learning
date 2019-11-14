Goal forall X Y Z : Prop, (X -> Y) -> (Y -> Z) -> (X -> Z).
Proof.
  intros X Y Z A B C. 
  apply B, A, C.
  Show Proof.
Qed.
