open Js_of_ocaml
open Activex_js

class type route = object
  method _InterfaceIndex : int Com.readonly_prop
end

class type adapter = object
  method _MACAddress : Js.js_string Js.t Com.readonly_prop
end

class type wmi = object
  method _ExecQuery : Js.js_string Js.t -> 'a Com.EnumerableProp.t Js.t Js.meth
end

let wmi : wmi Js.t =
  Js.Unsafe.coerce @@
  Com.get_object {|winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2|}

let () =
  let iter f q = Com.EnumerableProp.iter f (wmi##_ExecQuery (Js.string q)) in
  "SELECT * FROM Win32_IP4RouteTable WHERE Destination='0.0.0.0'" |>
  iter (fun (r : route Js.t) ->
    Printf.sprintf
      "SELECT * FROM Win32_NetworkAdapter WHERE InterfaceIndex=%d"
      r##._InterfaceIndex##.___value_ |>
    iter (fun (a : adapter Js.t) ->
      print_endline (Js.to_string a##._MACAddress##.___value_)
    )
  )
