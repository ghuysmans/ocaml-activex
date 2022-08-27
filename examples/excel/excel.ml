open Js_of_ocaml
open Activex_js

let create () = Js.Unsafe.coerce (new%js Com.obj (Js.string "Excel.Application"))
