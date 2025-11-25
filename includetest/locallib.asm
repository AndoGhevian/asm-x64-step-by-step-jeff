section .data
section .text
LocalLib:
    mov rax,1
    mov rdi,1
    mov rsi,LocalLibMessage
    mov rdx,LocalLibMessageLen
    syscall

    ret
; this data goes inside text section adjacent to instruction bytes
; it is safe becuase ret does not allow it to be reached.
LocalLibMessage db "Hello Local Lib!!!",10
LocalLibMessageLen equ $-LocalLibMessage
