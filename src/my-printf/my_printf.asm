extern putc
extern stdout
section .note.GNU-stack

section .text

global my_printf

my_printf:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the my_printf function
	push rbx
	push r12
	push r13
	push r14
	push r15

	;salvez arg
	push rsi
	push rdx
	push rcx
	push r8
	push r9

	mov r12, rdi ;salvez formatul
	xor r13, r13 ;index pt format
	xor r14, r14 ;index pt arg

start:
	mov al, byte [r12 + r13] ;iau caracterul curent
	cmp al, 0 ;verific daca s-a terminat
	je final

	cmp al, '%' ;verific daca e %
	je procent

	movzx rdi, al ;pun caracterul in rdi
	mov rsi, [rel stdout]

	mov r15, rsp ;salvez stiva curenta
	and rsp, -16 ;aliniez stiva la 16 octeti
	call putc
	mov rsp, r15 ;readuc stiva

	inc r13
	jmp start

procent:
	inc r13 ;trec peste procent

	cmp r14, 0 ;vad daca iau rpimul arg
	je pt1
	cmp r14, 1 ;vad daca iau al doilea arg
	je pt2
	cmp r14, 2 ;vad daca iau al treilea arg
	je pt3
	cmp r14, 3 ;vad daca iau al patrulea arg
	je pt4
	cmp r14, 4 ;vad daca iau al cincilea arg
	je pt5

stiva:
	xor rax, rax
	mov rax, r14 ;iau indexul arg
	sub rax, 5 ;scad primele 5
	imul rax, 8 ;inmultesc ca sa aflu offset-ul
	add rax, 16 ;primul arg
	mov rax, [rbp + rax] ;iau arg de pe stiva
	jmp ok

pt1:
	mov rax, [rbp - 48] ;iau primul arg
	jmp ok
pt2:
	mov rax, [rbp - 56] ;iau al doilea arg
	jmp ok
pt3:
	mov rax, [rbp - 64] ;iau al treilea arg
	jmp ok
pt4:
	mov rax, [rbp - 72] ;iau al patrulea arg
	jmp ok
pt5:
	mov rax, [rbp - 80] ;iau al cincilea arg
	jmp ok

ok:
	inc r14 ;cresc indexul arg

	mov dl, byte [r12 + r13] ;iau caracterul de dupa procent
	cmp dl, 's'
	je string
	cmp dl, 'c'
	je char
	cmp dl, 'l'
	je nlong

	jmp start ;daca nu e corect ignor

string:
	mov rbx, rax ;pun adresa string-ului in rbx

parcurge:
	mov al, byte [rbx] ;iau caracterul din string
	cmp al, 0 ;verific daca am ajuns la finalul string-ului
	je gata_string

	movzx rdi, al ;pun caracterul in rdi
	mov rsi, [rel stdout]

	mov r15, rsp ;salvez stiva
	and rsp, -16 ;aliniez stiva
	call putc
	mov rsp, r15 ;readuc stiva

	inc rbx ;trec la urmatorul caracter
	jmp parcurge

gata_string:
	inc r13 ;trec peste 's'
	jmp start

char:
	mov rdi, rax
	mov rsi, [rel stdout]

	mov r15, rsp ;salvez stiva
	and rsp, -16 ;aliniez stiva
	call putc
	mov rsp, r15 ;readuc stiva

	inc r13 ;trec peste 'c'
	jmp start

nlong:
	cmp rax, 0 ;verific daca numarul e 0
	je afiseaza_zero

	mov rbx, 10 ;impart la 10 ca sa extrag cifra
	xor r15, r15 ;contor pt cifre

imparte_cifre:
	cmp rax, 0 ;verific daca am terminat de impartit
	je printeaza_cifre

	xor rdx, rdx ;pregatesc rdx
	div rbx ;impart rax la 10
	push rdx ;pun restul (cifra) pe stiva
	inc r15 ;cresc nr de cifre
	jmp imparte_cifre

printeaza_cifre:
	cmp r15, 0 ;verific daca mai am cifre
	je gata_long

	pop rdi ;scot cifra
	add rdi, '0' ;o fac caracter ASCII
	mov rsi, [rel stdout]

	push r15
	mov r15, rsp ;salvez stiva
	and rsp, -16 ;aliniez stiva
	call putc
	mov rsp, r15 ;readuc stiva
	pop r15

	dec r15 ;scad nr de cifre
	jmp printeaza_cifre

afiseaza_zero:
	mov rdi, '0' ;pun caracterul 0
	mov rsi, [rel stdout]

	mov r15, rsp ;salvez stiva
	and rsp, -16 ;aliniez stiva
	call putc
	mov rsp, r15 ;readuc stiva

gata_long:
	add r13, 2 ;trec peste 'l' si 'u'
	jmp start

final:
	xor rax, rax ;returnez 0

	add rsp, 40 ;scot cele 5 arge de pe stiva

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

	leave
	ret
