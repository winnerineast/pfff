(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open Common

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* The AST related types *)
(*****************************************************************************)

(* ------------------------------------------------------------------------- *)
(* Token/info *)
(* ------------------------------------------------------------------------- *)
type info = Parse_info.info
and tok = info

(* a shortcut to annotate some information with token/position information *)
and 'a wrap = 'a * info

and 'a paren   = tok * 'a * tok
and 'a brace   = tok * 'a * tok
and 'a bracket = tok * 'a * tok 

and 'a comma_list = ('a, tok (* ',' *)) Common.either list
and 'a and_list = ('a, tok (* 'and' *)) Common.either list
and 'a pipe_list = ('a, tok (* '*' *)) Common.either list

and 'a semicolon_list = ('a, tok (* ';' *)) Common.either list
and 'a star_list = ('a, tok (* '*' *)) Common.either list

 (* with tarzan *)

(* ------------------------------------------------------------------------- *)
(* Names  *)
(* ------------------------------------------------------------------------- *)
type name = Name of string wrap

  (* lower and uppernames aliases, just for clarity *)
  and lname = name
  and uname = name

 (* with tarzan *)

type long_name = qualifier * name
 and qualifier = (name * tok (*'.'*)) list

 (* with tarzan *)

(* ------------------------------------------------------------------------- *)
(* Types *)
(* ------------------------------------------------------------------------- *)

type ty = 
  | TyName of long_name
  | TyVar of tok (* ' *) * name
  | TyTuple of ty star_list (* at least 2 *)
  | TyFunction of ty * tok (* -> *) * ty
  | TyApp of ty_args * long_name (* todo? could be merged with TyName *)

  | TyTodo


and type_declaration =
  | TyAbstract of ty_params * name
  | TyDef of ty_params * name * tok (* = *) * type_def_kind

 and type_def_kind =
   | TyCore of ty
   | TyAlgebric of constructor_declaration pipe_list (* optional first | *)
   | TyRecord   of label_declaration semicolon_list (* optional final ; *) brace

 (* OR type: algebric data type *)
 and constructor_declaration = name (* constr_ident *) * constructor_arguments
  and constructor_arguments =
    | NoConstrArg
    | Of of tok * ty star_list

 (* AND type: record *)
 and label_declaration = {
   fld_mutable: tok option;
   fld_name: name;
   fld_tok: tok; (* : *)
   fld_type: ty; (* poly_type ?? *)
 }



 and ty_args = 
    | TyArg1 of ty
    | TyArgMulti of ty comma_list paren
    (* todo? | TyNoArg and merge TyName and TyApp ? *)

 and ty_params =
   | TyNoParam
   | TyParam1 of ty_parameter
   | TyParamMulti of ty_parameter comma_list paren
 and ty_parameter = tok (* ' *) * name (* a TyVar *)


(* ------------------------------------------------------------------------- *)
(* Expressions *)
(* ------------------------------------------------------------------------- *)
and expr = unit

(* optional final ';' as terminator *)
and seq_expr = expr semicolon_list

(* ------------------------------------------------------------------------- *)
(* Patterns *)
(* ------------------------------------------------------------------------- *)
and pattern = unit

and simple_pattern = unit

(* rename in parameter ? *)
and labeled_simple_pattern = unit


(* ------------------------------------------------------------------------- *)
(* Let binding *)
(* ------------------------------------------------------------------------- *)

and let_binding =
  | LetClassic of let_def
  | LetPattern of pattern * tok (* = *) * seq_expr

 (* was called fun_binding in the grammar *)
 and let_def = {
   l_name: name; (* val_ident *)
   l_args: labeled_simple_pattern list; (* can be empty *)
   l_tok: tok; (* = *)
   l_body: seq_expr;
 }

(* ------------------------------------------------------------------------- *)
(* Function binding *)
(* ------------------------------------------------------------------------- *)
 
and function_def = unit

(* ------------------------------------------------------------------------- *)
(* Module *)
(* ------------------------------------------------------------------------- *)
and module_type = unit

and module_expr = unit
(* ------------------------------------------------------------------------- *)
(* Class *)
(* ------------------------------------------------------------------------- *)

(* ------------------------------------------------------------------------- *)
(* Signature/Structure items *)
(* ------------------------------------------------------------------------- *)

(* could split in sig_item and struct_item but many constructions are
 * valid in both contexts.
 *)
and item = 
  | Type      of tok * type_declaration and_list
  | Exception of tok * name * constructor_arguments
  | External  of tok * name (* val_ident *) * tok (*:*) * ty * tok (* = *) *
      string wrap list (* primitive declarations *)
      
  | Open of tok * long_name
      
  (* only in sig_item *)
  | Val of tok * name (* val_ident *) * tok (*:*) * ty
      
  (* only in struct_item *)
  | Let of tok * rec_opt * let_binding and_list
      
  | ItemTodo

and sig_item = item
and struct_item = item

  and rec_opt = tok option

(* ------------------------------------------------------------------------- *)
(* Toplevel phrases *)
(* ------------------------------------------------------------------------- *)

and toplevel =
  | Item of item

  (* should both be removed *)
  | ScSc of info (* ;; *)
  | TopSeqExpr of seq_expr

  | NotParsedCorrectly of info list
  | FinalDef of info (* EOF *)

 and program = toplevel list

 (* with tarzan *)


(*****************************************************************************)
(* Wrappers *)
(*****************************************************************************)

let str_of_info x = Parse_info.str_of_info x
let col_of_info x = Parse_info.col_of_info x
let line_of_info x = Parse_info.line_of_info x
let pos_of_info x = Parse_info.pos_of_info x
