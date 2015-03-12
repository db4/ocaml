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

val mark: 'a -> 'a ancient
(** [MarshalAncient.mark v] copies [v] and all values referenced
   by [v] out of the OCaml heap.  It returns the proxy for [v].
   The copy of [v] accessed through the proxy MUST NOT be mutated.
   If [v] represents a large object, then it is a good
   idea to call {!Gc.compact} after marking to recover the
   OCaml heap memory. *)

val follow: 'a ancient -> 'a
(** [MarshalAncient.follow obj] follows proxy link to out of heap value.
   Raise [Invalid_argument "ancient_follow: deleted"] if [obj]
   has been deleted. *)

val delete: 'a ancient -> unit
(** [MarshalAncient.delete obj] deletes ancient object [obj].
   Raise [Invalid_argument "ancient_delete: deleted"] if [obj]
   has been deleted. Forgetting to delete an ancient object results
   in a memory leak. *)

val from_channel : in_channel -> 'a ancient 
(** Same as {!Marshal.from_channel}, but reconstructs the corresponding
   value in a statically allocated memory outside the OCaml heap like
   {!MarshalAncient.mark} It returns the proxy for the allocated value *)

val from_bytes : bytes -> int -> 'a ancient
(** Same as {!Marshal.from_bytes}, but reconstructs the corresponding
   value in a statically allocated memory outside the OCaml heap like
   {!MarshalAncient.mark} It returns the proxy for the allocated value *)

val from_string : string -> int -> 'a ancient
(** Same as [from_bytes] but take a string as argument instead of a
    byte sequence. *)

type info = {
  a_size : int; (** Allocated size in bytes *)
}

val mark_info : 'a -> 'a ancient * info
(** Same as {!MarshalAncient.mark}, but also returns some
   extra information. *)

val from_channel_info : in_channel -> 'a ancient * info
(** Same as {!MarshalAncient.from_channel}, but also returns some
   extra information. *)

val from_bytes_info : bytes -> int -> 'a ancient * info
(** Same as {!MarshalAncient.from_bytes}, but also returns some
   extra information. *)
 
val from_string_info : string -> int -> 'a ancient * info
(** Same as [from_bytes_info] but take a string as argument instead of a
    byte sequence. *)
