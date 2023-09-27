(* Clone Git repositories from a list in an input file *)

open Unix

(* Function to execute a shell command and capture the output *)
let exec_command command =
  let in_channel = Unix.open_process_in command in
  let output = input_line in_channel in
  let process_status = close_process_in in_channel in
  match process_status with
  | WEXITED 0 -> output
  | _ -> failwith "Error executing command"

(* Function to clone a Git repository and make it a full mirror *)
let clone_repository repository_url destination_dir =
  let clone_command =
    "git clone --mirror " ^ repository_url ^ " " ^ destination_dir
  in
  let process_status = system clone_command in
  match process_status with
  | WEXITED 0 -> ()
  | _ -> failwith "Error cloning repository"
