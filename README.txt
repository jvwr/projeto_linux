Nome do projeto:
MonitorNet

Tema escolhido:
1 - Monitor de conectividade de rede

Problema que o sistema vai resolver:
O sistema verifica se a VM Linux está conectada corretamente à rede e à internet.
Ele mostra informações básicas da máquina, verifica o endereço IP, identifica
o gateway padrão, testa a conexão com a internet e verifica sites específicos.

Integrantes:
- João Vitor

============================================================
COMANDOS LINUX USADOS
============================================================

date      - registrar a data e hora da execução
hostname  - mostrar o nome da VM
whoami    - mostrar o usuário atual
ip addr   - mostrar os endereços IP da máquina
ip route  - mostrar as rotas de rede e o gateway padrão
ip link   - listar interfaces de rede e seus estados
ping      - testar a conexão com a internet e sites
grep      - filtrar informações importantes dos comandos
awk       - processar e formatar saída dos comandos
echo      - exibir mensagens e escrever informações em arquivos
cat       - visualizar arquivos de log e relatório
mkdir -p  - criar pastas necessárias automaticamente
cp        - copiar arquivos para backup

============================================================
FUNCIONALIDADES DO SISTEMA
============================================================

1. Exibir cabeçalho com data, hora, hostname e usuário
2. Listar interfaces de rede ativas
3. Mostrar endereços IP da máquina
4. Mostrar o gateway padrão
5. Testar conexão com a internet (ping 8.8.8.8)
6. Verificar disponibilidade de sites (google.com, github.com)
7. Gerar relatório completo de conectividade
8. Registrar todas as execuções em log
9. Salvar histórico acumulado de execuções
10. Fazer backup automático de logs e relatórios
11. Exibir instruções de agendamento com crontab

============================================================
ESTRUTURA DE PASTAS
============================================================

projeto_linux/
├── scripts/
│   └── sistema.sh          ← script principal
├── logs/
│   └── sistema.log         ← log de todas as execuções
├── relatorios/
│   └── relatorio_rede.txt  ← relatório da última execução
├── dados/
│   └── historico.txt       ← histórico acumulado
├── backup/
│   └── (cópias automáticas com timestamp)
└── README.txt              ← este arquivo

============================================================
COMO O SISTEMA USA LOGS
============================================================

O sistema cria e atualiza o arquivo logs/sistema.log.
Cada linha do log registra: data, hora e evento ocorrido.

Exemplos de entradas no log:
  [16/06/2026 23:35:47] Projeto iniciado.
  [16/06/2026 23:35:47] Falha no teste de internet.
  [16/06/2026 23:35:47] Relatório gerado em relatorios/relatorio_rede.txt.
  [16/06/2026 23:35:47] Execução finalizada.

============================================================
COMO O SISTEMA GERA RELATÓRIO
============================================================

O sistema gera o arquivo relatorios/relatorio_rede.txt com:
  - Data e hora da verificação
  - Nome da máquina (hostname)
  - Usuário atual
  - Endereços IP detectados
  - Gateway padrão
  - Interfaces de rede
  - Resultado do teste de internet
  - Status dos sites verificados

Além disso, salva um histórico acumulado em dados/historico.txt
e faz backup automático na pasta backup/ com timestamp.

============================================================
COMO O SISTEMA USA O CRONTAB
============================================================

O script pode ser agendado no crontab para execução automática.
O próprio sistema exibe as instruções ao final de cada execução.

Exemplos de agendamento:

  A cada 10 minutos:
  */10 * * * * bash /caminho/projeto_linux/scripts/sistema.sh

  Uma vez por dia às 08h:
  0 8 * * * bash /caminho/projeto_linux/scripts/sistema.sh

  Para editar: crontab -e
  Para listar: crontab -l

Enquanto o crontab não estiver configurado, a simulação
pode ser feita executando o script manualmente várias vezes.
Cada execução fica registrada no log com data e hora.

============================================================
COMO EXECUTAR O SCRIPT
============================================================

1. Dar permissão de execução (apenas na primeira vez):
   chmod +x scripts/sistema.sh

2. Executar o script:
   bash scripts/sistema.sh

   ou (após dar permissão):
   ./scripts/sistema.sh

============================================================
