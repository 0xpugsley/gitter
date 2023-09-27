(* Main function *)
let main () =
  if Array.length Sys.argv <> 3 then
    Printf.eprintf "Usage: %s input_file destination_dir\n" Sys.argv.(0)
  else
    let input_file = Sys.argv.(1) in
    let destination_dir = Sys.argv.(2) in

    (* Read the list of repository URLs from the input file *)
    let repositories =
      try
        let file = open_in input_file in
        let rec read_lines acc =
          try
            let line = input_line file in
            read_lines (line :: acc)
          with End_of_file -> List.rev acc
        in
        let lines = read_lines [] in
        close_in file;
        lines
      with Sys_error msg ->
        Printf.eprintf "Error: %s\n" msg;
        exit 1
    in

    (* Clone each repository and make it a full mirror *)
    List.iter
      (fun repository_url ->
        let repo_name = Filename.basename repository_url in
        let destination = Filename.concat destination_dir repo_name in
        if Sys.file_exists destination then
          Printf.printf "Repository '%s' already exists in '%s'. Skipping.\n"
            repo_name destination
        else (
          Printf.printf "Cloning '%s' to '%s'...\n" repository_url destination;
          Gitter.clone_repository repository_url destination;
          Printf.printf "Done.\n"))
      repositories

(* Run the program *)
let () = main ()
