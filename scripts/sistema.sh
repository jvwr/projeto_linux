#!/bin/bash

# ==========================================
# Sistema: MonitorNet
# Tema: Monitor de conectividade de rede
# Integrantes: João Vitor
# Versão: 2.0 - Final
# ==========================================

# ---- Configuração de caminhos ----
DIR_PROJETO="$(cd "$(dirname "$0")/.." && pwd)"

LOG="$DIR_PROJETO/logs/sistema.log"
RELATORIO="$DIR_PROJETO/relatorios/relatorio_rede.txt"
HISTORICO="$DIR_PROJETO/dados/historico.txt"

# ---- Criação de pastas necessárias ----
mkdir -p "$DIR_PROJETO/logs" \
         "$DIR_PROJETO/relatorios" \
         "$DIR_PROJETO/dados" \
         "$DIR_PROJETO/backup"

# ==========================================
# FUNÇÃO: registrar_log
# Registra mensagens com data/hora no log
# ==========================================
registrar_log() {
    echo "[$(date '+%d/%m/%Y %H:%M:%S')] $1" >> "$LOG"
}

# ==========================================
# FUNÇÃO: cabecalho
# Exibe o cabeçalho do sistema na tela
# ==========================================
cabecalho() {
    echo "============================================"
    echo "         MONITORNET - v2.0 Final            "
    echo "   Monitor de Conectividade de Rede         "
    echo "============================================"
    echo "Data/Hora : $(date '+%d/%m/%Y %H:%M:%S')"
    echo "Hostname  : $(hostname)"
    echo "Usuário   : $(whoami)"
    echo "============================================"
    echo ""
}

# ==========================================
# FUNÇÃO: mostrar_ip
# Exibe os endereços IP da máquina
# ==========================================
mostrar_ip() {
    echo "----- Endereços IP da Máquina -----"
    ip addr show | grep "inet " | awk '{print "  " $2 "  (" $NF ")"}'
    echo ""
}

# ==========================================
# FUNÇÃO: mostrar_gateway
# Exibe o gateway padrão da rede
# ==========================================
mostrar_gateway() {
    echo "----- Gateway Padrão -----"
    GATEWAY=$(ip route | grep default | awk '{print $3}')
    if [ -n "$GATEWAY" ]; then
        echo "  Gateway: $GATEWAY"
    else
        echo "  Nenhum gateway encontrado."
    fi
    echo ""
}

# ==========================================
# FUNÇÃO: testar_internet
# Testa a conexão com a internet via ping
# ==========================================
testar_internet() {
    echo "----- Teste de Conexão com a Internet -----"
    echo "  Testando conexão com 8.8.8.8 (Google DNS)..."

    if ping -c 3 -W 3 8.8.8.8 > /dev/null 2>&1; then
        STATUS_INTERNET="OK"
        echo "  Resultado: CONECTADO ✔"
        registrar_log "Teste de internet: SUCESSO."
    else
        STATUS_INTERNET="FALHA"
        echo "  Resultado: SEM CONEXÃO ✘"
        registrar_log "Falha no teste de internet."
    fi

    echo ""
}

# ==========================================
# FUNÇÃO: testar_sites
# Testa disponibilidade de sites específicos
# ==========================================
testar_sites() {
    echo "----- Verificação de Sites -----"

    SITES=("google.com" "github.com" "8.8.8.8")

    for SITE in "${SITES[@]}"; do
        if ping -c 1 -W 2 "$SITE" > /dev/null 2>&1; then
            echo "  $SITE : ACESSÍVEL ✔"
        else
            echo "  $SITE : INACESSÍVEL ✘"
        fi
    done

    echo ""
}

# ==========================================
# FUNÇÃO: mostrar_interfaces
# Lista interfaces de rede e seus estados
# ==========================================
mostrar_interfaces() {
    echo "----- Interfaces de Rede -----"
    ip link show | grep -E "^[0-9]" | awk -F': ' '{print "  " $2}' | sed 's/@.*//'
    echo ""
}

