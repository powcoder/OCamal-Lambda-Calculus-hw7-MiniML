https://powcoder.com
代写代考加微信 powcoder
Assignment Project Exam Help
Add WeChat powcoder
open OUnit2
open Util
open Ast

let find_free_var_tests =
  [("2", None);
   ("2 + 3 * 5 mod 2", None);
   ("fun x -> fun y -> y * (x + 3)", None);
   ("f 2 3", Some ("f", { pos_line = 1; pos_col = 0 }));
   ("if (b && not c) && d then 1 else 2", Some ("b", { pos_line = 1; pos_col = 4 }));
   ("fun x -> y * (x + 3)", Some ("y", { pos_line = 1; pos_col = 9 }))]
  
let pretty_print_suite =
  List.map (fun (ts, _) ->
    let t = Parser.parse_from_string ts in
    let print t1 = if equal t1 t then ts else string_of_term t1 in
    let name = "string_of_term (" ^ ts ^ ")" in
    name >::
    fun tc ->
      assert_equal ~printer:print ~cmp:equal t (Parser.parse_from_string (string_of_term t)))
    find_free_var_tests
                                                         
let find_free_var_suite =
  List.map (fun (ts, res) ->
    let t = Parser.parse_from_string ts in
    let print = function
      | None -> "None"
      | Some (v, { pos_line = l; pos_col = c }) ->
          Printf.sprintf "Some (%s, { pos_line = %d; pos_col = %d })" v l c
    in
    let name = "find_free_var (" ^ ts ^ ")" in
    name >::
    fun tc ->
      assert_equal ~printer:print res (find_free_var t))
    find_free_var_tests

let subst_tests =
  ["2", "x", "2 + 3 * 5 mod 2", "2";
   "2 + 3 * 5 mod 2", "y", "2 + 3 * 5 mod 2", "2 + 3 * 5 mod 2";
   "fun x -> fun y -> y * (x + 3)", "x", "2 + 3 * 5 mod 2", "fun x -> fun y -> y * (x + 3)";
   "fun x -> fun y -> y * (x + 3)", "y", "2 + 3 * 5 mod 2", "fun x -> fun y -> y * (x + 3)";
   "f 2 3", "f", "fun x -> fun y -> y * (x + 3)", "(fun x -> fun y -> y * (x + 3)) 2 3";
   "fun y -> x * x", "x", "2", "fun y -> 2 * 2"
 ]
    
let subst_suite =
  List.map (fun (t1s, x, t2s, ress) ->
    let t1 = Parser.parse_from_string t1s in
    let t2 = Parser.parse_from_string t2s in
    let res = Parser.parse_from_string ress in
    let name = "subst (" ^ t1s ^ ") " ^ x ^ " (" ^ t2s ^ ")" in
    name >::
    fun tc ->
      assert_equal ~cmp:equal ~printer:string_of_term res (subst t1 x t2))
    subst_tests

let eval_by_name_tests =
  ["(fun x -> x + x) 2", "4";
   "(fun x y -> x y + 1) (fun x -> 2 * x) 2", "5";
   "(fun x -> 1) ((fun x -> x x) (fun x -> x x))", "1";
   "(fun f -> (fun x n -> f (x x) n) (fun x n -> f (x x) n)) (fun fac n -> if n = 0 then 1 else n * fac (n - 1)) 5", "120"
 ]
    
let eval_by_name_suite =
  List.map (fun (ts, ress) ->
    let t = Parser.parse_from_string ts in
    let res = Eval.eval_by_value (Parser.parse_from_string ress) in
    let name = "eval_by_name (" ^ ts ^ ")" in
    name >::
    fun tc ->
      assert_equal ~printer:string_of_value res (Eval.eval_by_name t))
    eval_by_name_tests


let suite =
  "Problem 2 suite" >:::
  pretty_print_suite @
  find_free_var_suite @
  subst_suite @
  eval_by_name_suite

let () = run_test_tt_main suite

