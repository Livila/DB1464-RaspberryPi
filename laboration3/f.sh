echo 'Compiling...';
echo;

# Compile the files.
gcc -g -o f Mprov64.s f.s
if [ $? -eq 0 ]; then
    # No error.
    echo 'Compiling completed. Executing the file...';
    echo 'Result:';
    echo;

    # Run the executable file.
    ./f

    # Remove the executable file.
    rm f
else
    # Some error occured...
    echo 'Some error occured, could not compile...';
fi

echo;
