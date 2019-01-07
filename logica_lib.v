(** Tactic library for propositional logic natural deduction *)

(** identity *)

Ltac id H := exact H.

(** Implication *)

Ltac intro_implicacao :=
  match goal with
  | [ |-  _ -> _] => let Hx := fresh "H"
                  in intro Hx
  | [ |- _ ] => fail "A conclusão não é uma implicação"          
  end.

Ltac elim_implicacao IMP LHS :=
  match type of IMP with
  | ?T -> ?R =>
    match type of LHS with
    | ?T   => let Hx := fresh "H"
             in assert (Hx : R) by (apply IMP ; exact LHS)
    | _    => fail "O lado esquerdo da implicação não é igual ao segundo parâmetro"
    end
  | _      => fail "O primeiro parâmetro não é uma implicação"
  end.


(** conjunction *)

Ltac intro_e :=
  match goal with
  | [ |- _ /\ _ ] => split
  | [ |- _ ] => fail "A conclusão não é uma conjunção"
  end.

Ltac elim_e H :=
  match type of H with
  | ?A /\ ?B => let Hx := fresh "H"
            in assert (Hx : A /\ B) by auto ; destruct Hx
  | _     => fail "O parâmetro não é uma conjunção"
  end.


(** disjunction *)

Ltac intro_ou_esq :=
  match goal with
  | [ |- _ \/ _ ] => left
  | [ |- _ ] => fail "A conclusão não é uma disjunção"
  end.

Ltac intro_ou_dir := 
  match goal with
  | [ |- _ \/ _ ] => right
  | [ |- _ ] => fail "A conclusão não é uma disjunção"
  end.

Ltac elim_ou H :=
  match type of H with
  | ?A \/ ?B => let Hx := fresh "H"
              in assert (Hx : A \/ B) by auto ; destruct Hx
  | _     => fail "O parâmetro não é uma disjunção"
  end.

(** biconditional *)

Ltac intro_bicondicional :=
  match goal with
  | [ |- _ <-> _ ] => split
  | [ |- _ ] => fail "A conclusão não é um bicondicional"
  end.

Ltac elim_bicondicional H :=
  match type of H with
  | ?A <-> ?B => let Hx := fresh "H"
              in assert (Hx : A <-> B) by auto ; destruct Hx
  | _       => fail "O parâmetro não é um bicondicional"
  end.


(** negação *)

Ltac intro_negacao :=
  match goal with
  | [ |- ~ _ ] => intro
  | _         => fail "A conclusão não é uma negação"
  end.

Ltac elim_negacao NEG POS :=
  match type of NEG with
  | ~ ?A =>
    match type of POS with
    | ?A => let Hx := fresh "H"
           in assert (Hx : ~ A) by auto ; unfold not in Hx ; specialize (Hx POS)
    | _  => fail 2 "Os parâmetros fornecidos não permitem
                   aplicar a regra de eliminação da negação"
    end
  | _    => fail "O primeiro parâmetro não é uma negação"
  end.

(** contradição *)

Ltac contradicao H := apply False_ind with (P := H).

(** reduction ad absurdum *)

Axiom RAA : forall (P : Prop), ~~ P -> P. 

Ltac raa :=
  match goal with
  | [ |- ?A ] => let Hx := fresh "H"
               in apply RAA ; intro Hx
  end.

Variables A B C : Prop.

Lemma prim_teste (H: A /\ B /\ C) : A /\ B /\ C.
Proof.
  elim_e H.
  intro_e.
  id H0.
  elim_e H1.
  intro_e.
  id H2.
  id H3.
Qed.

Lemma sec_teste (H: A \/ B \/ C) : A \/ B \/ C.
Proof.
  elim_ou H.
  intro_ou_esq.
  elim_ou H.
  intro_ou_dir.
  id H0.
  
Admitted.

Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
  assert B.
  elim_implicacao H H0.
  id H2.
  elim_implicacao H1 H2.
  id H3.
Admitted.

Lemma quar_teste(H: ~A -> A) : ~A -> A -> False.
Proof.
  intro_implicacao.
  intro_implicacao.
  elim_negacao H0 H1.
  id H2.
Admitted.

Lemma teste1 : (A -> B) -> A -> B.
Proof.
  intro_implicacao.
  intro_implicacao.
  elim_implicacao H H0.
  id H1.
Qed.

Lemma teste2 : A /\ B -> B /\ A.
Proof.
  intro_implicacao.
  intro_e.
  +
    elim_e H.
    id H1.
  +
    elim_e H.
    id H0.
Qed.

Lemma teste3 : A \/ B -> (A -> C) -> (B -> C) -> C.
Proof.
  intro_implicacao.
  intro_implicacao.
  intro_implicacao.
  elim_ou H.
  +
    elim_implicacao H0 H2.
    id H3.
  +
    elim_implicacao H1 H2.
    id H3.
Qed.

Lemma teste4 : A <-> B -> B <-> A.
Proof.
  intro_implicacao.
  elim_bicondicional H.
  intro_bicondicional.
  +
    id H1.
  +
    id H0.
Qed.

Lemma teste5 : ~ A -> A -> False.
Proof.
  intro_implicacao.
  intro_implicacao.
  elim_negacao H H0.
  id H1.
Qed.

Lemma teste6 : ~ A -> A -> False.
Proof.
  intro_implicacao.
  intro_implicacao.
  contradicao False.
  elim_negacao H H0.
  id H1.
Qed.

Lemma teste7 : (A \/ B) -> ~ A -> B.
Proof.
  intro_implicacao.
  intro_implicacao.
  elim_ou H.
  +
    contradicao B.
    elim_negacao H0 H.
    id H2.
  +
    id H1.
Qed.

Lemma teste8 : (A -> B) -> (~ A \/ B).
Proof.
  intro_implicacao.
  raa.
  assert (Ha : (~ A \/ B)).
  +
    intro_ou_esq.
    intro_negacao.
    assert(Ha1 : ~ A \/ B).
    *
      intro_ou_dir.
      elim_implicacao H H1.
      id H2.
    *
      elim_negacao H0 Ha1.
      id H2.
  +
    elim_negacao H0 Ha.
    id H1.
Qed.