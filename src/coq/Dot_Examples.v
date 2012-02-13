(** The DOT calculus -- Examples *)

Require Export Dot_Labels.
Require Import Metatheory LibTactics_sf.
Require Export Dot_Syntax Dot_Definitions Dot_Rules.

Section Ex.

Hint Constructors wf_store wf_env wf_tp red lc_tm lc_tp lc_decl lc_args lc_decls value.
Hint Constructors vars_ok_tp valid_label.
Hint Constructors typing expands sub_tp sub_decl wf_tp wf_decl.
Hint Unfold decls_ok.

Ltac crush_rules :=
  repeat (match goal with
            | [ |- ?S |~ app (lam ?T ?B) ?V ~~> ?R ~| ?S ] => apply red_beta
            | [ |- ?E |= (lam ?T ?B) ~: _ ] => let x := fresh "x" in pick fresh x and apply typing_abs
            | [ |- ?E |= (new ?X ?Tc ?args) ~: _ ] => let x := fresh "x" in pick fresh x and apply typing_new
            | [ |- ?E |= (fvar ?X) ~: _ ] => apply typing_var
            | [ |- wf_tp ?E (tp_rfn _ _) ] => let x:= fresh "x" in pick fresh x and apply wf_rfn
            | [ |- wf_env ((?X, ?T) :: ?R, ?S) ] => rewrite_env (([(X,T)] ++ R), S); apply wf_env_cons
            | [ |- lc_tm (lam ?T ?B) ] => let x := fresh "x" in pick fresh x and apply lc_lam
            | [ |- lc_tm (new ?Tc ?A ?B) ] => let x:= fresh "x" in pick fresh x and apply lc_new
            | [ |- lc_tp (tp_rfn _ _) ] =>  let x:= fresh "x" in pick fresh x and apply lc_tp_rfn
            | [ |- lc_args ( _ :: _ ) ] => apply lc_args_cons
            | [ |- context[(?Y ^ ?X)] ] => unfold open; unfold open_rec_tm; simpl
            | [ |- context[(?Y ^^ ?X)] ] => unfold open; unfold open_rec_tm; simpl
            | [ |- context[(?Y ^ds^ ?X)] ] => unfold open_decls; simpl
            | [ |- value (lam ?T ?B) ] => apply value_lam
            | [ |- context[lbl.binds _ _ _] ] => let H:=fresh "H" in introv H; inversion H
            | [ H: (?L, _) = (?L', _) |- _ ] => inversion H; subst; simpl; split
            | [ H: False |- _ ] => inversion H
            | [ |- _ /\ _ ] => split
            | [ |- _ ] => auto
          end).

Parameter l : label.
Axiom l_value_label : value_label l.
Hint Resolve l_value_label.

Parameter Lt : label.
Axiom Lt_type_label : type_label Lt.
Hint Resolve Lt_type_label.

Definition ex1 := app (lam tp_top 0) (lam tp_top 0).
Example ex1_red : nil |~ ex1 ~~> (lam tp_top 0) ~| nil.
Proof. unfold ex1. crush_rules. Qed.

Definition ex2 := new tp_top nil 0.
Example ex2_red : exists a, nil |~ ex2 ~~> 0 ^^ (ref a) ~| ((a ~ (tp_top, nil)) ++ nil).
Proof.
  unfold ex2. pick fresh a. exists a. apply red_new; crush_rules.
Qed.

Definition ex3 := new (tp_rfn tp_top [(l, decl_tm tp_top)]) [(l, bvar 0)] (sel 0 l).
Example ex3_red : exists a, exists store', nil |~ ex3 ~~> (sel 0 l) ^^ (ref a) ~| store'.
Proof.
  unfold ex3. pick fresh a. exists a. eexists. apply red_new; crush_rules.
Qed.

Definition ex4 := new (tp_rfn tp_top [(l, decl_tm tp_top)]) [(l, lam tp_top 0)] (sel 0 l).
Example ex4_red : exists a, exists store', nil |~ ex4 ~~> (sel 0 l) ^^ (ref a) ~| store'.
Proof.
  unfold ex4. pick fresh a. exists a. eexists. apply red_new; crush_rules.
Qed.

Example ex_id_typ : (nil,nil) |= (lam tp_top 0) ~: (tp_fun tp_top tp_top).
Proof. crush_rules. Qed.

Example ex1_typ : (nil,nil) |= ex1 ~: tp_top.
Proof.
  unfold ex1. apply typing_app with (S:=tp_top) (T':=tp_fun tp_top tp_top); crush_rules.
Qed.

Example ex2_typ : (nil,nil) |= ex2 ~: tp_top.
Proof. unfold ex2. crush_rules. Qed.

Example cast_typ : (nil,nil) |= (lam tp_bot (app (lam tp_top 0) (lam (tp_sel 0 Lt) 0))) ~: tp_fun tp_bot tp_top.
Proof.
  (* yuck *)
  crush_rules. eapply typing_app; crush_rules.
  simpl. crush_rules.
  apply wf_tsel_1 with (S:=tp_top) (U:=tp_bot); crush_rules.
    replace (decl_tp tp_top tp_bot) with ((decl_tp tp_top tp_bot) ^d^ x).
    apply mem_path with (T:=tp_bot) (DS:=[(Lt, decl_tp tp_top tp_bot)]); crush_rules.
    apply expands_bot; crush_rules.
    unfold ctx_bind. simpl. crush_rules.
    unfold bot_decls. splits. unfold decls_ok. splits; crush_rules. 
    inversion H0; subst. auto.
    intros l' d H. inversion H. inversion H0; subst. apply bot_decl_tp. inversion H0.
    unfold open_decl. unfold open_rec_decl. reflexivity.
    unfold ctx_bind. simpl. crush_rules.
    apply vars_ok_tp_sel. eapply vars_ok_var. crush_rules.
Qed.

End Ex.