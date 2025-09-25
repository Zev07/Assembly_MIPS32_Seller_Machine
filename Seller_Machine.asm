#===============================================================================
# TRABALHO 1 - PROGRAMAÇÃO ASSEMBLY PARA ARQUITETURA MIPS32
# MÁQUINA AUTOMÁTICA DE VENDAS (ASM)
#
# PARTE 1: INICIALIZAÇÃO E ESTRUTURA BÁSICA
# Responsável: Zëv e Jhonny
#
# DESCRIÇÃO:
# Este módulo é responsável pela inicialização dos registradores
#===============================================================================

.data # Espaço para reservar dados de uso geral

    # Mensagens para exibição no visor da máquina
    msg_valor_pago: .asciiz "Valor pago: R$"
    msg_valor_produto: .asciiz "Valor do produto selecionado: R$"
    msg_troco: .asciiz "Troco: R$"
    msg_virgula: .asciiz ","
    msg_insuficiente: .asciiz "Valor insuficiente para compra."
    msg_nova_linha: .asciiz "\n"

.text # Aqui começa o código executável
.globl main # declaracao de estado inicial do programa

#===============================================================================
# FUNÇÃO MAIN - PONTO DE ENTRADA DO PROGRAMA
#
# RESPONSABILIDADE: Inicialização dos registradores com dados do hardware
#
# REGISTRADORES DE ENTRADA (simulados - em máquina real vêm do hardware):
# $s0 = Quantidade de cédulas de R$20,00 inseridas
# $s1 = Quantidade de cédulas de R$10,00 inseridas
# $s2 = Quantidade de cédulas de R$5,00 inseridas
# $s3 = Quantidade de cédulas de R$2,00 inseridas
# $s4 = Quantidade de moedas de R$1,00 inseridas
# $s5 = Quantidade de moedas de R$0,50 inseridas
# $s6 = Quantidade de moedas de R$0,25 inseridas
# $s7 = Quantidade de moedas de R$0,10 inseridas
# $t9 = Valor do produto selecionado × 100 (em centavos) # Multiplicado por 100 para evitar ponto flutuante
#===============================================================================

main:
    #---------------------------------------------------------------------------
    # BLOCO 1: SIMULAÇÃO DE ENTRADA DO HARDWARE
    #
    # Em uma máquina real, estes valores seriam carregados automaticamente
    # pelo hardware de contagem de cédulas e moedas
    #---------------------------------------------------------------------------
    
    # CENÁRIO DE TESTE:
    # Cliente inseriu: 1×R$20 + 1×R$5 + 2×R$1 = R$27,00
    # Produto selecionado: R$3,50
    
    li $s0, 1      # 1 cédula de R$20,00 inserida
    li $s1, 0      # 0 cédulas de R$10,00 inseridas
    li $s2, 1      # 1 cédula de R$5,00 inserida
    li $s3, 0      # 0 cédulas de R$2,00 inseridas
    li $s4, 2      # 2 moedas de R$1,00 inseridas
    li $s5, 0      # 0 moedas de R$0,50 inseridas
    li $s6, 0      # 0 moedas de R$0,25 inseridas
    li $s7, 0      # 0 moedas de R$0,10 inseridas
    li $t9, 350    # Produto custa R$3,50 (350 centavos)
    
    #---------------------------------------------------------------------------
    # BLOCO 2: CHAMADA PARA MÓDULO DE CÁLCULOS
    #
    # Responsável: Maria Gabriela e Thays
    # Transfere controle para outras partes do sistema que serão desenvolvidas
    #---------------------------------------------------------------------------
    
    # Chama módulo de cálculo de valor total inserido
    # (Ainda vai ser implementada responsável pelo meio do código)

    jal calcular_valor_inserido # Aqui iria a chamada para o módulo de cálculo
   
    
    # Armazena resultado do cálculo
    move $t1, $v0              # $t1 = valor total inserido em centavos
    
    #---------------------------------------------------------------------------
    # BLOCO 3: VERIFICAÇÃO BÁSICA DE VALOR SUFICIENTE
    #
    # Compara valor inserido com preço do produto
    #---------------------------------------------------------------------------
    
    # Compara valor total inserido com preço do produto
    bge $t1, $t9, valor_suficiente    # Se $t1 >= $t9, valor é suficiente
    
    #---------------------------------------------------------------------------
    # FLUXO: VALOR INSUFICIENTE
    #---------------------------------------------------------------------------
    
    # Define código de retorno conforme especificação
    li $t0, 1                  # $t0 = 1 indica valor insuficiente
    
    # Exibe mensagem de erro no visor
    li $v0, 4                  # Syscall para imprimir string
    la $a0, msg_insuficiente   # Carrega endereço da mensagem
    syscall                    # Executa impressão
    
    # Termina execução (registradores $s0-$s7 não devem ser alterados)
    j fim_programa
    
    #---------------------------------------------------------------------------
    # FLUXO: VALOR SUFICIENTE
    #---------------------------------------------------------------------------
    
