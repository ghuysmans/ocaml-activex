open Js_of_ocaml

type obj

class type winax = object
  method _Object : (Js.js_string Js.t -> obj Js.t) Js.constr Js.prop
  method _Object_opt : (Js.js_string Js.t -> _ Js.t -> obj Js.t) Js.constr Js.prop
  (* TODO variant wrapper constructor *)
end

external winax : unit -> winax Js.t = "caml_get_winax"

let obj = (winax ())##._Object

let get_object x =
  let c = (winax ())##._Object_opt in
  new%js c (Js.string x) (object%js val getobject = Js._true end)

type variant =
  | Empty : variant
  | Array : _ array -> variant
  | Bool : bool -> variant
  | Float : float -> variant
  | Int : int -> variant
  | String : string -> variant
  | Object : _ Js.t -> variant

let variant = function
  | Empty -> Js.Unsafe.inject Js.null
  | Array a -> Js.Unsafe.inject (Js.array a)
  | Bool b -> Js.Unsafe.inject (Js.bool b)
  | Float f -> Js.Unsafe.inject f
  | Int i -> Js.Unsafe.inject i
  | String s -> Js.Unsafe.inject (Js.string s)
  | Object o -> Js.Unsafe.inject o

let to_variant x =
  Js.Opt.case x (fun () -> Empty) (fun x ->
    if Js.instanceof x Js.Unsafe.global##._Array then
      Array (Js.to_array (Js.Unsafe.coerce x))
    else if Js.typeof x == Js.string "boolean" then
      Bool (Js.to_bool (Js.Unsafe.coerce x))
    else if Js.typeof x == Js.string "string" then
      String (Js.to_string (Js.Unsafe.coerce x))
    else if Js.typeof x == Js.string "number" then
      let f = Js.float_of_number (Js.Unsafe.coerce x) in
      if floor f = f then
        Int (int_of_float f)
      else
        Float f
    else
      Object x
  )

module IEnumVARIANT = struct
  class type ['a] t = object
    method _Next : 'a Js.Opt.t Js.meth
  end

  let rec fold_left f init (o : _ #t Js.t) =
    match Js.Opt.to_option o##_Next with
    | None -> init
    | Some x -> fold_left f (f init x) o

  let iter f o =
    fold_left (fun () x -> f x) () o
end

module EnumerableMeth = struct
  class type ['a] t = object
    method __NewEnum : 'a IEnumVARIANT.t Js.t Js.meth
  end

  let fold_left f init o = IEnumVARIANT.fold_left f init o##__NewEnum
  let iter f o = IEnumVARIANT.iter f o##__NewEnum
end

module EnumerableProp = struct
  class type ['a] t = object
    method __NewEnum : 'a IEnumVARIANT.t Js.t Js.readonly_prop
  end

  let fold_left f init o = IEnumVARIANT.fold_left f init o##.__NewEnum
  let iter f o = IEnumVARIANT.iter f o##.__NewEnum
end

type 'a proxy = < ___value_: 'a Js.readonly_prop > Js.t
type 'a readonly_prop = 'a proxy Js.readonly_prop
type 'a writeonly_prop = 'a Js.writeonly_prop
type 'a prop = < get : 'a proxy ; set : 'a -> unit > Js.gen_prop
type 'a optdef_prop = < get : 'a Js.optdef proxy ; set : 'a -> unit > Js.gen_prop
