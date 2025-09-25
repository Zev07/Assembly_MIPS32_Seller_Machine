#===============================================================================
# TRABALHO 1 - PROGRAMAÇÃO ASSEMBLY PARA ARQUITETURA MIPS32
# MÁQUINA AUTOMÁTICA DE VENDAS (ASM)
#
# PARTE 1: INICIALIZAÇÃO E ESTRUTURA BÁSICA
# Responsável: Zëv e Jhonny
#
# DESCRIÇÃO:
# Este módulo é responsável pela inicialização dos registradores
# e fluxo principal (cálculo valor inserido, verificação, troco)
#===============================================================================

.data
    #---------------------------------------------------------------------------
    # MENSAGENS PARA EXIBIÇÃO NO VISOR DA MÁQUINA
    #---------------------------------------------------------------------------
    msg_valor_pago:         .asciiz "Valor pago: R$"
    msg_valor_produto:      .asciiz "Valor do produto selecionado: R$"
    msg_troco:              .asciiz "Troco: R$"
    msg_virgula:            .asciiz ","
    msg_insuficiente:       .asciiz "Valor insuficiente para compra."
    msg_nova_linha:         .asciiz "\n"
    
    #---------------------------------------------------------------------------
    # MENSAGENS PARA EXIBIR QUANTIDADES DE DENOMINAÇÕES DO TROCO
    #---------------------------------------------------------------------------
    msg_nota_20:            .asciiz "Notas R$20: "
    msg_nota_10:            .asciiz "Notas R$10: "
    msg_nota_5:             .asciiz "Notas R$5: "
    msg_nota_2:             .asciiz "Notas R$2: "
    msg_moeda_1:            .asciiz "Moedas R$1: "
    msg_moeda_50c:          .asciiz "Moedas R$0,50: "
    msg_moeda_25c:          .asciiz "Moedas R$0,25: "
    msg_moeda_10c:          .asciiz "Moedas R$0,10: "
    msg_moeda_5c:           .asciiz "Moedas R$0,05: "
    
    #---------------------------------------------------------------------------
    # MENSAGENS PARA ENTRADA DO USUÁRIO
    #---------------------------------------------------------------------------
    msg_input_nota_20:      .asciiz "Digite a quantidade de notas de R$20: "
    msg_input_nota_10:      .asciiz "Digite a quantidade de notas de R$10: "
    msg_input_nota_5:       .asciiz "Digite a quantidade de notas de R$5: "
    msg_input_nota_2:       .asciiz "Digite a quantidade de notas de R$2: "
    msg_input_moeda_1:      .asciiz "Digite a quantidade de moedas de R$1: "
    msg_input_moeda_50c:    .asciiz "Digite a quantidade de moedas de R$0,50: "
    msg_input_moeda_25c:    .asciiz "Digite a quantidade de moedas de R$0,25: "
    msg_input_moeda_10c:    .asciiz "Digite a quantidade de moedas de R$0,10: "
    msg_input_produto:      .asciiz "Digite o valor do produto em centavos (ex: 350 para R$3,50): "

