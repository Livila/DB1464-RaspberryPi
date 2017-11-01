echo 'Compiling...';
echo;

# Compile the files.
gcc -g -o testProgram testProgram.s
if [ $? -eq 0 ]; then
    # No error.
    echo 'Compiling completed. Executing the file...';
    echo 'Result:';
    echo;

    # Run the executable file.
    ./testProgram

    # Remove the executable file.
    rm testProgram
else
    # Some error occured...
    echo 'Some error occured, could not compile...';
fi

echo;
