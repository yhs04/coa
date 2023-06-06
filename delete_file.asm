%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
        err1 db "Invalid no of arguements",10
        len1 equ $-err1
        err2 db "Could not open file",10
        len2 equ $-err2
	msg1 db "File deleted successfully",10
	len3 equ $-msg1
section .bss
        fname resb 50
        fd resq 01
        buffer resb 100
        actl resq 1
section .text
        global _start
_start:pop rcx
       cmp rcx,02
       jne error1
       pop rcx
       pop rcx
       mov rsi,fname
       mov rdx,00H
    up:mov bl,byte[rcx+rdx]
       cmp bl,00H
       je down
       mov byte[rsi+rdx],bl
       inc rdx
       jmp up

   down:mov byte[rsi+rdx],00H
       mov rax,02
       mov rdi,fname
       mov rsi,00H
       mov rdx,0777o
       syscall

       cmp rax,00
       jle error2
       mov rdi,rax
	mov rax,03
	syscall
	mov rax,87
	mov rdi,fname
	syscall
	WRITE msg1,len3
exit:	mov rax,60
	mov rdi,00
	syscall
error1:	WRITE error1,len1
	jmp exit
error2:	WRITE error2,len2
	jmp exit





