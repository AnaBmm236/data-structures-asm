extern malloc

section .bss
	curent resd 100 ;vectorul pe care lucrez
	folosit resb 100 ;vad ce numere am bagat
	stiva_i resq 100 ;retin unde am gasit loc
	stiva_v resq 100 ;retin ce numar am testat
	sol resq 1 ;aici tin toate solutiile
	nr resq 1 ;cate am gasit pana acum
	n resq 1 ;marimea n
	pointer resq 1 ;pointerul din argument

section .note.GNU-stack

section .text

global check_langford
global generate_langford_sequences

check_langford:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the check_langford function

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov eax, esi ;iau lungimea
	mov r11, rax ;pun lungimea in r11

	mov rax, 2 ;pun 2
	mov rbx, rax ;pun 2 pt impartire
	mov rax, r11 ;iau lungimea
	xor rdx, rdx
	div rbx ;impart lungimea la 2

	cmp rdx, 0 ;verific restul impartirii
	jne gresit

	mov rbx, rax ;iau n
	mov r13, rbx ;salvez n

	mov rax, 1 ;pun 1
	mov r12, rax ;v curent de la 1 la n

start:
	mov rbx, r13 ;iau n
	cmp r12, rbx ;verific daca am parcurs toate valorile
	jg corect

	xor r9, r9
	mov rax, -1 ;pun -1
	mov r10, rax ;salvez primul index pe -1
	xor rbx, rbx
	mov r8, rbx ;indexul in vector

parcurge:
	mov rcx, r11 ;iau lungimea
	cmp r8, rcx ;verific daca am parcurs vectorul
	jge verifica

	mov eax, dword [rdi + r8 * 4] ;iau elementul
	mov rbx, r12 ;iau v
	cmp rax, rbx ;vad daca e valoarea cautata
	jne next

	inc r9
	mov rax, -1 ;pun -1
	cmp r10, rax ;vad daca e prima aparitie
	jne next
	mov r10, r8 ;salvez indexul primei aparitii

next:
	inc r8
	jmp parcurge

verifica:
	mov rax, 2 ;pun 2
	cmp r9, rax ;verific daca a aparut exact de 2 ori
	jne gresit

	mov rax, r10 ;iau primul index
	add rax, r12
	inc rax

	mov rbx, r11 ;iau lungimea
	cmp rax, rbx ;vad sa nu iasa din vector
	jge gresit

	mov ecx, dword [rdi + rax * 4] ;iau elementul de la a doua pozitie
	mov rbx, r12 ;iau v
	cmp rcx, r12 ;vad daca perechea e corecta
	jne gresit

	inc r12
	jmp start

gresit:
	xor rax, rax
	jmp end

corect:
	mov rax, 1 ;return 1

end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

	leave
	ret

generate_langford_sequences:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the generate_langford_sequences function

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov rax, rdi ;iau n
	mov [n], rax ;salvez n
	mov rax, rsi ;iau pointerul
	mov [pointer], rax ;salvez pointerul

	xor rcx, rcx
	mov qword [nr], rcx ;initializez cu 0

	mov rdi, 80000 ;aloc spatiu pt rezultate
	call malloc
	mov [sol], rax ;salvez pointerul

	xor rax, rax
	mov r8, rax ;pun 0

cleanc:
	mov rax, [n] ;iau n
	mov rbx, rax ;iau n
	add rax, rbx ;inmultesc cu 2 pt lungime
	mov r9, rax ;pun lungimea
	cmp r8, r9 ;verific daca s-a terminat
	jge frecventa

	xor eax, eax
	mov dword [curent + r8 * 4], eax ;pun 0 pe pozitie
	inc r8
	jmp cleanc

frecventa:
	xor rdx, rdx
	mov r8, rdx ;pun 0

cleanf:
	mov rax, [n] ;iau n
	add rax, 1 ;adun 1
	mov r9, rax ;pun n+1
	cmp r8, r9 ;verific daca s-a terminat
	jge start2

	xor al, al
	mov byte [folosit + r8], al ;pun 0 in frecventa
	inc r8
	jmp cleanf

start2:
	xor rax, rax
	mov r12, rax ;pun 0
	mov rcx, 1 ;pun 1
	mov qword [stiva_v], rcx ;incep cu valoarea 1

cauta:
	mov rax, [n] ;iau n
	cmp r12, rax ;verific daca le-am pus pe toate
	je gasit3

	xor rbx, rbx
	mov r8, rbx ;pun 0

cautaloc:
	mov rax, [n] ;iau n
	mov rdx, rax ;iau n
	add rax, rdx ;inmultesc cu 2 pt lungime
	mov r9, rax ;pun lungimea
	cmp r8, r9 ;verific daca ies din vector
	jge inapoi

	mov eax, dword [curent + r8 * 4] ;iau elementul
	cmp eax, 0 ;verific daca e gol
	je gasit2
	inc r8
	jmp cautaloc

