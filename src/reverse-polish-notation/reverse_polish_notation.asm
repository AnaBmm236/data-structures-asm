extern scanf
extern printf
extern atol

section .note.GNU-stack

section .bss
    aux resb 256 ;buffer pt cuvantul citit

section .data
    fin db "%s", 0 ;format pt citire string
    fout db "%ld", 10, 0 ;format pt afisare numar si enter

section .text

global reverse_polish_notation

reverse_polish_notation:
    push rbp
    mov rbp, rsp
    xor rax, rax
    ; TODO - write the reverse_polish_notation function
    push r12

start:
    mov rdi, fin
    mov rsi, aux
    xor rax, rax

    mov r12, rsp ;salvez stiva curenta
    and rsp, -16 ;aliniez stiva la 16 octeti pt C
    call scanf
    mov rsp, r12 ;restaurez stiva mea

    cmp rax, 1 ;verific daca s-a citit ceva
    jne end ;daca nu (EOF), ies din bucla

    cmp byte [aux + 1], 0 ;verific daca are doar un caracter
    jne numar ;daca are mai multe, sigur e numar

    cmp byte [aux], '+' ;verific ce operator e
    je adunare
    cmp byte [aux], '-'
    je scadere
    cmp byte [aux], '*'
    je inmultire
    cmp byte [aux], '/'
    je impartire

numar:
    mov rdi, aux

    mov r12, rsp ;salvez stiva curenta
    and rsp, -16 ;aliniez stiva la 16 octeti
    call atol ;transform string-ul in intreg
    mov rsp, r12 ;refac stiva

    push rax ;pun numarul pe stiva
    jmp start 

adunare:
    xor r8, r8
    pop r8 ;scot al doilea numar

    xor r9, r9
    pop r9 ;scot primul numar

    add r8, r9 ;le adun

    push r8 ;pun rezultatul pe stiva
    jmp start

scadere:
    xor r8, r8
    pop r8 ;scot al doilea numar

    xor r9,r9
    pop r9 ;scot primul numar

    sub r9, r8 ;le scad
    push r9 ;pun rezultatul pe stiva
    jmp start

inmultire:
    xor r8, r8
    pop r8 ;scot al doilea numar

    xor r9, r9
    pop r9 ;scot primul numar

    imul r8, r9 ;le inmultesc
    push r8 ;pun rezultatul pe stiva

    jmp start

impartire:
    xor r8, r8
    pop r8 ;scot impartitorul

    pop rax ;scot deimpartitul

    cmp rax, 0 ;verific daca e pozitiv
    jge pozitiv
    mov rdx, -1 ;extind semnul pt negativ
    jmp ok

pozitiv:
    xor rdx, rdx ;extind semnul pt pozitiv

ok:
    idiv r8 ;impart rax la r8
    push rax ;pun catul pe stiva

    jmp start

end:
    pop rsi ;iau rezultatul final de pe stiva
    mov rdi, fout
    xor rax, rax

    mov r12, rsp ;salvez stiva curenta
    and rsp, -16 ;aliniez stiva la 16 octeti
    call printf ;printez rezultatul
    mov rsp, r12 ;refac stiva

    pop r12

    leave
    ret
