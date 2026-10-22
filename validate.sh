#!/usr/bin/env bash
set -euo pipefail
terraform fmt -recursive
terraform init -backend=false -input=false
terraform validate
echo "Validação local concluída. Nenhum recurso Azure foi provisionado."
