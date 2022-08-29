open Js_of_ocaml
open Activex_js

let () =
  let f = Js.Unsafe.coerce (new%js Com.obj (Js.string "Scripting.FileSystemObject")) in
  f##._Drives |> Com.EnumerableProp.iter (fun x ->
    print_endline @@ "drive " ^ (Js.to_string x##._DriveLetter)
  );
  let d = Js.Unsafe.coerce (new%js Com.obj (Js.string "Scripting.Dictionary")) in
  let () = d##_Add (Js.string "k") (Js.string "v") in
  d |> Com.EnumerableMeth.iter (fun x ->
    print_endline @@ "key " ^ (Js.to_string x)
  );