.text
.globl main
#===============================================================================
# FUNÇÃO MAIN - PONTO DE ENTRADA DO PROGRAMA
#
# RESPONSABILIDADE:
#   - Inicialização dos registradores com dados do usuário
#   - Chama módulos de cálculo, formatação e troco
#
# REGISTRADORES UTILIZADOS:
#   $s0..$s7 = quantidades inseridas por denominação (entrada do usuário)
#              depois sobrescritas pelo cálculo do troco
#   $t9      = valor do produto selecionado em centavos (ex: R$3,50 -> 350)
#   $t1      = valor total inserido em centavos
#   $t0      = valor do troco em centavos
#===============================================================================
main:
    #---------------------------------------------------------------------------
    # BLOCO 1: ENTRADA DOS DADOS PELO USUÁRIO
    #---------------------------------------------------------------------------
    
    # Solicitar entrada das notas de R$20
    li      $v0, 4
    la      $a0, msg_input_nota_20
    syscall
    li      $v0, 5
    syscall
    move    $s0, $v0                    # $s0 = quantidade de notas de R$20

    # Solicitar entrada das notas de R$10
    li      $v0, 4
    la      $a0, msg_input_nota_10
    syscall
    li      $v0, 5
    syscall
    move    $s1, $v0                    # $s1 = quantidade de notas de R$10

    # Solicitar entrada das notas de R$5
    li      $v0, 4
    la      $a0, msg_input_nota_5
    syscall
    li      $v0, 5
    syscall
    move    $s2, $v0                    # $s2 = quantidade de notas de R$5

    # Solicitar entrada das notas de R$2
    li      $v0, 4
    la      $a0, msg_input_nota_2
    syscall
    li      $v0, 5
    syscall
    move    $s3, $v0                    # $s3 = quantidade de notas de R$2

    # Solicitar entrada das moedas de R$1
    li      $v0, 4
    la      $a0, msg_input_moeda_1
    syscall
    li      $v0, 5
    syscall
    move    $s4, $v0                    # $s4 = quantidade de moedas de R$1

    # Solicitar entrada das moedas de R$0,50
    li      $v0, 4
    la      $a0, msg_input_moeda_50c
    syscall
    li      $v0, 5
    syscall
    move    $s5, $v0                    # $s5 = quantidade de moedas de R$0,50

    # Solicitar entrada das moedas de R$0,25
    li      $v0, 4
    la      $a0, msg_input_moeda_25c
    syscall
    li      $v0, 5
    syscall
    move    $s6, $v0                    # $s6 = quantidade de moedas de R$0,25

    # Solicitar entrada das moedas de R$0,10
    li      $v0, 4
    la      $a0, msg_input_moeda_10c
    syscall
    li      $v0, 5
    syscall
    move    $s7, $v0                    # $s7 = quantidade de moedas de R$0,10

    # Solicitar valor do produto
    li      $v0, 4
    la      $a0, msg_input_produto
    syscall
    li      $v0, 5
    syscall
    move    $t9, $v0                    # $t9 = valor do produto em centavos

    #---------------------------------------------------------------------------
    # BLOCO 2: CALCULAR VALOR TOTAL INSERIDO
    #---------------------------------------------------------------------------
    jal     calcular_valor_inserido     # retorna em $v0 = total em centavos
    move    $t1, $v0                    # $t1 = valor total inserido em centavos

    #---------------------------------------------------------------------------
    # BLOCO 3: COMPARAÇÃO E FLUXO (SUFICIENTE / INSUFICIENTE)
    #---------------------------------------------------------------------------
    sub     $t0, $t1, $t9               # $t0 = valor inserido - valor produto
    bltz    $t0, valor_insuficiente     # se negativo, valor insuficiente
    # Se chegou aqui -> valor suficiente (ou exato)
    
    # Exibir valor pago
    li      $v0, 4
    la      $a0, msg_valor_pago
    syscall
    move    $a0, $t1                    # passar valor pago em centavos
    jal     exibir_valor_monetario
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Exibir valor do produto
    li      $v0, 4
    la      $a0, msg_valor_produto
    syscall
    move    $a0, $t9                    # valor do produto em centavos
    jal     exibir_valor_monetario
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Exibir troco
    li      $v0, 4
    la      $a0, msg_troco
    syscall
    move    $a0, $t0                    # troco em centavos
    jal     exibir_valor_monetario
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    #---------------------------------------------------------------------------
    # BLOCO 4: CALCULAR DISTRIBUIÇÃO OTIMIZADA DO TROCO
    #---------------------------------------------------------------------------
    move    $a0, $t0                    # argumento: troco em centavos
    jal     calcular_troco_otimizado
    # resultados: $s0..$s7 e $t9 preenchidos com quantidades de cada denominação
    
    #---------------------------------------------------------------------------
    # BLOCO 5: EXIBIR QUANTIDADES DE CADA DENOMINAÇÃO DO TROCO
    #---------------------------------------------------------------------------
    
    # Notas R$20
    li      $v0, 4
    la      $a0, msg_nota_20
    syscall
    li      $v0, 1
    move    $a0, $s0
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Notas R$10
    li      $v0, 4
    la      $a0, msg_nota_10
    syscall
    li      $v0, 1
    move    $a0, $s1
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Notas R$5
    li      $v0, 4
    la      $a0, msg_nota_5
    syscall
    li      $v0, 1
    move    $a0, $s2
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Notas R$2
    li      $v0, 4
    la      $a0, msg_nota_2
    syscall
    li      $v0, 1
    move    $a0, $s3
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Moedas R$1
    li      $v0, 4
    la      $a0, msg_moeda_1
    syscall
    li      $v0, 1
    move    $a0, $s4
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Moedas R$0,50
    li      $v0, 4
    la      $a0, msg_moeda_50c
    syscall
    li      $v0, 1
    move    $a0, $s5
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Moedas R$0,25
    li      $v0, 4
    la      $a0, msg_moeda_25c
    syscall
    li      $v0, 1
    move    $a0, $s6
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Moedas R$0,10
    li      $v0, 4
    la      $a0, msg_moeda_10c
    syscall
    li      $v0, 1
    move    $a0, $s7
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Moedas R$0,05
    li      $v0, 4
    la      $a0, msg_moeda_5c
    syscall
    li      $v0, 1
    move    $a0, $t9
    syscall
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Encerrar programa com sucesso
    li      $v0, 10
    syscall
