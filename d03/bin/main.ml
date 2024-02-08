type dir = LEFT | RIGHT;;

let symbols = ['*' ; '#' ; '+' ; '$'];;

let _string_of_dir d = match d with
  | LEFT -> "LEFT"
  | RIGHT -> "RIGHT"

let read_file =
  let lines = ref [] in
  let ch = open_in "input" in

  try
    while true; do
      lines := input_line ch :: !lines;
    done;

    !lines;
  with End_of_file ->
    close_in ch;
    List.rev !lines ;;

let is_symbol c = List.mem c symbols

let contains_one_of_symbols line =
  String.fold_left (fun acc c -> if acc == false then is_symbol c else acc) false line;;

let find_symbols_in_line line =
  let match_symbols acc c = 
    match c with
      | x when List.mem x symbols -> (x, String.index line x) :: acc
      | _ -> acc in
 
  let found_symbols = String.fold_left match_symbols [] line in

  found_symbols;;

(* let calculate_char (prev_line : string option) (current_line : string) (next_line : string option) (char : char) (index : int) = *)
(**)
(*   0;; *)

let _is_digit digit =
  match digit with
    | '0' .. '9' -> true
    | _ -> false;;

let _handle_char found_symbols (_prev_line : string option) (_current_line : string) (_next_line : string option) (_char_index : int) (_acc : int) (_c : char) =
  let find_in_line (_c, _i) = print_endline (String.make 1 _c) in

  print_newline ();

  List.length found_symbols |> string_of_int |> print_endline;
  List.iter find_in_line found_symbols;

  0;;

let calculate_line_res (lines : string list) (current_line_index : int) (current_line : string) (_res : int) =
  let rec get_adjacent_number_by_dir _line index (direction : dir) (res : string) = 
    print_endline ("RES: " ^ res);

    let end_predicate i = match direction with
      | LEFT -> i == 0
      | RIGHT -> i == (String.length _line - 1) in

    let get_current_loop_index i = match direction with
      | LEFT -> i - 1
      | RIGHT -> i + 1 in

    let append_by_dir char_to_append = match direction with
      | LEFT -> String.make 1 char_to_append ^ res
      | RIGHT -> res ^ String.make 1 char_to_append in

    if end_predicate index then 
      if String.length res == 0 then 0 else int_of_string res
    else

    let current_loop_index = get_current_loop_index index in
    let current_loop_char = String.get _line current_loop_index in

    let append_as_needed char_to_append = match _is_digit current_loop_char with
        | true -> append_by_dir char_to_append
        | false -> res in

      print_endline ("current loop char: " ^ String.make 1 current_loop_char);

      get_adjacent_number_by_dir _line current_loop_index direction (append_as_needed current_loop_char)
    in

  let maybe_prev_line = List.nth_opt lines (current_line_index - 1) in
  let maybe_next_line = List.nth_opt lines (current_line_index + 1) in

  let calculate_line_results (_char, _char_index) = 
    let current_left = get_adjacent_number_by_dir current_line _char_index LEFT "" in
    let current_right = get_adjacent_number_by_dir current_line _char_index RIGHT "" in

    let handle_maybe_line l d = match l with
      | Some x -> get_adjacent_number_by_dir x _char_index d ""
      | None -> 0 in

    let previous_left = handle_maybe_line maybe_prev_line LEFT in
    let previous_right = handle_maybe_line maybe_prev_line RIGHT in

    let next_left = handle_maybe_line maybe_next_line LEFT in
    let next_right = handle_maybe_line maybe_next_line RIGHT in

    let res = current_left + current_right + previous_left + previous_right + next_left + next_right in
    res in 
  
  let found_symbols = current_line |> find_symbols_in_line |> List.rev in

  let _r = List.map calculate_line_results found_symbols in

  let calculated_result = List.fold_left (+) 0 _r in

  calculated_result;;


let rec handle_line lines current_index current_line (res : int) = 
  print_newline ();

  match current_line with
  | None ->
      "Reached last line! Result: " ^ (string_of_int res) |> print_endline;

      res;
  | Some l ->
      (* print_endline l; *)
      
      let line_has_symbols = l |> contains_one_of_symbols in
      let next_index = current_index + 1 in

      match line_has_symbols with
        | true ->
            let _l_res = calculate_line_res lines current_index l 0 in

            handle_line lines next_index (List.nth_opt lines next_index) (res + _l_res);
        | false ->
            handle_line lines next_index (List.nth_opt lines next_index) res;;

let lines = read_file;;
let li = ref 0;;

handle_line lines !li (List.nth_opt lines !li) 0;;
