# ADR-001 — segmentar a rede e não expor portas administrativas

- **Status:** proposta adotada no código de laboratório.
- **Contexto:** a base deve demonstrar isolamento de rede sem abrir SSH/RDP ao público.
- **Decisão:** separar as subnets de aplicação, dados e administração; associar NSG e adicionar regra explícita que nega tráfego de entrada cuja origem é a tag de serviço `Internet`; não criar IP público; desativar o acesso de saída padrão das subnets.
- **Alternativas:** uma subnet plana; liberar RDP/SSH para `0.0.0.0/0`; permitir saída padrão sem desenhar um caminho de egress.
- **Consequências:** a topologia exige planejamento de rotas e egress antes de workloads que precisem buscar atualizações ou chamar serviços externos. Regras padrão da Azure ainda se aplicam; a regra do NSG não substitui firewall de aplicação, identidade ou controles de plataforma.
- **Validação planejada:** `terraform validate`, revisão de `terraform plan` e teste de conectividade com ferramentas autorizadas após um deploy deliberado.
