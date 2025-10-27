section .data
section .text

	global main

main:
    mov rbp, rsp; for correct debugging

;    mov rbp,rsp  ; Save stack pointer for debugger
     nop
; Put your experiments between the two nops...

    xor rbx,rbx

    ; initial flags: 0246h -> 0010 0100 0110 -> PF 1, ZF 1, TF 0, IF 1
    ; trap flag set before single stepping, so when execute pushfq, it TF is set:
    ; 0346h -> 0011 0100 0110 -> PF 1, ZF 1, TF 1, IF 1
    pushfq
    pop rax

; Put your experiments between the two nops...
     nop
    
section .bss
