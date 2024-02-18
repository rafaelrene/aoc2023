open Core;;

type symbol = {col_index: int; row_index: int; };;
type part_number = {col_index_start: int; col_index_end: int; row_index: int; value: int};;

let get_file_lines file = In_channel.read_lines file;;

let is_symbol ch = match ch with
  | '0' .. '9' -> false
  | '.' -> false
  | _ -> true;;

let get_symbols file_lines = 
  let result = ref [] in

  List.iteri file_lines ~f:(fun row_index row ->
    let handle_ch col_index ch = 
      let _ = match is_symbol ch with
        | true -> result := {col_index = col_index; row_index = row_index} :: !result
        | false -> () in

      ()
    in

    String.iteri row ~f:handle_ch;

    ()
  );

  !result;;

let get_part_numbers file_lines =
  let part_numbers = ref [] in

  let push_part_number start finish row_index row = 
    let part_number = {
      col_index_start = start;
      col_index_end = finish;
      row_index = row_index;
      value = String.slice row start finish |> int_of_string;
    } in

    part_numbers := part_number :: !part_numbers;
  in

  List.iteri file_lines ~f:(fun row_index row ->
    let rec aux start finish index chars =
      match start, finish, chars with
      | None, None, '0' .. '9' :: rest -> aux (Some index) (Some (index + 1)) (index + 1) rest
      | None, None, _ :: rest -> aux None None (index + 1) rest
      | None, None, [] -> ()
      | None, Some _, _ -> assert false
      | Some _, None, _ -> assert false
      | s, Some _, '0' .. '9' :: rest -> aux s (Some (index + 1)) (index + 1) rest 
      | Some s, Some f, _ :: rest ->
        push_part_number s f row_index row;
        aux None None (index + 1) rest;
      | Some s, Some f, [] ->
        push_part_number s f row_index row;
        aux None None (index + 1) [];
    in

    let chars = String.to_list row in

    aux None None 0 chars;
  );

  !part_numbers;;

let part1 (symbols : symbol list) part_numbers =
  let filtered_part_numbers = List.filter part_numbers ~f:(fun part_number ->
    let adjecent_symbols = List.filter symbols ~f:(fun symbol -> 
      let allowed_row_indices = [part_number.row_index - 1; part_number.row_index; part_number.row_index + 1] in

      let is_row_adjecent = match List.find allowed_row_indices ~f:(fun ri -> phys_equal ri symbol.row_index) with 
        | Some _ -> true      
        | None -> false
      in
      let is_col_adjecent = part_number.col_index_start - 1 <= symbol.col_index && part_number.col_index_end >= symbol.col_index in

      is_row_adjecent && is_col_adjecent;
    ) in

    (List.length adjecent_symbols) > 0;
  ) in

  let res = 
    let nums = List.map filtered_part_numbers ~f:(fun pn -> pn.value) in
    
    List.fold nums ~init:0 ~f:(fun acc n -> acc + n)
  in
  
  Fmt.pr "@.@.Part 1: %d" res;;
  

let part2 =
  Fmt.pr "@.@.Part 2: %s" "N/A";;

let () =
  let file_lines = get_file_lines "./input" in

  let symbols = get_symbols file_lines in
  let part_numbers = get_part_numbers file_lines in

  List.iteri file_lines ~f:(fun i l -> Fmt.pr "@.%s -> %d" l i);

  part1 symbols part_numbers;
  part2;;
