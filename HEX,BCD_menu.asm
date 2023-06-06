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
    msg1 db "Enter the HEX : ",10
    len1 equ $-msg1
    msg2 db "The Hex value is : ",10
    len2 equ $-msg2
    msg5 db "",10
    len5 equ $-msg5
    msg3 db "The BCD is : ",10
    len3 equ $-msg3
    msg4 db "Enter the BCD : ",10
    len4 equ $-msg4

section .bss
    char_buff resb 17
    actl resq 1
    ans resq 1
    X resb 1
    cnt resb 1

section .text
    global _start
    _start:
        ;BCD TO HEX
        WRITE msg4,len4
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

        ;HEX TO BCD
        WRITE msg5,len5
        WRITE msg1,len1
        READ char_buff,17
        call accept
        mov byte[cnt],00H
        mov rax,rbx       
        up2:mov rbx,0AH
        mov rdx,00
        div rbx
        push rdx
        inc byte[cnt]
        cmp rax,00
        jne up2
        WRITE msg3,len3
        up1:pop rdx
        add dl,30H
        mov byte[X],dl
        WRITE X,1
        dec byte[cnt]
        jnz up1       

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

accept:
    dec rax
    mov [actl],rax
    mov rbx,00
    mov rsi,char_buff
        up3: shl rbx,04H
    mov rdx,00H
    mov dl,byte[rsi]
    cmp dl,39H
    jbe sub30
    sub dl,07H
    sub30: sub dl,30H
    add rbx,rdx
    inc rsi
    dec qword[actl]
    jnz up3
    ret