valor_suficiente:
    # Define código de retorno conforme especificação
    li $t0, 0                  # $t0 = 0 indica valor suficiente
    
    # NOTA: Processamento adicional (exibição de valores e cálculo de troco)
    # será implementado

    # [PLACEHOLDER PARA MÓDULOS FUTUROS] # Placeholder são comentários/anotações temporárias, também serve como estrutura temporária
    # - Exibição formatada dos valores
    # - Cálculo e distribuição otimizada do troco
    # - Atualização dos registradores de saída
    
    #---------------------------------------------------------------------------
    # FINALIZAÇÃO TEMPORÁRIA (SEM IMPLEMENTAÇÃO COMPLETA)
    #---------------------------------------------------------------------------
    
fim_programa:
    # Termina execução do programa
    li $v0, 10                 # Syscall para exit
    syscall                    # Finaliza programa
    
#===============================================================================
# ÁREA RESERVADA PARA FUNÇÕES DOS OUTROS MÓDULOS
#
# As funções abaixo serão implementadas:
# - calcular_valor_inserido: Soma todos os valores inseridos
# - exibir_valor_monetario: Formata e exibe valores no visor
# - calcular_troco_otimizado: Distribui troco com menor quantidade de cédulas <-IMPORTANTE
#===============================================================================

# [PLACEHOLDER] Função a ser implementada pelo módulo de cálculos
calcular_valor_inserido:

    li $v0, 0 #zera o registrador
    
    mul $t0, $s0, 2000 #$t0 = qntd_ced_20 *2000
    add $v0, $v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s1, 1000 # $t0 = qnt_ced_10 *1000
    add $v0,$v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s2, 500 #$t0 = qntd_ced_5 * 500
    add $v0, $v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s3, 200 # $t0 = qntd_ced_2 * 200
    add $v0, $v0, $t0 # $v0 = $v0 + $t0
    
    mul $t0, $s4, 100 #$t0 = qntd_moedas_ * 100
    add $v0, $v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s5, 50 #$t0 = qntd_moedas_50c * 50
    add $v0, $v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s6, 25 #$t0 = qntd_moedas_25c *25
    add $v0, $v0, $t0 #$v0 = $v0 + $t0
    
    mul $t0, $s7, 10 #$t0 = qntd_moedas_10c * 10
    add $v0, $v0, $t0 #$v0 = $v0 +$t0
    
    jr $ra #retorna para o chamador
    
    # TODO: Implementar cálculo do valor total inserido
    # Deve somar: ($s0×2000) + ($s1×1000) + ($s2×500) + ($s3×200) +
    #             ($s4×100) + ($s5×50) + ($s6×25) + ($s7×10)
    # Retorno em $v0: valor total em centavos
    
    jr $ra                     # Retorna para chamador

# [PLACEHOLDER] Função a ser implementada pelo módulo de interface
exibir_valor_monetario:
    #recebe o valor em centavos em $a0
    #Passo 1: Imprimir a parte dos reais
    
    li $t2, 100 #carrega 100 em $t2 para divisão
    div $a0, $t2 
    mflo $t3 #$t3 = Quociente (a parte dos reais)
    mfhi $t4 #t4 = resto (a parte dos centavos)
    
    li $v0, 1 #Syscall para imprimir inteiro
    move $a0, $t3 #move o valor dos reais para $a0
    syscall
    
    #Passo 2: Imprimir a Virgula
    li $v0, 4 #Syscall para imprimir string
    la $a0, msg_virgula # carrega o endereço da virgula
    syscall 
    
     #Passo 3: Imprimir a parte dos Centavos
     #verifica se os centavos são menores que 10 para imprimir o '0'
    blt $t4, 10, print_zero_first
    
    
    #se for >= 10, imprime direito
    li $v0, 1
    move $a0, $t4
    syscall
    j end_print_cents
    
    print_zero_first:
    li $v0, 11 #Syscall para imprimir caractere
    li $a0, '0'
    syscall
    
    li $v0, 1
    move $a0, $t4
    syscall
    
    end_print_cents: 
    #retorna para o chamador
      
        
    
    
    # TODO: Implementar formatação e exibição de valores monetários
    # Entrada: $a0 = valor em centavos
    # Saída: valor formatado como "XX,XX" no visor
    
    jr $ra                     # Retorna para chamador

