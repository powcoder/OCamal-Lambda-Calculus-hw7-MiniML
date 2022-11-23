https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
(** Your solution for Problem 1 of Homework 7 *)

type ('a,'b) sum = 
  | L of 'a 
  | R of 'b

(** Write OCaml functions that satisfy the following polymorphic type signatures *)

(** f: ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c *)

let f x y z = y (x z) 

(** g: ('a * 'b -> 'c) -> 'a -> 'b -> 'c *)

let g x y z = x (y, z) 

(** h: ('a -> 'b -> 'c) -> 'a * 'b -> 'c *)

let h x (y, z) = x y z

(** i: ('a, 'b) sum * ('a -> 'c) * ('b -> 'c) -> 'c *)

let i (x, y, z) =
  match x with
  | L a -> y a
  | R b -> z b

(** j: ('a, 'b * 'c) sum -> ('a, 'b) sum * ('a, 'c) sum *)

let j x =
  match x with
  | L a -> L a, L a
  | R (b, c) -> R b, R c

