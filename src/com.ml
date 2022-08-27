open Js_of_ocaml

type obj

class type winax = object
  method _Object : (Js.js_string Js.t -> obj Js.t) Js.constr Js.prop
  (* TODO handle options *)
  (* TODO variant wrapper constructor *)
end

external winax : unit -> winax Js.t = "caml_get_winax"

let obj = (winax ())##._Object

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
