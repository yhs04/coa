%macro WRITE 02
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
	err1 db "INVALID",10
	len1 equ $-err1
	err2 db "not open" ,10
	len2 equ $-err2
section .bss
	fname resb 50
	fd resq 01
	buffer resb 100
	actl resq 1
section .text
	global _start

_start:
	pop rcx
	cmp rcx,02H
	jne error1
	pop rcx 
	pop rcx
	mov rsi, fname

	mov rdx,00H
  up:mov bl, byte[rcx+rdx]
	cmp bl, 00H
 	je down
	mov byte[rsi+rdx],bl
	inc rdx
	jmp up

	down:
	mov byte[rsi+rdx],00H

	mov rax, 02  ;to open the file
	mov rdi, fname
	mov rsi, 00H
	mov rdx, 0644H
	syscall
	cmp rax, 00H
	je error2
	mov [fd],rax
	up1:
	mov rax, 00H
	mov rdi,[fd]
	mov rsi, buffer
	mov rdx,100
	syscall
	mov[actl],rax
	WRITE buffer,[actl]
	cmp qword[actl],100
	je up1

	mov rax,03  ;to close the file
	mov rdi,[fd]
	syscall

	exit:mov rax,60
	mov rdi,00
	syscall

	error1:WRITE err1,len1
	jmp exit
	error2:WRITE err2,len2
	jmp exit


