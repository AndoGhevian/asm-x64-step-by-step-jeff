section .bss
section .data
    ; assembly-time error because of redefining label (first-most is the original one)
    ; EOLs db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
section .text
    global main
; -------------------------------------------------
; Newlines:     Send between 1-15 newlines to the Linux console
; VERSION:      1.0
; UPDATED:      20.11.2025
; IN:           EDX # of newlines to send, from 1 to 15
; RETURNS:      Nothing
; MODIFIES:     RAX, RDI, RSI
; CALLS:        kernel sys_write
; DESCRIPTION:  Send to stdout RDX specified number of newline (0Ah)
; characters if no more than 15, or nothing. Procedure demonstrates
; placing constant data in procedure definition itself, rather in .data
; or .bss sections

newline:
    
    cmp rdx,15      ; compare asked number of newlines to 15
    ja  .exit       ; exit if more than 15 newlines asked
    mov rsi,EOLs    ; put address of EOLs table in sys_write parameter
    mov rax,1       ; syswrite number
    mov rdi,1       ; standard output file descriptor
    syscall         ; make a sys_write system call
.exit:
    ret             ; Go home!
; actually below is a NASM's pseudoinstruction for defining
; data that is used only by single procedure, also technically
; it is global data item definition
EOLs db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10

main:
    mov rbp, rsp; for correct debugging
    mov rdx,4
    call newline
    ret ; return to C runtime
; assembly-time error because of redefining label (first-most is the original one)
;EOLs db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