#===============================================================================
# ROTINA: VALOR INSUFICIENTE
# Exibe mensagem de erro quando o valor inserido é menor que o valor do produto
#===============================================================================
valor_insuficiente:
    # Exibir mensagem de valor insuficiente
    li      $v0, 4
    la      $a0, msg_insuficiente
    syscall
    
    # Nova linha
    li      $v0, 4
    la      $a0, msg_nova_linha
    syscall
    
    # Encerrar programa
    li      $v0, 10
    syscall
#===============================================================================
# FUNÇÃO: calcular_valor_inserido
#
# DESCRIÇÃO: Calcula o valor total inserido pelo usuário somando todas as
#             denominações multiplicadas por seus respectivos valores
#
# ENTRADA:    $s0..$s7 = quantidades por denominação
# SAÍDA:     $v0      = valor total em centavos
#===============================================================================
calcular_valor_inserido:
    # Salvar registradores na pilha
    addi    $sp, $sp, -8
    sw      $ra, 4($sp)
    sw      $s0, 0($sp)
    
    # Inicializar acumulador
    li      $v0, 0                      # acumula total em centavos
    
    # Cédulas de R$20,00 ($s0 * 2000)
    mul     $t0, $s0, 2000
    add     $v0, $v0, $t0
    
    # Cédulas de R$10,00 ($s1 * 1000)
    mul     $t0, $s1, 1000
    add     $v0, $v0, $t0
    
    # Cédulas de R$5,00 ($s2 * 500)
    mul     $t0, $s2, 500
    add     $v0, $v0, $t0
    
    # Cédulas de R$2,00 ($s3 * 200)
    mul     $t0, $s3, 200
    add     $v0, $v0, $t0
    
    # Moedas de R$1,00 ($s4 * 100)
    mul     $t0, $s4, 100
    add     $v0, $v0, $t0
    
    # Moedas de R$0,50 ($s5 * 50)
    mul     $t0, $s5, 50
    add     $v0, $v0, $t0
    
    # Moedas de R$0,25 ($s6 * 25)
    mul     $t0, $s6, 25
    add     $v0, $v0, $t0
    
    # Moedas de R$0,10 ($s7 * 10)
    mul     $t0, $s7, 10
    add     $v0, $v0, $t0
    
    # Restaurar registradores e retornar
    lw      $s0, 0($sp)
    lw      $ra, 4($sp)
    addi    $sp, $sp, 8
    jr      $ra
