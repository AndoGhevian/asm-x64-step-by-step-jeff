section .data
section .text
SubLib:
    mov rax,1
    mov rdi,1
    mov rsi,SubLibMessage
    mov rdx,SubLibMessageLen
    syscall

    ret
; this data goes inside text section adjacent to instruction bytes
; it is safe becuase ret does not allow it to be reached.
SubLibMessage db "Hello Sub Lib!!!",10
SubLibMessageLen equ $-SubLibMessage
