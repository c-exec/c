import os
import regex
import shlex
import osproc
import strutils

if not os.file_exists(os.expand_tilde("~/.c_command.rc")):
    write_file(os.expand_tilde("~/.c_command.rc"), "clang -Wall -g -std=c11")

var execution_parameters = "\"" & os.command_line_params().join("\" \"") & "\""
var parameters: string
if "\"--\"" in execution_parameters: (execution_parameters, parameters) = execution_parameters.split("\"--\"")
parameters = read_file(os.expand_tilde("~/.c_command.rc")) & " " & parameters

# Pass 1: Obtaining dependencies
if param_str(1) notin shlex(parameters).words:
    # this is the case when running ./example.c instead of "c example.c"
    parameters &= " " & param_str(1)
    execution_parameters = execution_parameters.replace(regex.to_pattern("\\s*\"?" & regex.escapeRe(param_str(1)).replace("/", "\\/") & "(?:\"|\\b)"), "")

var output = osproc.exec_process(parameters.replace(regex.to_pattern("\"?-o\"?\\s+\"?.*?\""), "") & " -MM")
var output_name: string
var includes: seq[string]
output = output.replace(re"(?m)^clang\:\s+.*$\n", "")

var item_no = 0
for item in shlex(output):
    if item.is_empty_or_whitespace(): continue
    if item_no == 0 and not parameters.contains(regex.to_pattern("\"?-o\"?\\s+\"?.*?\"")):
        if hostOS == "windows":
            output_name = os.change_file_ext(item.split(":")[0], "exe")
        else:
            output_name = item.split(":")[0].replace(".o", "")
    elif item_no > 1: # ignore the first entry since it references the source file itself
        if item.starts_with("clang:"): continue
        var item = item.strip().change_file_ext(".c")
        if not os.file_exists(item.replace("\\ ", " ")):
            echo "\e[33m", "Warning:", "\e[0m", " dependency code file '" & item.replace("\\ ", "") & "' (assumed path from header file name) not found - please make sure it exists at this location since otherwise, the build might fail"
        includes.add(item)
    item_no += 1

# Pass 2: Compiling all source files to a final executable
if not output_name.is_empty_or_whitespace():
    parameters &= " -o \"" & output_name & "\""
var result = osproc.exec_cmd(parameters & " " & includes.join(" "))
if result != 0:
    echo "\e[31m", "Error:", "\e[0m", " compilation failed"
    quit(result)

# Pass 3: Executing the program

var output_match: RegexMatch
if parameters.find(regex.to_pattern("\"?-o\"?\\s+\"?(.*?)\""), output_match):
    output_name = output_match.group(0, parameters)[0]
if hostOS != "windows": output_name = "./" & output_name

var exit_code = exec_cmd(output_name & " " & execution_parameters)
if "-pc" in parameters or "--print-exit-code" in parameters:
    echo "Exited with exit code: ", exit_code