org 0x7c00
jmp 0x0000:start

msg db 'Malu eh uma otima monitora', 13, 10, 0
endl db ' ', 13, 10, 0
number times 2 db 0
temp db 0

video_mode:
    mov ax, 0013h ;muda para o modo gráfico
    mov bh, 0 ;página de vídeo 0
    mov bl, 13 ;cor da fonte
    int 10h ;interrupção de vídeo
    ret

putc:
    mov ah, 0x0e ;número da chamada para mostrar na tela um caractere que está em al
    int 10h ;interrupção de vídeo
    ret

getc:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    ret ;após a execução dessa interrupção int 16h o caractere lido estará armazenado em al

prints:
    .loop:
        lodsb ;bota character em al 
        cmp al, 0
        je .endloop
        call putc
        jmp .loop
    .endloop:
    ret

getInt:
    xor ax, ax
    .for:
        push ax
        call getc
        mov cx, ax
        pop ax
        mov bx, 10
        mul bx
        add ax, cx
        cmp cl, 13
        je .fim
        push ax
        mov al, cl
        call putc
        pop ax
        jmp .for
    .fim:    
    ret

start:
    xor ax, ax
    mov cx, ax
    mov dx, ax

    call video_mode
    call getInt

    mov bl, al ;cor da fonte
    int 10h

    mov si,endl
    call prints    
    
    mov si, msg
    call prints
    
times 510-($-$$) db 0
dw 0xaa55