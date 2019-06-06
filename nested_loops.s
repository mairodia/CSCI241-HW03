;;;
;;; hello.s
;;; Prints "Hello, world!"
;;;

section .data

msg:            db      "Hello, world!", 10, 0
MSGLEN:         equ     $-msg

section .text

global _start
_start:

    mov     rax,    1               ; Syscall code in rax
    mov     rdi,    1               ; 1st arg, file desc. to write to
    mov     rsi,    msg             ; 2nd arg, addr. of message
    mov     rdx,    1               ; 3rd arg, num. of chars to print
    mov     rcx,    MSGLEN          ; loop counter

    .outer_loop:
        mov r15, rcx                ; r15 = rcx
        mov r8, rsi                 ; temp storage of rsi
        mov r9, r15                 ; inner loop counter

        .inner_loop:
            cmp r9, MSGLEN              ; is i = MSGLEN ?
            je .exit_inner_loop         ; if so, exit

            mov rsi, msg + MSGLEN-9     ; rsi = space
            syscall                     ; print space

            inc r9                      ; i ++

            jmp .inner_loop             ; repeat

        .exit_inner_loop:

        mov rsi, r8                 ; restore rsi
        syscall                     ; print letter
        inc rsi                     ; mov to next char
        mov r8, rsi                 ; temp storage

        mov rsi, msg + MSGLEN - 2   ; rsi = new line
        syscall                     ; print new line

        mov rcx, r15                ; rcx = r15
        mov rsi, r8                 ; restore rsi

        loop .outer_loop            ; -- rcx

    ;; Terminate process
    mov     rax,    60              ; Syscall code in rax
    mov     rdi,    0               ; First parameter in rdi
    syscall                         ; End process