# [PLACEHOLDER] Função a ser implementada pelo módulo de troco
calcular_troco_otimizado:
    #recebe o valor do troco em centavos em $a0
    # R$20,00
    
    li $t1, 2000
    div $a0, $t1
    mflo $s0  #$s0 = quociente(notas de 20)
    mfhi $a0  #$a0 = resto (novo valor do troco)
    
    #R$10,00 
    li $t1, 1000
    div $a0, $t1
    mflo $s1 #$s1 = quantidade de notas de R$10
    mfhi $a0 #$a0 = resto
    
    # R$5,00
    li $t1, 500
    div $a0, $t1
    mflo $s2   #$s2 = quociente (notas de 10)
    mfhi $a0  #$a0 = resto
    
    # R$ 2,00
    li $t1, 200
    div $a0, $t1
    mflo $s3 #$s3 = quociente (notas de 2)
    mfhi $a0 #$a0 = resto
    
    # R$1,00
    li $t1, 100
    div $a0, $t1
    mflo $s4   #$s4 = quociente (moedas 1)
    mfhi $a0 #$a0 = resto
    
    # R$0,50
    li $t1, 50
    div $a0, $t1
    mflo $s5  #$s5 = quociente (moedas de 50c)
    mfhi $a0 # $a0 = resto
    
    #R$0,25
    li $t1, 25
    div $a0, $t1
    mflo $s6  #$s6 = quociente (moedas de 25c)
    mfhi $a0 #$a0 = resto
    
    #R$0,10
    li $t1, 10
    div $a0, $t1
    mflo $s7  #$s7 = quociente (moedas de 10c)
    mfhi $a0 #$a0 = resto
    
    #0,05
    # o valor que sobrou em $a0 deve ser 0,
    # mas para seguir a regra da tabela, podemos assumir que 
    #o que sobrar sera a quantidade
    #de moedad de 5 centavos
    
    li $t1, 5
    div $a0, $t1
    mflo $t9 # $t9 = quociente (moedas de 5c)
            
    # TODO: Implementar algoritmo de distribuição otimizada de troco
    # Entrada: $a0 = valor do troco em centavos
    # Saída: registradores $s0-$s7 e $t9 com quantidades de cada denominação
    
    jr $ra                     # Retorna para chamador

#===============================================================================
# DOCUMENTAÇÃO DOS REGISTRADORES CONFORME ESPECIFICAÇÃO FEITAS PELO O PROFESSOR
#
# ENTRADA (valores inseridos pelo cliente):
# $s0 = Quantidade de cédulas de R$20,00
# $s1 = Quantidade de cédulas de R$10,00
# $s2 = Quantidade de cédulas de R$5,00
# $s3 = Quantidade de cédulas de R$2,00
# $s4 = Quantidade de moedas de R$1,00
# $s5 = Quantidade de moedas de R$0,50
# $s6 = Quantidade de moedas de R$0,25
# $s7 = Quantidade de moedas de R$0,10
# $t9 = Valor do produto × 100
#
# SAÍDA (quantidades para o troco):
# $s0 = Quantidade de cédulas de R$20,00 para o troco
# $s1 = Quantidade de cédulas de R$10,00 para o troco
# $s2 = Quantidade de cédulas de R$5,00 para o troco
# $s3 = Quantidade de cédulas de R$2,00 para o troco
# $s4 = Quantidade de moedas de R$1,00 para o troco
# $s5 = Quantidade de moedas de R$0,50 para o troco
# $s6 = Quantidade de moedas de R$0,25 para o troco
# $s7 = Quantidade de moedas de R$0,10 para o troco
# $t9 = Quantidade de moedas de R$0,05 para o troco
#
# CONTROLE:
# $t0 = Código de retorno (0=suficiente, 1=insuficiente)
#===============================================================================


#=============================================================================== 
# PARTE 3: MÓDULOS DE CÁLCULO, INTERFACE E TROCO 
# Responsáveis: Cassiane e cesar 
# 
# DESCRIÇÃO: 
 
# Este módulo contém três funcionalidades principais: 
# 
# 1. calcular_valor_inserido 
# 
# 2. exibir_valor_monetario 
# 
# 3. calcular_troco_otimizado 
# 
# OBJETIVO: 
# Integrar os módulos da máquina de vendas, garantindo cálculo correto do valor 
# pago, formatação monetária e fornecimento de troco de forma eficiente. 
#=====================================================================
 ========== 
