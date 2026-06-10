.data
fib:    .space  80
msg_in: .asciiz "Digite N (inteiro entre 3 e 19): "
msg_er: .asciiz "Valor invalido! N deve ser > 2 e < 20.\n"
msg_ml: .asciiz "\nProduto dos 2 ultimos termos (F[N-1] x F[N]): "
msg_od: .asciiz "Produto impar encontrado: "
msg_nl: .asciiz "\n"
msg_hd: .asciiz "\n--- Produtos impares entre termos consecutivos ---\n"

        .text
        .globl main

main:
pede_n:
        li   $v0, 4
        la   $a0, msg_in
        syscall

        li   $v0, 5
        syscall
        move $s0, $v0

        bgt  $s0, 2,  chk_max
        j    invalido

chk_max:
        blt  $s0, 20, valido

invalido:
        li   $v0, 4
        la   $a0, msg_er
        syscall
        j    pede_n

valido:
        la   $s1, fib

        sw   $zero, 0($s1)
        li   $t0, 1
        sw   $t0,  4($s1)

        li   $t1, 2

loop_fib:
        bgt  $t1, $s0, fim_fib

        sll  $t2, $t1, 2
        sub  $t3, $t2, 4
        sub  $t4, $t2, 8

        add  $t3, $s1, $t3
        add  $t4, $s1, $t4
        add  $t2, $s1, $t2

        lw   $t5, 0($t3)
        lw   $t6, 0($t4)
        add  $t7, $t5, $t6
        sw   $t7, 0($t2)

        addi $t1, $t1, 1
        j    loop_fib

fim_fib:
        sll  $t0, $s0, 2
        add  $t0, $s1, $t0
        lw   $t2, 0($t0)
        lw   $t3, -4($t0)
        mul  $t4, $t2, $t3

        li   $v0, 4
        la   $a0, msg_ml
        syscall

        li   $v0, 1
        move $a0, $t4
        syscall

        li   $v0, 4
        la   $a0, msg_nl
        syscall

        li   $v0, 4
        la   $a0, msg_hd
        syscall

        li   $t1, 1

loop_odd:
        bgt  $t1, $s0, fim

        sll  $t2, $t1, 2
        add  $t2, $s1, $t2
        lw   $t5, 0($t2)
        lw   $t6, -4($t2)
        mul  $t7, $t5, $t6

        andi $t8, $t7, 1
        beq  $t8, $zero, proximo

        li   $v0, 4
        la   $a0, msg_od
        syscall

        li   $v0, 1
        move $a0, $t7
        syscall

        li   $v0, 4
        la   $a0, msg_nl
        syscall

proximo:
        addi $t1, $t1, 1
        j    loop_odd

fim:
        li   $v0, 10
        syscall