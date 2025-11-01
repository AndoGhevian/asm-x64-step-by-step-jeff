; Executable name:  asciiupper
; Version:          2.0
; Created date:     2025.10.31
; Last update:      2025.10.31
; Author:           Andranik Ghevondyan
; Architecture:     x64
; From:             x64 Assembly Language Step by Step, 4th Edition
; Desciption:       Optimizaed version of Standard Input to Uppercase Standard Output
;                   using NASM 2.16 built using GCC as linker

BuffSize: equ 7

section .bss
    Buffer resb BuffSize
section .data
    ErrRead     db  "Error while trying to read from file"      ; read error message
    ErrReadLen  equ $-ErrRead                                   ; calc read err length at assembly-time 
    ErrWrite    db  "Error while trying to write to file"       ; write error message
    ErrWriteLen equ $-ErrWrite                                  ; calc write error length at assembly-time
section .text
    global main
main:
    mov rbp,rsp                         ; for correct debugging
    push 0                              ; success program completion return code
Read:
    mov rax,0                           ; sys_read kernel call code for service dispatcher
    ; parameters of read kernel call
    mov rdi,0                           ; 0 = fd for read: Standard Input
    mov rsi,Buffer                      ; buffer address to read into
    mov rdx,BuffSize                    ; how many characters to read: BuffSize count
    syscall                             ; call sys_read

    cmp rax,0                           ; compare read result to 0 for EOF or Error
                                        ; if EOF no need to push 0, success result assumed
                                        ; by default (see main start)
    je  Exit                            ; jump to exit if no characters read
    cmp rax,-1                          ; check if error occured while reading
    jb  Scan                            ; if positive (success < -1 which is error)
                                        ; then buffer is filled, go to write.
                                        ; we can also compare on not equal, but
                                        ; for now i have not read about that instruction
    ; fall through here if -1, which is read error
    ; Note: in some cases the error is recoverable
    ; so you can continue try reading.
    mov rdi,2                           ; Standard Error fd = 2
    mov rsi,ErrRead                     ; read error message memory address
    mov rdx,ErrReadLen                  ; length of read error message
    push 1                              ; push 1 exit return code for read error
    jmp Error                           ; jump to error message write call
Scan:
    ; save write parameters in advance
    mov rsi,Buffer                      ; begining of a buffer to write to output
    mov rdx,rax                         ; store read characters count into sys_write
                                        ; buffer length parameter
    ; set up a pointer for buffer scan consisting of
    ; memory location address immediately before buffer as begining address
    ; and characters count as an offset
    mov r13,Buffer                      ; buffer begining address
    sub r13,1                           ; memory address immediately before buffer
    mov rbx,rax                         ; characters count in rbx as an offset
ScanIteration:
    cmp byte [r13+rbx],'a'              ; compare if lower than lowest lowercase character 'a'
    jb  ScanNext                        ; jump to next buffer scan iteration setup if lower than 'a'
    cmp byte [r13+rbx],'z'              ; compare if upper than greatest lowercase character 'z'
    ja  ScanNext                        ; do nothing if not in range 'a' <= char <= 'z'
    
    sub byte [r13+rbx],020h             ; subtract difference of same character lowercase and uppercase
ScanNext:
    dec rbx                             ; decrement characters count
    jnz ScanIteration                   ; test next character if not exhausted

Write:
    mov rax,1                           ; specify sys_write kernel call
    mov rdi,1                           ; 1 = fd for Standard Output
    ; sys_write buffer,length parameters already stored
    ; immediately after read success
    syscall                             ; call sys_write

    cmp rax,-1                          ; check if error occure while writing to output file
    jb  Read                            ; jump to read if no error occure
    ; assign error message sys_write call parameters
    ; before jump to error
    mov rsi,ErrWrite                    ; write error message begining address
    mov rdx,ErrWriteLen                 ; write error message length for sys_write
    push 2                              ; write to file error return code
    jmp Error                           ; jump to error message write call
Error:
    mov rax,1                           ; write system call code
    mov rdi,2                           ; 2 = fd for Standard Error
    ; parameters of error message already filled
    syscall                             ; call sys_write for error message
    jmp Exit                            ; after error message immidiately exit
Exit:
    ; REQUIRED: need to push return code before jump to exit
    ; NOTE:
    ; even though we use gcc to link the executable
    ; and so standard C finish code is added
    ; we will exit manually to specify return code
    ; explicitly
    mov rax,60                          ; 60 = sys_exit to exit the program
    pop rdi                             ; pop return code from stack to exit parameter rdi
    syscall                             ; call sys_exit
