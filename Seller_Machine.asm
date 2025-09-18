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
    
    # [PLACEHOLDER PARA MÓDULOS FUTUROS] # Placeholder são comentários temporários
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
    # TODO: Implementar cálculo do valor total inserido
    # Deve somar: ($s0×2000) + ($s1×1000) + ($s2×500) + ($s3×200) +
    #             ($s4×100) + ($s5×50) + ($s6×25) + ($s7×10)
    # Retorno em $v0: valor total em centavos
    
    li $v0, 0                  # Placeholder: retorna 0 temporariamente
    jr $ra                     # Retorna para chamador

# [PLACEHOLDER] Função a ser implementada pelo módulo de interface
exibir_valor_monetario:
    # TODO: Implementar formatação e exibição de valores monetários
    # Entrada: $a0 = valor em centavos
    # Saída: valor formatado como "XX,XX" no visor
    
    jr $ra                     # Retorna para chamador

# [PLACEHOLDER] Função a ser implementada pelo módulo de troco
calcular_troco_otimizado:
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