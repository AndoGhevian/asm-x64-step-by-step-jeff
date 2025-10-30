section .bss
    Buff resb 1
section .data
                                ; Same letter Ascii case difference actually is
    AsciiCaseDiff: equ 'a'-'A'  ; 20h, but i want calculate it using assembly-time
                                ; calculations
section .text
    global main

main:
    mov rbp,rsp                     ; for correct debugging

Read:
    mov rax,0                       ; 0 = sys_read number code for service dispatcher
    ; passing parameters for read syscall
    mov rdi,0                       ; fd to read from: 0 is Standard Input
    mov rsi,Buff                    ; address of buffer to read to
    mov rdx,1                       ; try to read 1 character from file
    syscall
    
    cmp rax,0                       ; test syscall read result for EOF
    je Exit
    
    cmp byte [Buff],'a'             ; compare to lowercase lower bound character a
    jb  Write                       ; jump to write if less than a
    cmp byte [Buff],'z'             ; compare to lowercase upper bound character z
    ja  Write                       ; jump to write if greater than z
    
    sub byte [Buff],AsciiCaseDiff   ; subtract from lowercase ascii letter
                                    ; case difference for ascii characters
                                    ; to get appropriate uppercase ascii letter

Write:
    mov rax,1                       ; 0 = sys_write syscall number for service dispatcher
    ; pass parameters for write syscall
    mov rdi,1                       ; fd for standard output 1
    mov rsi,Buff                    ; address of a buffer for writing to output
    mov rdx,1                       ; buffer actually is 1 character length
    syscall                         ; do syst_write system call with provided parameters
    jmp Read                        ; go to read next character

Exit: ret
