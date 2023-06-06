%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro READ 02
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro
section .data
menu db " ",10
db " 1.String Length ",10
db " 2.String Copy ",10
db " 3.String Concat ",10
db " 4.String Reverse ",10
db " 5.String Compare ",10
db " 6.String Palindrome ",10
db " 7.String Substring ",10
db " 8.Exit ",10
db " Enter your choice: ",10
menu_len equ $-menu
msg1 db " Enter string 1 ",10
len1 equ $-msg1
msg2 db " Enter string 2 ",10
len2 equ $-msg2
msg3 db " Length of string: ",10
len3 equ $-msg3
msg4 db " Copied string: ",10
len4 equ $-msg4
msg5 db " Conactenated string: ",10
len5 equ $-msg5
msg6 db " Reverse string: ",10
len6 equ $-msg6
msg7 db "String Equal ",10
len7 equ $-msg7
msg8 db "String Not Equal ",10
len8 equ $-msg8
msg9 db "String is Palindrome ",10
len9 equ $-msg9
msg10 db "String is Not Palindrome ",10
len10 equ $-msg10
msg11 db "Substring Found",10
len11 equ $-msg11
msg12 db "Substring Not Found",10
len12 equ $-msg12
msg13 db " Invalid choice! ",10
len13 equ $-msg13
section .bss
char_buff resb 17
str1 resb 20
str2 resb 20
str3 resb 40
l1 resq 1
l2 resq 1
l3 resq 1
choice resb 02
section .text
global _start 
_start: WRITE msg1,len1
READ str1,20
dec rax
mov [l1],rax
print_menu: WRITE menu,menu_len
READ choice,02
cmp byte[choice],31H
je strlen
cmp byte[choice],32H
je strcpy
cmp byte[choice],33H
je strcat1
cmp byte[choice],34H
je strrev
cmp byte[choice],35H
je strcmp1
cmp byte[choice],36H
je strpal
cmp byte[choice],37H
je strstr
cmp byte[choice],38H
je exit
exit:
mov rax,60
mov rdi,0
syscall
strlen: WRITE msg3,len3
mov rbx,[l1]
call display
jmp print_menu
strcpy: mov rsi,str1
mov rdi,str3
mov rcx,[l1]
cld ; clears the direction for incrementing the pointer
rep movsb ; to copy a string item byte by byte
WRITE msg4,len4
WRITE str3,[l1]
jmp print_menu
strcat1: WRITE msg2,len2
READ str2,20
dec rax
mov [l2],rax
mov rsi,str1
mov rdi,str3
mov rcx,[l1]
cld
rep movsb ; Comparison of two strings using REPE(rep.till equal) prefix
mov rsi,str2
mov rcx,[l2]
rep movsb
mov rax,[l1]
add rax,[l2]
mov [l3],rax
WRITE msg5,len5
WRITE str3,[l3]
jmp print_menu
strrev: mov rsi,str1
mov rdi,str2
add rdi,[l1]
dec rdi
mov rcx,[l1]
up2: mov dl,byte[rsi]
mov byte[rdi],dl
inc rsi
dec rdi
dec rcx
jnz up2
WRITE msg6,len6
WRITE str2,[l1]
jmp print_menu
strcmp1:WRITE msg2,len2
READ str2,20
dec rax
mov [l2],rax
mov rbx,[l1]
cmp rbx,[l2]
jne ntequal
mov rsi,str1 ;source
mov rdi,str2 ;destination
cld
mov rcx,[l1]
repe cmpsb
jne ntequal
WRITE msg7,len7
jmp print_menu
ntequal: WRITE msg8,len8
jmp print_menu
strpal: mov rsi,str1
mov rdi,str2
add rdi,[l1]
dec rdi
mov rcx,[l1]
up3: mov dl,byte[rsi]
mov byte[rdi],dl
inc rsi
dec rdi
dec rcx
jnz up3
mov rsi,str1
mov rdi,str2
cld
mov rcx,[l1]
repe cmpsb ; Comparison of two strings using REPE(rep.till equal) prefix
jne ntequal1
WRITE msg9,len9
jmp print_menu
ntequal1: WRITE msg10,len10
jmp print_menu
strstr: WRITE msg2,len2
READ str2,20
dec rax
mov [l2],rax
mov rsi,str1
mov rdi,str2
mov dh,byte[rdi]
mov rbx,[l1]
mov rcx,[l2]
up4: mov dl,byte[rsi]
cmp dl,byte[rdi]
je same
cmp byte[rsi],dh
je skip
inc rsi
dec rbx
skip: mov rdi,str2
mov rcx,[l2]
jmp skip1
same: inc rsi
inc rdi
dec rbx
dec rcx
skip1: cmp rcx,00
je present
cmp rbx,00
je ntpresent
jmp up4
present: WRITE msg11,len11
jmp print_menu
ntpresent: WRITE msg12,len12
jmp print_menu
accept: dec rax
mov rcx,rax
mov rsi,char_buff
mov rbx,00
up: shl rbx,04
mov rdx,00
mov dl,byte[rsi]
cmp dl,39H
jbe sub30
sub dl,07H
sub30: sub dl,30H
add rbx,rdx
inc rsi
dec rcx
jnz up
ret
display:mov rsi, char_buff
mov rcx, 16
up1: rol rbx, 04H
mov dl, bl
and dl, 0FH
cmp dl, 09H
jbe add30
add dl,07H
add30: add dl,30H
mov byte[rsi], dl
inc rsi
dec rcx
jnz up1
WRITE char_buff, 16
Ret