#valor_insuficiente: 
    li $v0, 4 
    la $a0, msg_insuficiente 
    syscall 
 
    li $v0, 4 
    la $a0, msg_nova_linha 
    syscall 
 
    li $v0, 10 
    syscall 
 
# -------------------------------------------------------------------- 
# Função: calcular_valor_inserido (corrigida) 
# Entrada: usa $s0..$s7 (quantidades por denominação) 
# Saída: $v0 = valor total em centavos 
# -------------------------------------------------------------------- 
#calcular_valor_inserido: 
    li $v0, 0         # acumula total em centavos 
 
    # $s0 * 2000 (R$20) 
    li $t8, 2000 
    mul $t0, $s0, $t8 
    add $v0, $v0, $t0 
 
    # $s1 * 1000 (R$10) 
    li $t8, 1000 
    mul $t0, $s1, $t8 
    add $v0, $v0, $t0 
 
    # $s2 * 500 (R$5) 
    li $t8, 500 
    mul $t0, $s2, $t8 
    add $v0, $v0, $t0 
 
    # $s3 * 200 (R$2) 
    li $t8, 200 
    mul $t0, $s3, $t8 
    add $v0, $v0, $t0 
 
    # $s4 * 100 (R$1) 
    li $t8, 100 
    mul $t0, $s4, $t8 
    add $v0, $v0, $t0 
 
    # $s5 * 50 (R$0,50) 
    li $t8, 50 
    mul $t0, $s5, $t8 
    add $v0, $v0, $t0 
 
    # $s6 * 25 (R$0,25) 
    li $t8, 25 
    mul $t0, $s6, $t8 
    add $v0, $v0, $t0 
 
    # $s7 * 10 (R$0,10) 
    li $t8, 10 
    mul $t0, $s7, $t8 
    add $v0, $v0, $t0 
 
    jr $ra 
 
# -------------------------------------------------------------------- 
# Função: exibir_valor_monetario 
# Entrada: $a0 = valor em centavos 
# Saída: imprime "reais,centavos" (virgula como separador) 
# -------------------------------------------------------------------- 
#exibir_valor_monetario: 
    li $t2, 100 
    div $a0, $t2      # divide a0 por 100 
    mflo $t3          # reais 
    mfhi $t4          # centavos 
 
    # imprimir reais 
    li $v0, 1 
    move $a0, $t3 
    syscall 
 
    # imprimir virgula 
    li $v0, 4 
    la $a0, msg_virgula 
    syscall 
 
    # imprimir centavos (sempre 2 dígitos) 
    blt $t4, 10, ev_print_zero_first 
 
    li $v0, 1 
    move $a0, $t4 
    syscall 
    j ev_end_print 
 
ev_print_zero_first: 
    li $v0, 11 
    li $a0, '0' 
    syscall 
    li $v0, 1 
    move $a0, $t4 
    syscall 
 
ev_end_print: 
    jr $ra 
 
# -------------------------------------------------------------------- 
# Função: calcular_troco_otimizado 
# Entrada: $a0 = troco em centavos 
# Saída: coloca quantidades em $s0..$s7 e $t9 
# -------------------------------------------------------------------- 
#calcular_troco_otimizado: 
    # R$20,00 
    li $t1, 2000 
    div $a0, $t1 
    mflo $s0 
    mfhi $a0 
 
    # R$10,00 
    li $t1, 1000 
    div $a0, $t1 
    mflo $s1 
    mfhi $a0 
 
    # R$5,00 
    li $t1, 500 
    div $a0, $t1 
    mflo $s2 
    mfhi $a0 
 
    # R$2,00 
    li $t1, 200 
    div $a0, $t1 
    mflo $s3 
    mfhi $a0 
 
    # R$1,00 
    li $t1, 100 
    div $a0, $t1 
    mflo $s4 
    mfhi $a0 
 
    # R$0,50 
    li $t1, 50 
    div $a0, $t1 
    mflo $s5 
    mfhi $a0 
 
    # R$0,25 
    li $t1, 25 
    div $a0, $t1 
    mflo $s6 
    mfhi $a0 
 
    # R$0,10 
    li $t1, 10 
    div $a0, $t1 
    mflo $s7 
    mfhi $a0 
 
    # R$0,05 
    li $t1, 5 
    div $a0, $t1 
    mflo $t9    # moedas de 5c 
 
    jr $ra 



