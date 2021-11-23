# C
## Utility for executing C code as if it was a script file

Compiling, including, linking, making is old-school. For simple projects, rather use `c` - an intuitive automatic compilation and execution engine built with simplicity and completeness in mind.

### Setup
MacOS is currently not supported. For Windows, just download the latest build from the
GitHub releases section and configure Windows to use `c.exe` as a default handler for `.c` files.

On Linux, make sure you have `update-binfmts` installed. Then execute
`curl https://github.com/c-exec/c/setup.sh | sudo sh`

### Example

Once installed, you will be able to run

`c your_code.c`

which will automatically

- search for includes
- compile the corresponding .c files and the main .c file itself
- execute the resulting program

### Even easier

On Windows, you can set `c` as a default file open handler for every file ending with `.c`.  
On Linux, you can achieve this using `update-binfmts`. Note that the setup script will do this automatically for you.

`chmod +x your_code.c` once.  
`./your_code.c` to execute your C program.


### Command line parameters and compiler options

You can add execution command line parameters as you'd expect: `c your_code.c parameter1 parameter2`. If you want to pass parameters to the compiler (i.e. clang, gcc) however, you should put them after a ` -- ` in the parameter chain:

`c your_code.c parameter1 parameter2 -- -Wall -o custom_output_name.bin`  
or `./your_code.c parameter1 parameter2 -- -Wall -o custom_output_name.bin`

### Includes

`c` uses the compiler to analyze includes. It finds "includes of includes" and handles conditional includes (`via IFDEF` for instance) correctly. It's assumed that the corresponding
`.c` source code file for a `.h` include header is inside the same directory with the `.h` extension exchanged for a `.c`.

If no corresponding source code file can be found, a warning is issued and it's likely that the compilation fails.

### Compiler path and default compiler options

You can put your favourite compiler options as a default command line in ~/.c_command.rc.
This file is just an ordinary shell command line instruction, defaulting to execute the `clang` command. Feel free to adjust it to your favourite compiler (i.e. `gcc`).

### Useful features

#### Print the exit code
Too lazy to manually check your program's exit code? Issue the **compiler** parameter (meaning, after the ` -- `) `-pc` to get it printed to stdout. This flag may also be added to ~/.c_command.rc .

#### Keep the console open
This is especially useful for Windows which autocloses console windows opened with a double-click. Issue the **compiler** parameter (meaning, after the ` -- `) `-kt` to **k** eep the **t** erminal open.
