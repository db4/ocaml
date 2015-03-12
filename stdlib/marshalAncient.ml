(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1997 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)

type 'a ancient

external follow: 'a ancient -> 'a = "caml_ancient_follow"
external delete: 'a ancient -> unit = "caml_ancient_delete"

type info = {
  a_size : int;
}

external data_size_unsafe: bytes -> int -> int = "caml_marshal_data_size"
external mark_info: 'a -> 'a ancient * info
    = "caml_ancient_mark_info"
external from_channel_info: in_channel -> 'a ancient * info
    = "caml_input_value_ancient_info"
external from_bytes_unsafe_info: bytes -> int -> 'a ancient * info
    = "caml_input_value_from_string_ancient_info"

let from_bytes_info buff ofs =
  if ofs < 0 || ofs > Bytes.length buff - Marshal.header_size
  then invalid_arg "MarshalAncient.from_bytes"
  else begin
    let len = data_size_unsafe buff ofs in
    if ofs > Bytes.length buff - (Marshal.header_size + len)
    then invalid_arg "MarshalAncient.from_bytes"
    else from_bytes_unsafe_info buff ofs
  end

let from_string_info buff ofs =
  (* Bytes.unsafe_of_string is safe here, as the produced byte
     sequence is never mutated *)
  from_bytes_info (Bytes.unsafe_of_string buff) ofs

let mark v = fst (mark_info v)
let from_channel ic = fst (from_channel_info ic)
let from_bytes buff ofs = fst (from_bytes_info buff ofs)
let from_string buff ofs = fst (from_string_info buff ofs)
