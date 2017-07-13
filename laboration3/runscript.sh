echo 'Compiling...';
echo;
gcc -g -o main Mprov64.s main.s
if [ $? -eq 0 ]; then
    # No error.
    echo 'Compiling completed. Executing the file...';
    echo 'Result:';
    echo;
    ./main
    echo;
else
    # Some error occured...
    echo 'Some error occured, could not compile...';
    echo;
fi