# ==========================================
# FUNÇÃO: gerar_relatorio
# Gera relatório completo em arquivo .txt
# ==========================================
gerar_relatorio() {
    echo "----- Gerando Relatório -----"

    {
        echo "===== RELATÓRIO DE CONECTIVIDADE ====="
        echo "Data      : $(date '+%d/%m/%Y %H:%M:%S')"
        echo "Hostname  : $(hostname)"
        echo "Usuário   : $(whoami)"
        echo ""

        echo "--- Endereços IP ---"
        ip addr show | grep "inet " | awk '{print "  " $2 "  (" $NF ")"}'
        echo ""

        echo "--- Gateway Padrão ---"
        GATEWAY=$(ip route | grep default | awk '{print $3}')
        echo "  ${GATEWAY:-Não encontrado}"
        echo ""

        echo "--- Interfaces de Rede ---"
        ip link show | grep -E "^[0-9]" | awk -F': ' '{print "  " $2}' | sed 's/@.*//'
        echo ""

        echo "--- Teste de Internet ---"
        echo "  Internet: ${STATUS_INTERNET:-NÃO TESTADO}"
        echo ""

        echo "--- Verificação de Sites ---"
        for SITE in "google.com" "github.com" "8.8.8.8"; do
            if ping -c 1 -W 2 "$SITE" > /dev/null 2>&1; then
                echo "  $SITE : ACESSÍVEL"
            else
                echo "  $SITE : INACESSÍVEL"
            fi
        done

        echo ""
        echo "===== FIM DO RELATÓRIO ====="
    } > "$RELATORIO"

    # Salva também no histórico acumulado
    echo "---- Execução: $(date '+%d/%m/%Y %H:%M:%S') ----" >> "$HISTORICO"
    echo "Internet: ${STATUS_INTERNET:-NÃO TESTADO}" >> "$HISTORICO"
    echo "" >> "$HISTORICO"

    registrar_log "Relatório gerado em $RELATORIO."
    echo "  Relatório salvo em: $RELATORIO"
    echo ""
}

# ==========================================
# FUNÇÃO: fazer_backup
# Faz backup do log e relatório na pasta backup
# ==========================================
fazer_backup() {
    TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
    BACKUP_DIR="$DIR_PROJETO/backup"

    cp "$LOG" "$BACKUP_DIR/sistema_${TIMESTAMP}.log" 2>/dev/null
    cp "$RELATORIO" "$BACKUP_DIR/relatorio_${TIMESTAMP}.txt" 2>/dev/null

    registrar_log "Backup realizado em $BACKUP_DIR."
    echo "----- Backup -----"
    echo "  Backup salvo em: $BACKUP_DIR"
    echo ""
}

# ==========================================
# FUNÇÃO: instrucao_crontab
# Exibe como agendar o script no crontab
# ==========================================
instrucao_crontab() {
    echo "----- Agendamento com Crontab -----"
    echo "  Para executar automaticamente, adicione ao crontab:"
    echo ""
    echo "  A cada 10 minutos:"
    echo "  */10 * * * * bash $DIR_PROJETO/scripts/sistema.sh >> $LOG 2>&1"
    echo ""
    echo "  Uma vez por dia às 08h:"
    echo "  0 8 * * * bash $DIR_PROJETO/scripts/sistema.sh >> $LOG 2>&1"
    echo ""
    echo "  Para editar o crontab: crontab -e"
    echo ""
}

# ==========================================
#              EXECUÇÃO PRINCIPAL
# ==========================================

registrar_log "Projeto iniciado."

cabecalho
mostrar_interfaces
mostrar_ip
mostrar_gateway
testar_internet
testar_sites
gerar_relatorio
fazer_backup
instrucao_crontab

echo "============================================"
echo "  Execução finalizada com sucesso!"
echo "  Log salvo em: $LOG"
echo "============================================"

registrar_log "Execução finalizada."