gasit2:
	mov rdx, r12 ;iau indexul
	mov [stiva_i + rdx * 8], r8 ;salvez pozitia

incearca:
	mov rax, r12 ;iau indexul
	mov rbx, [stiva_v + rax * 8] ;iau valoarea din stiva
	mov rax, rbx ;iau valoarea
	mov rbx, [n] ;iau n
	cmp rax, rbx ;verific daca e mai mare ca n
	jg inapoi

	mov rdx, rax ;pun v
	cmp byte [folosit + rdx], 0 ;verific daca e pus deja
	jne urmatorul

	mov rdx, r12 ;iau indexul
	mov r8, [stiva_i + rdx * 8] ;iau pozitia salvata
	mov rcx, r8 ;pun pozitia in rcx
	add rcx, rax
	inc rcx

	mov rdx, [n] ;iau n
	mov rbx, rdx ;iau n
	add rdx, rbx ;inmultesc cu 2
	cmp rcx, rdx ;verific daca iese din vector
	jge urmatorul

	mov rbx, rcx ;pun a doua pozitie
	cmp dword [curent + rbx * 4], 0 ;verific daca a doua e goala
	jne urmatorul

	mov rdx, r8 ;pun prima pozitie
	mov dword [curent + rdx * 4], eax ;pun numarul
	mov rdx, rcx ;pun a doua pozitie
	mov dword [curent + rdx * 4], eax ;pun perechea
	mov rdx, rax ;pun valoarea
	mov byte [folosit + rdx], 1 ;marchez ca pus

	mov rcx, rax ;iau valoarea
	inc rcx
	mov rdx, r12 ;iau indexul
	mov [stiva_v + rdx * 8], rcx ;salvez valoarea pt mai tarziu

	inc r12
	mov rax, 1 ;pun 1
	mov rdx, r12 ;iau indexul
	mov qword [stiva_v + rdx * 8], rax ;incep cu 1
	jmp cauta

urmatorul:
	mov rdx, r12 ;iau indexul
	mov rax, [stiva_v + rdx * 8] ;iau valoarea din stiva
	inc rax
	mov [stiva_v + rdx * 8], rax ;salvez numarul inapoi
	jmp incearca

inapoi:
	mov rax, r12 ;iau indexul
	dec rax
	mov r12, rax ;pun indexul inapoi
	mov rdx, -1 ;pun -1
	cmp r12, rdx ;verific daca am terminat
	je stop

	mov rdx, r12 ;iau indexul
	mov rax, [stiva_v + rdx * 8] ;iau valoarea din stiva
	dec rax

	mov r8, [stiva_i + rdx * 8] ;iau pozitia salvata
	mov rcx, r8 ;pun pozitia in rcx
	add rcx, rax
	inc rcx

	mov rdx, r8 ;pun prima pozitie
	mov dword [curent + rdx * 4], 0 ;sterg primul numar
	mov rdx, rcx ;pun a doua pozitie
	mov dword [curent + rdx * 4], 0 ;sterg al doilea numar
	mov rdx, rax ;pun valoarea
	mov byte [folosit + rdx], 0 ;sterg din frecventa

	jmp incearca

gasit3:
	mov rax, [n] ;iau n
	mov rbx, rax ;iau n
	add rax, rbx ;inmultesc cu 2
	mov rdi, rax ;pun lungimea in rdi
	mov rbx, 4 ;pun 4
	imul rdi, rbx ;inmultesc ca sa aflu spatiul
	call malloc
	mov r14, rax ;salvez adresa

	xor rcx, rcx
	mov r8, rcx ;pun 0

copiaza:
	mov rax, [n] ;iau n
	mov rbx, rax ;iau n
	add rax, rbx ;inmultesc cu 2 pt lungime
	mov r9, rax ;pun lungimea
	cmp r8, r9 ;verific daca am terminat
	jge salveaza

	mov rax, r8 ;iau indexul
	mov eax, dword [curent + rax * 4] ;iau elementul
	mov dword [r14 + r8 * 4], eax ;pun in solutie
	inc r8
	jmp copiaza

salveaza:
	mov rax, [nr] ;iau nr solutii
	mov rbx, [sol] ;iau pointerul
	mov rcx, rax ;pun nr solutii in rcx
	mov [rbx + rcx * 8], r14 ;salvez in array

	mov rax, [nr] ;iau nr solutii
	inc rax
	mov [nr], rax ;cresc numarul de solutii

	jmp inapoi ;ma intorc sa caut alta

stop:
	mov rax, [nr] ;iau nr solutii
	mov rsi, [pointer] ;iau pointerul
	mov dword [rsi], eax ;pun rezultatul final in pointer

	xor rbx, rbx
	cmp rax, rbx ;verific daca e 0
	je nimic

	mov rax, [sol] ;returnez vectorul
	jmp final

nimic:
	xor rax, rax

final:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

	leave
	ret
