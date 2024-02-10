type line_num = {num : int; index : int; end_index : int}

let symbols = ['-' ; '+' ; '/' ; '*' ; '=' ; '$' ; '#' ; '&' ; '@' ; '%' ; '!' ; '^'];;


let rec (--) i j =
  if i > j then []
  else i :: (i + 1)--j;;

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
  let found_symbols = ref [] in

  let match_symbols i ch = 
    match List.mem ch symbols with
    | true -> found_symbols := (ch, i) :: !found_symbols; ()
    | false -> ();
  in
 
  String.iteri match_symbols line;

  !found_symbols;;

let _is_digit digit =
  match digit with
    | '0' .. '9' -> true
    | _ -> false;;

let parse_line_numbers line =
  let _res = ref [] in
  let _r = ref "" in

  let parse i ch =
    let current_result_length = String.length !_r in

    if current_result_length > 0 && ch == '.' then
      let num = {num = int_of_string !_r; index = (i - current_result_length); end_index = i - 1} in

      _res := num :: !_res;
      _r := "";
    else
      match ch with
      | '0' .. '9' -> _r := !_r ^ (String.make 1 ch)
      | _ -> ();

        ()
  in

  let _parsed_result = String.iteri parse line in

  !_res;;

let calculate_line_res (lines : string list) (current_line_index : int) (current_line : string) (_res : int) =
  let maybe_prev_line = List.nth_opt lines (current_line_index - 1) in
  let maybe_next_line = List.nth_opt lines (current_line_index + 1) in

  let calc line ch_i =
    let line_nums = parse_line_numbers line in

    let is_in_range ch_i ln = 
      let allowed = [ch_i - 1; ch_i; ch_i + 1] in
      let indexes = ln.index--ln.end_index in

      List.exists (fun i -> List.mem i allowed) indexes
    in

    line_nums
    |> List.filter (fun ln -> is_in_range ch_i ln) 
    |> List.map (fun ln -> ln.num)
    |> List.fold_left (fun x n -> x + n) 0
  in

  let calculate_line_results (_, ch_i) = 
    let handle_maybe_line l = match l with
      | Some x -> calc x ch_i
      | None -> 0 in

    let current = calc current_line ch_i in
    let previous = handle_maybe_line maybe_prev_line in
    let next = handle_maybe_line maybe_next_line in

    print_endline ("--------------------------------");
    print_endline ("CHAR_INDEX: " ^ string_of_int ch_i);
    print_endline ("P: " ^ string_of_int previous);
    print_endline ("C: " ^ string_of_int current);
    print_endline ("N: " ^ string_of_int next);
    print_endline ("FULL: " ^ string_of_int (previous + current + next));
    print_endline ("--------------------------------");

    current + previous + next in 
  
  let found_symbols = current_line |> find_symbols_in_line |> List.rev in

  let line_results = List.map calculate_line_results found_symbols in

  let calculated_result = List.fold_left (+) 0 line_results in

  calculated_result;;


let rec handle_line lines current_index current_line (res : int) = 
  print_newline ();

  match current_line with
  | None ->
      "Reached last line! Result: " ^ (string_of_int res) |> print_endline;

      res;
  | Some l ->
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
