;rbx Store the result

%macro READ 02
mov rax,00
mov rdi,00
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro WRITE 02
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

Section .data
	menu    db 10,"1.Successive Additio",10
	menulen equ $-menu

	msg1 db "Enter two numbers",10
	len1 equ $-msg1
	msg2 db "The Multiplication is",10
	len2 equ $-msg2	
	

section .bss
	m resq 1
	n resq 1
	ans resq 1
	charbuff resb 17
	actl resq 1
	choice resb 2
	a resq 1
	b resq 1
	q resq 1
	N resq 1

section .text
	global _start

_start:

	WRITE msg1,len1
	READ charbuff, 17  ; 64bit= 16 digit and 1 enter
	call accept        ;convert ascii to hex 
	mov [m], rbx
	READ charbuff, 17
	call accept
	mov [n], rbx

	WRITE menu, menulen
	succadd: 
		mov rcx,[n]	;n will update 
		mov rbx,00;	;initial rbx store 0
		up:
			add rbx,[m]
			dec rcx		;rcx is loop counter
			jnz up
		mov [ans],rbx		;rbx will change while printing the message
		WRITE msg2,len2
		mov rbx,[ans]
		call display
		
	
	
	
	
accept:
	dec rax
	mov [actl], rax
	mov rbx, 00
	mov rsi, charbuff

	up2:
		shl rbx, 04h
		mov rdx, 00h
		mov dl, byte[rsi]
		cmp dl, 39h
		jbe sub30
		sub dl, 07h

		sub30: 
			sub dl, 30h
			add rbx, rdx
			inc rsi
			dec qword[actl]
			jnz up2
			ret


display:
	mov rsi, charbuff
	mov rcx, 16

	up1:
		rol rbx, 04h
		mov dl, bl
		and dl, 0fh
		cmp dl, 09h
		jbe add30
		add dl, 07h
		add30:
			add dl, 30h
			mov byte[rsi], dl
			inc rsi
			dec rcx
			jnz up1
			WRITE charbuff,16
			ret

		
