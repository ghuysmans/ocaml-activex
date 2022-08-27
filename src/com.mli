open Js_of_ocaml

type obj

val obj : (Js.js_string Js.t -> obj Js.t) Js.constr

type variant =
  | Empty : variant
  | Array : _ array -> variant
  | Bool : bool -> variant
  | Float : float -> variant
  | Int : int -> variant
  | String : string -> variant
  | Object : _ Js.t -> variant

val to_variant : _ Js.t Js.Opt.t -> variant
val variant : variant -> Js.Unsafe.any
