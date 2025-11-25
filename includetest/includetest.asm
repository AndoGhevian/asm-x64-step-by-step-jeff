section .bss
section .data
section .text
    global main

; Include can take any realtive source code file path
%INCLUDE "locallib.asm"
%include "subdir/sublib.asm"
; below icnlude comes from sasm include path for global libraries
; make sure assembly options in sasm build settings specify
; include directory as nasm parameter -I /usr/share/sasm/include
%INCLUDE "mygloballib.asm"
main:
    mov rbp, rsp; for correct debugging

    call LocalLib
    call SubLib
    call GlobalLib
    ret
