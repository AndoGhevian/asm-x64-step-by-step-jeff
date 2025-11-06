; Executable    :   hexdumpgcc
; Version       :   1.0.0
; Created Date  :   Nov 6 2025
; Updated Date  :   ---
; Author        :   Andranik Ghevondyan
; Description   :   A program on assembly for Linux
;                   using NASM 2.16 under SAMS IDE, build
;                   using default build setup of SASM for x64
;                   with C runtime.
;                   provide a hex dump of a file's binary data
;                   through 16 hex 2 digit pairs
; use standard input: hexdump < (input file)
section .bss
    BUFFLEN equ 16                                                          ; read 16 bytes at a time from file
    Buff:   resb BUFFLEN                                                    ; buffer to read file into
section .data
                                                                            ; empty line of ascii hex representation
    HexStr: db  " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",0ah      ; of buffer of 16 bytes, ending with EOL
    HEXLEN  equ $-HexStr                                                    ; length of a hex representation line
    
    Digits: db  "0123456789ABCDEF"                                          ; ascii hex digits "lookup table"
section .text
    global main                             ; need for linker to find entry point
main:
    mov rbp, rsp; for correct debugging                                       ; program entry point label used by C runtime                          
    mov rbp,rsp                             ; SASM needs this for correct debugging
    ;mov rax,'World!'                       ; for debugging purposes
    ; read a full buffer from file
Read:
    mov rax,0                               ; specify sys_read call
    mov rdi,0                               ; fd to read from
    mov rsi,Buff                            ; specify where to read buffer
    mov rdx,BUFFLEN                         ; bytes count to read into buffer
    syscall                                 ; read system call from Standard Input
    cmp rax,0                               ; check if input reached EOF
    jz  Done                                ; jump to done if no content remain
    mov r15,rax                             ; save read bytes count
    
    xor rcx,rcx                             ; zero index into buffer
Scan:
    xor rax,rax                             ; zero byte storage

    cmp rcx,r15                             ; check if index reached read bytes count
    jae  SkipByteRetrieve                   ; do not retrieve byte if end (keep value at 0)
    mov al,byte [Buff+rcx]                  ; take appropriate byte by index
SkipByteRetrieve:
    mov rbx,rax                             ; copy byte for most significant nybble

    ; calculate offset into ascii hex digits table
    ; for current byte hex pair entity
    mov rdx,rcx                             ; copy entity index
    shl rdx,1                               ; shift left for multiply by 2
    add rdx,rcx                             ; multipied by X3 for offset
    ; set low nybble
    and al,0Fh                              ; mask out high nybble
    mov al,byte [Digits+rax]                ; ascii hex digit for low nybble
    mov byte [HexStr+rdx+2],al              ; set low nybble ascii hex digit
    ; set high nybble
    shr bl,4                                ; shift out low nybble
    mov bl,[Digits+rbx]                     ; lookup nybble appropriate ascii hex digit
    mov byte [HexStr+rdx+1],bl              ; set high nybble ascii hex digit in hex string line
    
    inc rcx
    cmp rcx,BUFFLEN                         ; check if buffer ascii hex digits string is filled
    jb  Scan                                ; if not, jump to scan start
Write:
    mov rax,1                               ; specify sys_write call
    mov rdi,1                               ; fd 1 Standard Output
    mov rsi,HexStr                          ; write out HexStr ascii hex digits line
    mov rdx,HEXLEN                          ; number of characters to write out
    syscall                                 ; sys_write system call
    jmp Read                                ; jump to read from file
Done:
    ret                                     ; return to glibc runtime shutdown code
