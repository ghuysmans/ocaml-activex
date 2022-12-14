open Js_of_ocaml
open Activex_js

[@@@warning "-21"]
let () =
  let conn = Js.Unsafe.coerce (new%js Com.obj (Js.string "ADODB.Connection")) in
  conn##_open (Js.string Sys.argv.(1));
  let cmd = Js.Unsafe.coerce (new%js Com.obj (Js.string "ADODB.Command")) in
  cmd##.activeConnection := conn;
  cmd##.parameters##append (cmd##createParameter (Js.string "p") 8 1 0 (Js.string "it works!"));
  cmd##.commandText := Js.string "SELECT ? f";
  let rs = cmd##execute in
  while not (Js.to_bool rs##.eof) do
    print_endline (Js.to_string (rs##fields (Js.string "f"))##.value);
    rs##moveNext
  done
