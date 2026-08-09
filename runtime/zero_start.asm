global _start
extern zero_main


section .text
_start:

  call zero_main

.hang:
    cli    
    hlt                      
    jmp .hang