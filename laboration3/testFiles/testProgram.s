    .data

resMsg: .asciz   "fak=%d\n"
buf:    .asciz   "xxxxxxxxx"
endMsg: .asciz   "slut\n"

    .text
    .global main

main:
    pushq   $0                  # Stacken ska vara 16 bytes ”aligned”
    movq    $5, %rdi            # Beräkna 5!
    call    fac

    movq    %rax, %rsi          # Flytta returvärdet till argumentregistret (arg2)
    movq    $resMsg, %rdi       # Skriv ut Fak= ”resultat”, adr. till formatsträng i arg1
    call    printf

    # Läs med fgets(buf, 5, stdin)
    movq    $buf, %rdi          # Lägg i buf, adr. arg1
    movq    $5, %rsi            # Högst 5-1=4 tecken, arg2
    movq    stdin, %rdx         # Från standard input, arg3
    call    fgets

    movq    $buf, %rdi          # Adress till sträng i arg1
    call    printf              # Skriv ut buffert

    movq    $endMsg, %rdi       # Följd av slut
    call    printf

    popq    %rax
ret                             # Avsluta programmet

# Här finns funktionen fac = n! (rekursiv)
fac:
    cmpq    $1, %rdi            # if n>1
    jle     lBase
    pushq   %rdi                # Lägg anropsvärde på stacken
    decq    %rdi                # Räkna ned värdet med 1

    call    fac                 # temp = fakultet av (n-1)
    popq    %rdi                # Hämta från stack
    imul    %rdi, %rax          # return n*temp
ret                             # Återvänd

lBase:
    movq    $1, %rax            # else return 1
ret                             # Återvänd
