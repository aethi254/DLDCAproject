section .data
    shifted_disk db "Shifted disk "
    from_str db " from "
    to_str db " to "
    a_rod db 'A'
    b_rod db 'B'
    c_rod db 'C'
    newline db 10
    shifted_len equ 13
    from_len equ 6
    to_len equ 4
    buffer db 100 dup(0) ; Output buffer for result string

section .bss
    input_buf resb 20  ; Reserve 20 bytes for input
    num resq 1         ; 64-bit integer

section .text
    global printNum
    global hanoi
    global _start 
    global printFromAndTo

printNum:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to print an arbitary number stored in rax
    mov r9,0
    cmp rax,r9
    jne .notzero
    mov byte[buffer],'0'
    mov rsi,buffer
    mov rdx,1
    push rax
    mov rax,1
    mov rdi,1
    syscall
    pop rax
    ret
.notzero:
    mov rcx,10
    mov r11,0
    mov rdi,buffer+99
.tonum:
    xor rdx,rdx
    div rcx
    add dl,'0'
    dec rdi
    mov byte[rdi],dl
    inc r11
    mov r10,0
    cmp rax,r10
    jne .tonum
    mov rsi,rdi
    mov rdx,r11
    mov rax,1 
    mov rdi,1
    syscall
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printFromAndTo:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to print " from " *rax " to " *rdi
    push rbx
    push r12
    push r13
    mov r13,rax
    mov rbx,rdi
    mov r12,rsi
    mov rax,1
    mov rdi,1
    mov rsi,shifted_disk
    mov rdx,shifted_len
    syscall
    mov rax,r13
    call printNum
    mov rax, 1
    mov rdi, 1
    mov rsi, from_str
    mov rdx, from_len
    syscall
    mov byte [buffer], bl
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, to_str
    mov rdx, to_len
    syscall
    mov byte [buffer], r12b
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    pop r13
    pop r12
    pop rbx
    ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hanoi:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; C code for function
;;;; void hanoi(int n, char from, char to, char aux) {
;;;;     if (n == 1) {
;;;;         printf("Shifted disk 1 from %c to %c\n", from, to);
;;;;         return;
;;;;     }
;;;;     hanoi(n - 1, from, aux, to);
;;;;     printf("Shifted disk %d from %c to %c\n", n, from, to);
;;;;     hanoi(n - 1, aux, to, from);
;;;; }
    push rbp
    mov rbp,rsp
    push rdi
    push rsi
    push rdx
    push rcx
    mov rax,[rbp-8]
    cmp rax,1
    jne .recursion
    mov rax,1
    mov rdi,[rbp-16]
    mov rsi,[rbp-24]
    call printFromAndTo
    jmp .done
.recursion:
    mov rax,[rbp-8]
    dec rax
    mov rdi,rax
    mov rsi,[rbp-16]
    mov rdx,[rbp-32]
    mov rcx,[rbp-24]
    call hanoi
    mov rax,[rbp-8]
    mov rdi,[rbp-16]
    mov rsi,[rbp-24]
    call printFromAndTo
    mov rax,[rbp-8]
    dec rax
    mov rdi,rax
    mov rsi,[rbp-32]
    mov rdx,[rbp-24]
    mov rcx,[rbp-16]
    call hanoi
.done:
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to take in number as input, then call hanoi(num, 'A','B','C')
    mov rax,0
    mov rdi,0
    mov rsi,input_buf
    mov rdx,20
    syscall
    mov rsi,input_buf
    xor rax,rax
.convert1:  ;This section is to convert string to num and copied from loops.asm
    movzx rcx, byte [rsi] ; load byte
    cmp rcx, 10           ; check for newline
    je .done1
    sub rcx, '0'          ; convert ASCII to digit
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .convert1
.done1:
    cmp rax,0
    je .exit
    mov rdi,rax
    movzx rsi,byte[a_rod]
    movzx rdx,byte[b_rod]
    movzx rcx,byte[c_rod]
    call hanoi

.exit:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall
