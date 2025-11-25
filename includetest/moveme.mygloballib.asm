; make sure this file is moved to /usr/share/sasm/include/mygloballib.asm
section .data
section .text
GlobalLib:
    mov rax,1
    mov rdi,1
    mov rsi,GlobalLibMessage
    mov rdx,GlobalLibMessageLen
    syscall

    ret
; this data goes inside text section adjacent to instruction bytes
; it is safe becuase ret does not allow it to be reached.
GlobalLibMessage db "Hello Global Lib!!!",10
GlobalLibMessageLen equ $-GlobalLibMessage
