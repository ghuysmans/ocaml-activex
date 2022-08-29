open Js_of_ocaml

type obj

val obj : (Js.js_string Js.t -> obj Js.t) Js.constr
val get_object : string -> obj Js.t

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

module IEnumVARIANT : sig
  class type ['a] t = object
    method _Next : 'a Js.opt Js.meth
  end
  val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b #t Js.t -> 'a
  val iter : ('a -> unit) -> 'a #t Js.t -> unit
end

module EnumerableMeth : sig
  class type ['a] t = object
    method __NewEnum : 'a IEnumVARIANT.t Js.t Js.meth
  end
  val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b #t Js.t -> 'a
  val iter : ('a -> unit) -> 'a #t Js.t -> unit
end

module EnumerableProp : sig
  class type ['a] t = object
    method __NewEnum : 'a IEnumVARIANT.t Js.t Js.readonly_prop
  end
  val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b #t Js.t -> 'a
  val iter : ('a -> unit) -> 'a #t Js.t -> unit
end
