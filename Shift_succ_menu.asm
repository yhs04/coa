%macro WRITE 02
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro READ 02

mov rax,00
mov rdi,00
mov rsi,%1
mov rdx,%2
syscall

%endmacro

section .data
msg1 db 10,"Enter two numbers: ",10
len1 equ $-msg1

msg2 db "Multiplication: ",10
len2 equ $-msg2

menu db 10,"1.SUCC_ADD",10
     db "2.SHIFT_and_ADD",10
     db "3.Exit",10
     db "Enter your choice: ",10
menulen equ $-menu

msg3 db "Wrong choice! ",10
len3 equ $-msg3

msg4 db " ",10
len4 equ $-msg4

section .bss
choice resb 02
char_buff resb 17
actl resq 1
ans resq 1
m resq 1
n resq 1
a resq 1
b resq 1
q resq 1
N resq 1

section .text
global _start
_start:
WRITE msg1, len1
READ char_buff, 17
call accept
mov[m], rbx
READ char_buff, 17
call accept
mov[n], rbx
menumsg: 
WRITE menu, menulen
READ choice, 02

cmp byte[choice], 31H
je SUCC_ADD

cmp byte[choice], 32H
je SHIFT_and_ADD

cmp byte[choice], 33H
je Exit

WRITE msg3, len3
jmp menumsg


SUCC_ADD:
mov rcx,[n]
mov rbx, 00
up:
add rbx, [m]
dec rcx
jnz up
mov[ans], rbx

WRITE msg2, len2
mov rbx, [ans]
call display
jmp menumsg

SHIFT_and_ADD:
mov qword[a],00H
mov rbx,[m]
mov[b],rbx
mov rbx,[n]
mov[q],rbx
mov byte[N],64
up3:
 mov rbx,[q]
 and rbx,01H
 jz shiftaq
 mov rbx,[b]
 add[a],rbx
 shiftaq:
 shr qword[q],01H
 mov rbx,[a]
 and rbx,01H
 jz shifta
 mov rbx,01H
 ror rbx,01H
 or qword[q],rbx
 shifta:
 shr qword[a],01H
 dec byte[N]
jnz up3
WRITE msg2,len2

mov rbx,[a]
call display
mov rbx,[q]
call display
jmp menumsg

Exit:
mov rax, 60
mov rdi, 00
syscall 

display:
mov rsi, char_buff
mov rcx,16

above: rol rbx,04H
mov dl, bl
and dl,0FH
cmp dl,09H
jbe add30
add dl, 07H
add30:add dl,30H
mov byte[rsi], dl
inc rsi
dec rcx
jnz above

WRITE char_buff, 17
ret

accept:
dec rax
mov [actl], rax
mov rbx, 00H
mov rsi, char_buff

up1:
shl rbx, 04H
mov rdx, 00H
mov dl, byte[rsi]

cmp dl, 39H
jbe sub30
sub dl, 07H
sub30:
sub dl, 30H

add rbx, rdx
inc rsi
dec qword[actl]
jnz up1
ret



