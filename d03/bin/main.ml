type line_num = {num : int; index : int; end_index : int}
type line_symbol = {symbol : char; index : int}

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

let is_digit digit =
  match digit with
    | '0' .. '9' -> true
    | _ -> false;;

let map_line symbols numbers current_line_index _ =
  let current_line_numbers = List.nth numbers current_line_index in

  let previous_line_symbols = if current_line_index == 0 then None else List.nth_opt symbols (current_line_index - 1) in
  let current_line_symbols = List.nth_opt symbols current_line_index in
  let next_line_symbols = List.nth_opt symbols (current_line_index + 1) in

  let count_part_numbers (symbols : line_symbol list option) (line_num : line_num) =
    match symbols with
    | None -> 0
    | Some line_symbols ->
      let allowed_indexes = line_num.index--line_num.end_index in

      let is_in_symbol_range line_symbol =
        let symbol_indexes = [line_symbol.index - 1; line_symbol.index; line_symbol.index + 1] in

        List.exists (fun ai -> List.mem ai symbol_indexes) allowed_indexes
      in

      let found_part_num = line_symbols |> List.filter is_in_symbol_range |> List.length in

      if found_part_num == 0 then 0 else line_num.num
  in


  let safe_count_numbers (line_num : line_num) =
    let prev_count = count_part_numbers previous_line_symbols line_num in
    let current_count = count_part_numbers current_line_symbols line_num in
    let next_count = count_part_numbers next_line_symbols line_num in

    prev_count + current_count + next_count
  in

  current_line_numbers
  |> List.map safe_count_numbers 
  |> List.fold_left (fun acc n -> acc + n) 0;;

let get_line_symbols line =
  let line_symbols = ref [] in

  let to_symbol index char = 
    let symbol = {symbol = char; index = index} in
    line_symbols := symbol :: !line_symbols;
  in

  line |> String.iteri to_symbol;

  !line_symbols |> List.filter (fun symbol -> is_symbol symbol.symbol);;

let get_line_numbers line =
  let line_nums = ref [] in
  let current_number = ref "" in

  let parse i ch =
    let current_result_length = String.length !current_number in
    let is_ch_digit = is_digit ch in

    if current_result_length > 0 && (is_ch_digit == false) then
      let num = {num = int_of_string !current_number; index = (i - current_result_length); end_index = i - 1} in

      line_nums := num :: !line_nums;
      current_number := "";
    else
      match is_ch_digit with
      | true -> current_number := !current_number ^ (String.make 1 ch)
      | _ -> ();

        ()
  in

  let _parsed_result = String.iteri parse line in

  !line_nums;;

let p1 =
  let lines = read_file in
  let symbols = List.map get_line_symbols lines in
  let numbers = List.map get_line_numbers lines in

  let results = List.mapi (map_line symbols numbers) lines in
  let result = List.fold_left (fun x n -> x + n) 0 results in

  print_newline();
  print_newline();
  print_endline ("RESULT: " ^ string_of_int result);

  result;;

p1;;
