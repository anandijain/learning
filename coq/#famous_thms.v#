

Theorem sqrt2_not_rational
 : forall p q, q <> 0 -> p * p <> q * q * 2.
 
Inductive nat : Type :=
| O : nat
| S : nat -> nat
.

Fixpoint plus(x y : nat) : nat :=
match x with 
| O => y
| S  x' => S (plus x' y)
end.

Lemma plus_0 (x : nat) : plus x O = x.

Proof.
  induction x.
  - simpl. reflexivity.
  - simpl. rewrite IHx. reflexivity.
Qed.

Lemma plus_S (x y : nat) : plus x (S y) = S (plus x y).
Proof.
  induction x.
  - simpl. reflexivity.
  - simpl. rewrite IHx. reflexivity.
Qed.

Lemma plus_com(x y : nat) : plus x y = plus y x.

Proof.
  induction x.
  - simpl. rewrite plus_0. reflexivity.
  - simpl. rewrite IHx. rewrite plus_S. reflexivity.
Qed.