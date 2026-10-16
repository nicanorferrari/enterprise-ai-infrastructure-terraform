# Enterprise Cloud Infrastructure for Generative AI (Terraform)

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

```text
â”œâ”€â”€ environments/
â”‚   â”œâ”€â”€ dev/
â”‚   â””â”€â”€ prod/
â”œâ”€â”€ modules/
â”‚   â”œâ”€â”€ network/        # VNets, Subnets, NSGs, Private Endpoints
â”‚   â”œâ”€â”€ compute/        # Azure Container Apps / ECR + ECS
â”‚   â”œâ”€â”€ database/       # Flexible Server PostgreSQL con soporte pgvector
â”‚   â””â”€â”€ ai_services/    # Azure OpenAI deployments (GPT-4o, Embeddings)
â”œâ”€â”€ main.tf
â”œâ”€â”€ variables.tf
â”œâ”€â”€ outputs.tf
â””â”€â”€ terraform.tfvars.example
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