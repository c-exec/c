# Download Procedure Here
echo "Downloading c"
wget https://github.com/c-exec/c/releases/latest/download/c
cp c /usr/local/bin/c
rm c
echo "Registering .c extension handler"
update-binfmts --install c-exec /usr/local/bin/c --extension c || echo "Could not register .c extension"

echo "Setup done."
echo "Try executing 'c your_script.c'"
echo "If the .c extension handler was registered successfully, you can also"
echo "mark your script as executable ('chmod +x your_script.c')"
echo "and then run ./your_script.c ([parameter1] [parameter2] -- [compiler_flag1] [compiler_flag2])"
