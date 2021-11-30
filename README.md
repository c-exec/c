# C
## Utility for executing C code as if it was a script file

Compiling, including, linking, making is old-school. For simple projects, rather use `c` - an intuitive automatic compilation and execution engine built with simplicity and completeness in mind.

![GitHub release (latest by date)](https://img.shields.io/github/v/release/c-exec/c?label=latest%20c%20release)
![GitHub top language](https://img.shields.io/github/languages/top/c-exec/c)
![Lines of code](https://img.shields.io/tokei/lines/github/c-exec/c?label=source%20lines)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/c-exec/c/C-Exec%20Build%20&%20Release)
![GitHub all releases](https://img.shields.io/github/downloads/c-exec/c/total)

### Setup
_Clang is assumed to be installed on your computer and in your PATH. If you prefer GCC, head over to the [Compiler path and default compiler options section](#compiler-path-and-default-compiler-options) and change the configured command to `gcc`._

MacOS is currently not supported. For Windows, just download the latest build from the
GitHub releases section and configure Windows to use `c.exe` as a default handler for `.c` files.

On Linux, make sure you have `update-binfmts` installed. Then execute  
`sudo sh -c "curl https://raw.githubusercontent.com/c-exec/c/master/setup.sh | sh"`

When the installation succeeded, try executing `c` in your terminal to get version information and a short help message.

### Updates
On Linux, just re-run the setup command line above. For Windows, you can download the latest
`c.exe` from GitHub's releases section and replace the currently installed one on your system.

# Example

Once installed, you will be able to run

`c your_code.c`

which will automatically

- search for includes
- compile the corresponding .c files and the main .c file itself
- execute the resulting program

## Even easier

On Windows, you can set `c` as a default file open handler for every file ending with `.c`.  
On Linux, you can achieve this using `update-binfmts`. Note that the setup script will do this automatically for you.

`chmod +x your_code.c` once.  
`./your_code.c` to execute your C program.


# Command line parameters and compiler options

You can add execution command line parameters as you'd expect: `c your_code.c parameter1 parameter2`. If you want to pass parameters to the compiler (i.e. clang, gcc) however, you should put them after a ` -- ` in the parameter chain:

`c your_code.c parameter1 parameter2 -- -Wall -o custom_output_name.bin`  
or `./your_code.c parameter1 parameter2 -- -Wall -o custom_output_name.bin`

## Includes

`c` uses the system C compiler to analyze includes. It finds "includes of includes" and handles conditional includes (via `IFDEF` for instance) correctly. It's assumed that the corresponding
`.c` source code file for a `.h` include header is inside the same directory with the `.h` extension exchanged for a `.c`.

If no corresponding source code file can be found, a warning is issued and it's likely that the compilation fails.

## Compiler path and default compiler options

You can put your favourite compiler options as a default command line in ~/.c_command.rc.
This file is just an ordinary shell command line instruction, defaulting to execute the `clang` command. Feel free to adjust it to your favourite compiler (i.e. `gcc`).

# Useful features

#### Print the exit code
Too lazy to manually check your program's exit code? Issue the **compiler** parameter (meaning, after the ` -- `) `-Dpc` to get it printed to stdout. This flag may also be added to ~/.c_command.rc .

#### Keep the console open
This is especially useful for Windows which autocloses console windows opened with a double-click. Issue the **compiler** parameter (meaning, after the ` -- `) `-Dkt` to **k** eep the **t** erminal open. This flag may also be added to ~/.c_command.rc .
