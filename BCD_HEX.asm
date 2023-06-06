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
    msg1 db "Enter the BCD : ",10
    len1 equ $-msg1
    msg2 db "The Hex value is : ",10
    len2 equ $-msg2

section .bss
    char_buff resb 17
    actl resq 1
    ans resq 1

section .text
    global _start
    _start:
        ;BCD TO HEX
        WRITE msg1,len1
        READ char_buff,17
        dec rax
        mov [actl],rax
        mov rax,00
        mov rsi,char_buff
        mov rbx,0AH
        up:mul rbx
        mov rdx,00H
        mov dl,byte[rsi]
        sub dl,30H
        add rax,rdx
        inc rsi
        dec qword[actl]
        jnz up
       
        mov [ans],rax
        WRITE msg2,len2
        mov rbx,[ans]
        call display
   
        mov rax,60
        mov rdx,00
        syscall

display:
    mov rcx,16
    mov rsi,char_buff
    above: rol rbx,04H
    mov dl,bl
    and dl,0FH
    cmp dl,09H
    jbe add30
    add dl,07H
    add30: add dl,30H
    mov byte[rsi],dl
    inc rsi
    dec rcx
    jnz above
    WRITE char_buff,16
    ret

