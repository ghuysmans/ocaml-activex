open Js_of_ocaml

let () =
  print_endline "starting up Excel...";
  let app = Excel.create () in
  app##.visible := Js._true;
  print_endline "press enter to close it";
  ignore (read_line ())