#===============================================================================
# FUNÇÃO: exibir_valor_monetario
#
# DESCRIÇÃO: Exibe valor monetário formatado como "reais,centavos"
#             Exemplo: 2750 centavos -> "27,50"
#
# ENTRADA:    $a0 = valor em centavos
# SAÍDA:     Imprime o valor formatado (sem o símbolo R$)
#
# NOTA:       O chamador deve imprimir o prefixo "R$" antes de chamar esta função
#===============================================================================
exibir_valor_monetario:
    # Salvar registradores na pilha
    addi    $sp, $sp, -12
    sw      $ra, 8($sp)
    sw      $t2, 4($sp)
    sw      $t3, 0($sp)
    
    # Dividir centavos por 100 para separar reais e centavos
    li      $t2, 100
    div     $a0, $t2
    mflo    $t3                         # $t3 = reais (parte inteira)
    mfhi    $t4                         # $t4 = centavos (resto)
    
    # Imprimir parte dos reais
    li      $v0, 1
    move    $a0, $t3
    syscall
    
    # Imprimir vírgula separadora
    li      $v0, 4
    la      $a0, msg_virgula
    syscall
    
    # Imprimir centavos com 2 dígitos (adicionar zero à esquerda se necessário)
    blt     $t4, 10, ev_print_zero_first
    li      $v0, 1
    move    $a0, $t4
    syscall
    j       ev_end_print
    
ev_print_zero_first:
    # Imprimir '0' antes do dígito dos centavos
    li      $v0, 11
    li      $a0, '0'
    syscall
    li      $v0, 1
    move    $a0, $t4
    syscall
    
ev_end_print:
    # Restaurar registradores e retornar
    lw      $t3, 0($sp)
    lw      $t2, 4($sp)
    lw      $ra, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra
#===============================================================================
# FUNÇÃO: calcular_troco_otimizado
#
# DESCRIÇÃO: Calcula a distribuição otimizada do troco usando o menor número
#             possível de cédulas e moedas (algoritmo guloso)
#
# ENTRADA:    $a0 = valor do troco em centavos
# SAÍDA:     $s0..$s7 e $t9 = quantidades de cada denominação para o troco
#
# OBSERVAÇÃO: Sobrescreve os valores originais em $s0..$s7 (entrada do usuário)
#===============================================================================
calcular_troco_otimizado:
    # Salvar registradores na pilha
    addi    $sp, $sp, -8
    sw      $ra, 4($sp)
    sw      $s0, 0($sp)
    
    # Cédulas de R$20,00
    li      $t1, 2000
    div     $a0, $t1
    mflo    $s0                         # $s0 = quantidade de notas de R$20
    mfhi    $a0                         # $a0 = resto
    
    # Cédulas de R$10,00
    li      $t1, 1000
    div     $a0, $t1
    mflo    $s1                         # $s1 = quantidade de notas de R$10
    mfhi    $a0                         # $a0 = resto
    
    # Cédulas de R$5,00
    li      $t1, 500
    div     $a0, $t1
    mflo    $s2                         # $s2 = quantidade de notas de R$5
    mfhi    $a0                         # $a0 = resto
    
    # Cédulas de R$2,00
    li      $t1, 200
    div     $a0, $t1
    mflo    $s3                         # $s3 = quantidade de notas de R$2
    mfhi    $a0                         # $a0 = resto
    
    # Moedas de R$1,00
    li      $t1, 100
    div     $a0, $t1
    mflo    $s4                         # $s4 = quantidade de moedas de R$1
    mfhi    $a0                         # $a0 = resto
    
    # Moedas de R$0,50
    li      $t1, 50
    div     $a0, $t1
    mflo    $s5                         # $s5 = quantidade de moedas de R$0,50
    mfhi    $a0                         # $a0 = resto
    
    # Moedas de R$0,25
    li      $t1, 25
    div     $a0, $t1
    mflo    $s6                         # $s6 = quantidade de moedas de R$0,25
    mfhi    $a0                         # $a0 = resto
    
    # Moedas de R$0,10
    li      $t1, 10
    div     $a0, $t1
    mflo    $s7                         # $s7 = quantidade de moedas de R$0,10
    mfhi    $a0                         # $a0 = resto
    
    # Moedas de R$0,05 (restante)
    li      $t1, 5
    div     $a0, $t1
    mflo    $t9                         # $t9 = quantidade de moedas de R$0,05
    
    # Restaurar registradores e retornar
    lw      $s0, 0($sp)
    lw      $ra, 4($sp)
    addi    $sp, $sp, 8
    jr      $ra
#===============================================================================
# FIM DO PROGRAMA
#===============================================================================