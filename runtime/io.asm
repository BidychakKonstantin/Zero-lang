global zero_print_char

section .text

zero_print_char
    mov dx, 0x3F8 ;COM1 Serial Port (0x3F8)
    out dx, al
    ret