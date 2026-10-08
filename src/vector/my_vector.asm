extern malloc
extern realloc
extern printf
extern free

section .data
	first db "v -> {(", 0 ;sirul de inceput
	element db "[%d]", 0 ;elementul din vector
	nth db "[]", 0 ;spatiile goale
	last db "), %d, %d}", 10, 0 ;sirul de final si enter
	empty db "The vector is empty", 10, 0 ;mesaj cand e gol
	eroare db "Error: len <= %d", 10, 0 ;mesaj de eroare

section .note.GNU-stack

section .text

global new_vector
global set_element
global get_element
global push_element
global pop_element
global print_vector
global free_vector

;struct vector {
;	int *arr;
;	int len;
;	int cap;
;}

new_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the new_vector function
	push r12
	push r13

	mov r12, rdi

	mov rdi, 16 ;aloc memorie pt structura
	call malloc
	mov r13, rax

	mov rax, r12
	mov rdi, 4 ;dimensiunea unui int
	mul rdi

	mov rdi, rax
	call malloc

	mov [r13 + 0], rax ;pun adresa vectorului
	mov dword [r13 + 8], 0 ;initializez lungimea cu 0
	mov dword [r13 + 12], r12d ;initializez capacitatea

	mov rax, r13

	pop r13
	pop r12

	leave
	ret

set_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the set_element function
	cmp edx, 0 ;verific daca indexul e negativ
	jl invalid

	mov eax, dword [rdi + 8] ;iau lungimea
	cmp edx, eax
	jge eroare_elem1

	mov r8, [rdi + 0] ;iau adresa vectorului
	mov dword [r8 + rdx * 4], esi ;pun elementul in vector

	mov eax, edx
	jmp gata

eroare_elem1:
	mov esi, edx
	mov rdi, eroare
	xor eax, eax
	call printf

invalid:
	mov eax, -1 ;pun -1 in caz de eroare

gata:
	leave
	ret

get_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the get_element function

	mov eax, dword [rdi + 8] ;iau lungimea
	cmp esi, eax
	jge eroare_elem2

	mov r8, [rdi + 0] ;iau adresa vectorului
	mov eax, dword [r8 + rsi * 4] ;iau elementul din vector

	jmp gata_g

eroare_elem2:
	mov rdi, eroare
	xor eax, eax
	call printf

invalid_g:
	mov eax, -1 ;pun -1 in caz de eroare

gata_g:
	leave
	ret

push_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the push_element function
	mov eax, dword [rdi + 8] ;iau lungimea
	mov ecx, dword [rdi + 12] ;iau capacitatea

	cmp eax, ecx
	jl add

double:
	push r12
	push r13

	mov r12, rdi
	mov r13d, esi

	mov eax, dword [r12 + 12] ;iau capacitatea
	mov r8d, 2 ;pun 2 ca sa dublez
	mul r8d ;o dublez
	mov dword [r12 + 12], eax ;salvez noua capacitate

	mov r8d, 4 ;dimensiunea unui int
	mul r8d

	mov rsi, rax
	mov rdi, [r12 + 0] ;iau adresa veche a vectorului
	call realloc
	mov [r12 + 0], rax ;salvez noua adresa

	mov rdi, r12
	mov esi, r13d

	pop r13
	pop r12

add:
	mov eax, dword [rdi + 8] ;iau lungimea
	mov r8, [rdi + 0] ;iau adresa vectorului
	mov dword [r8 + rax * 4], esi ;pun elementul la final

	mov r9d, eax
	inc r9d
	mov dword [rdi + 8], r9d ;cresc lungimea

	leave
	ret

pop_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the pop_element function
	push r12
	push r13

	mov r12, rdi

	mov eax, dword [r12 + 8] ;iau lungimea
	cmp eax, 0 ;verific daca vectorul e gol
	je invalid_p

	dec eax ;scad lungimea
	mov dword [r12 + 8], eax ;salvez lungimea

	mov r8, [r12 + 0] ;iau adresa vectorului
	mov r13d, dword [r8 + rax * 4] ;iau ultimul element

	mov eax, dword [r12 + 12] ;iau capacitatea
	shr eax, 1 ;o impart la 2

	cmp dword [r12 + 8], eax ;verific daca trebuie injumatatit
	jg gata_p

	cmp eax, 0 ;verific sa nu devina 0 capacitatea
	je gata_p

	mov dword [r12 + 12], eax ;salvez noua capacitate

	mov rdi, 4 ;dimensiunea unui int
	mul rdi

	mov rsi, rax
	mov rdi, [r12 + 0] ;iau adresa vectorului
	call realloc
	mov [r12 + 0], rax ;salvez noua adresa

	jmp gata_p

gata_p:
	mov eax, r13d
	jmp end_p

invalid_p:
	mov rdi, empty
	xor eax, eax
	call printf

	mov eax, -1 ;pun -1 in caz de eroare
end_p:
	pop r13
	pop r12

	leave
	ret

print_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the print_vector function
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi
	mov r14d, dword [r12 + 12] ;iau capacitatea
	mov r13d, dword [r12 + 8] ;iau lungimea

	mov rdi, first
	xor eax, eax
	call printf

	xor r15, r15 ;index

start:
	cmp r15d, r13d
	jge start_nth

	mov r8, [r12 + 0] ;iau adresa vectorului
	mov esi, dword [r8 + r15 * 4] ;iau elementul curent

	mov rdi, element
	xor eax, eax
	call printf

	inc r15d
	jmp start

start_nth:
	cmp r15d, r14d
	jge end

	mov rdi, nth
	xor eax, eax
	call printf

	inc r15d
	jmp start_nth

end:
	mov esi, r13d
	mov edx, r14d
	mov rdi, last
	xor eax, eax
	call printf

	pop r15
	pop r14
	pop r13
	pop r12

	leave
	ret

free_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; TODO - write the free_vector function

	push r12
	push r13

	mov r12, rdi

	mov r13, [r12]

	cmp r13, 0 ;verific daca vectorul e deja gol
	je end_free

	mov rdi, [r13 + 0] ;iau adresa vectorului
	call free

	mov rdi, r13
	call free

	mov qword [r12], 0 ;il setez pe null

end_free:
	pop r13
	pop r12

	leave
	ret
