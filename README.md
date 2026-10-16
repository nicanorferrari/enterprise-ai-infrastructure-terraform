# Enterprise Cloud Infrastructure for Generative AI (Terraform)

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-7B42BC.svg?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Microsoft_Azure-Architecture-0078D4.svg?logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![AWS](https://img.shields.io/badge/AWS-Reference_Design-FF9900.svg?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Security: Zero Trust](https://img.shields.io/badge/Security-Zero_Trust-success.svg)](https://www.cisecurity.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Blueprint de **Infraestructura como Codigo (IaC)** en Terraform disenado para el despliegue desacoplado, seguro y altamente disponible de servicios de **IA Generativa y RAG** en entornos corporativos (Microsoft Azure / AWS).

## Arquitectura de Red y Aislamiento

El diseno implementa un modelo **Zero Trust** estricto: ninguna API de LLM ni base de datos vectorial expone interfaces publicas a Internet. Toda la comunicacion intra-servicio ocurre mediante redes privadas virtuales (VNet/VPC) y puntos de enlace privados (Private Endpoints).

```mermaid
graph TD
    subgraph Public Edge
        WAF[Cloudflare / Azure Front Door] --> APIGW[API Gateway Ingress]
    end

    subgraph Secure VNet / Private Subnet
        APIGW --> Service[FastAPI RAG Containers / Azure Container Apps]
        Service --> PE_DB[Private Endpoint: Vector DB]
        Service --> PE_AI[Private Endpoint: Azure OpenAI Service]
        PE_DB --> DB[(PostgreSQL pgvector / Managed Cluster)]
        PE_AI --> LLM[Model Inference Endpoints]
        Service --> KV[(Key Vault / Secrets Manager)]
    end
```

## Pilares de Diseno de Infraestructura
- **Aislamiento de Red:** Subredes dedicadas para computo (Container Apps/ECS) y datos (pgvector/OpenAI) sin IPs publicas.
- **Identidades Administradas:** Eliminacion de tokens y credenciales estaticas usando Managed Identities (Azure) / IAM Roles (AWS).
- **Seguridad perimetral y Cifrado:** Cifrado en reposo y en transito (TLS 1.3), con gestion centralizada de secretos via Key Vault / Secrets Manager.
- **Escalabilidad Horizontal:** Auto-escalado de contenedores basado en concurrencia HTTP y metricas de cola de inferencia.

## Estructura del Modulo

```
environments/
  dev/
  prod/
modules/
  network/        # VNets, Subnets, NSGs, Private Endpoints
  compute/        # Azure Container Apps / ECR + ECS
  database/       # Flexible Server PostgreSQL con soporte pgvector
  ai_services/    # Azure OpenAI deployments (GPT-4o, Embeddings)
main.tf
variables.tf
outputs.tf
terraform.tfvars.example
```

## Despliegue

```bash
# 1. Inicializar providers y modulos
terraform init

# 2. Validacion estatica y planificacion de ejecucion
terraform plan -out=tfplan

# 3. Aplicar infraestructura
terraform apply tfplan
```