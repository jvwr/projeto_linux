#!/bin/bash

# Launcher principal para atender ao formato de entrega do projeto.
# O sistema completo fica em scripts/sistema.sh.
DIR_PROJETO="$(cd "$(dirname "$0")" && pwd)"

bash "$DIR_PROJETO/scripts/sistema.sh"
