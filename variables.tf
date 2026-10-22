variable "location" {
  description = "Região Azure para os recursos do laboratório."
  type        = string
  default     = "brazilsouth"
}

variable "name_prefix" {
  description = "Prefixo para nomes de recursos; use apenas letras minúsculas, números e hífens."
  type        = string
  default     = "kaique-cloud-lab"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.name_prefix))
    error_message = "name_prefix deve conter 3 a 24 caracteres: letras minúsculas, números ou hífens."
  }
}

variable "address_space" {
  description = "Espaço CIDR da VNet. Verifique conflito com redes on-premises/VPN existentes."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_prefixes" {
  description = "Prefixos CIDR de subnets não sobrepostos, um para cada domínio de rede."
  type        = object({
    app        = string
    data       = string
    management = string
  })
  default     = {
    app        = "10.20.1.0/24"
    data       = "10.20.2.0/24"
    management = "10.20.3.0/24"
  }
}

variable "enable_log_analytics" {
  description = "Cria um workspace opcional para estudos. Ingestão/retention podem gerar cobranças."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais para governança e organização dos recursos."
  type        = map(string)
  default     = {}
}
