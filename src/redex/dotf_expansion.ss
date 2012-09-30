#lang racket
(require redex)
(require "dotf.ss")

(typecheck (term (() ())) (term
(val p = new ((rfn Top p
                   (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                   (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B))))))) in
(cast Top p))
))

(judgment-holds
 (expansion (([p (rfn Top p
                     (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                     (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B))))))])
             (((rfn Top p
                    (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                    (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B)))))))))
  z ((sel p (cc A)) ∧ (sel p (cc B))) ((DLt ...) () ()))
 (DLt ...))

(judgment-holds
 (expansion (([p (rfn Top p
                     (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                     (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B))))))])
             (((rfn Top p
                    (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                    (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B)))))))))
  z (sel p (cc A)) ((DLt ...) () ()))
 (DLt ...))

(term
 (membership-type-lookup
  (([p (rfn Top p
            (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
            (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B))))))])
   (((rfn Top p
          (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
          (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B)))))))))
  p (cc A)))

(judgment-holds
 (expansion (([p (rfn Top p
                     (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                     (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B))))))])
             (((rfn Top p
                    (: (cc A) Bot (rfn Top z (: (ca T) Bot (sel p (cc A)))))
                    (: (cc B) Bot (rfn Top z (: (ca T) Bot (sel p (cc B)))))))))
  z (rfn Top z (: (ca T) Bot (sel p (cc A)))) ((DLt ...) () ()))
 (DLt ...))

(typecheck (term (()())) (term
(val z = new (((rfn Top z
                   (: (ca A) Bot (sel z (ca B)))
                   (: (ca B) Bot Top))
               ∧
               (rfn Top z
                    (: (ca A) Bot Top)
                    (: (ca B) Bot (sel z (ca A)))))) in
(cast Top z))
))