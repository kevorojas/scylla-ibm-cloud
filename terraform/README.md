# Terraform IBM Cloud Infrastructure

Este proyecto utiliza Terraform para definir y desplegar infraestructura en IBM Cloud.

## Estructura del Proyecto

```plaintext
terraform/
├── main.tf
├── README.md
├── terraform.tfvars
└── variables.tf
```
## Archivos Clave
- main.tf: Define los recursos principales de la infraestructura.
- variables.tf: Define las variables utilizadas en el proyecto.
- terraform.tfvars: Contiene los valores de las variables.
## Variables
Las siguientes variables deben ser configuradas en el archivo terraform.tfvars:

- ibmcloud_api_key: Tu clave API de IBM Cloud.
- region: La región donde se desplegarán los recursos.
- zone: La zona dentro de la región.
- basename: El nombre base para los recursos.
- ssh_key_name: El nombre de la clave SSH.
- node_count: El número de nodos.
- manager_profile: El perfil del manager.
- scylla_node_profile: El perfil del nodo ScyllaDB.

## Ejemplo de terraform.tfvars
```plaintext
ibmcloud_api_key = "your_ibmcloud_api_key"
region           = "your_region"
zone             = "your_zone"
basename         = "your-basename"
ssh_key_name     = "your_ssh_key_name"
node_count       = 2
manager_profile  = "cx2-2x4"
scylla_node_profile = "bx2-2x8"
```
## Despliegue
1. Asegúrate de tener permisos adecuados en tu cuenta de IBM Cloud para crear los recursos necesarios.
2. Revisa y ajusta los valores en terraform.tfvars según tus necesidades específicas.
3. Ejecuta los siguientes comandos:
```sh
terraform init
terraform plan
terraform apply
```

## Limpieza

Para destruir los recursos creados por Terraform, ejecuta:

```sh
terraform destroy