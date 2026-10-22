$ErrorActionPreference = 'Stop'
terraform fmt -recursive
terraform init -backend=false -input=false
terraform validate
Write-Host 'Validação local concluída. Nenhum recurso Azure foi provisionado.'
