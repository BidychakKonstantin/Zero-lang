section .text
    global write_bytes

write_bytes:
    mov rax, 1   
    syscall
    ret