## Descripción

Este proyecto de Terraform crea una infraestructura de ScyllaDB en IBM Cloud. La infraestructura incluye:

- Un clúster de ScyllaDB con el número de nodos especificado.
- Configuración de perfiles de máquina para los nodos de ScyllaDB y el nodo de gestión.
- Configuración de claves SSH para acceder a los nodos.
- Despliegue en la región especificada de IBM Cloud.

## Prerrequisitos

1. [Terraform](https://www.terraform.io/downloads.html) instalado.
2. Una cuenta en [IBM Cloud](https://cloud.ibm.com/).
3. Una clave API de IBM Cloud.

## Configuración

1. Clona este repositorio en tu máquina local.

    ```sh
    git clone <URL_DEL_REPOSITORIO>
    cd <NOMBRE_DEL_REPOSITORIO>/terraform
    ```

2. Crea un archivo [`terraform.tfvars`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fxirect%2FDocuments%2FPersonal%2FFractalup%2Fscylladb%2Frepo%2Fterraform%2Fterraform.tfvars%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22f06aa76b-b6fd-49a2-84fb-e4de233c060b%22%5D "/Users/xirect/Documents/Personal/Fractalup/scylladb/repo/terraform/terraform.tfvars") en el directorio [`terraform/`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2FUsers%2Fxirect%2FDocuments%2FPersonal%2FFractalup%2Fscylladb%2Frepo%2Fterraform%2F%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22f06aa76b-b6fd-49a2-84fb-e4de233c060b%22%5D "/Users/xirect/Documents/Personal/Fractalup/scylladb/repo/terraform/") con el siguiente contenido:

    ```tf
    ibmcloud_api_key = "your_ibmcloud_api_key"
    region           = "us-east"
    ssh_key_name     = "your_ssh_key_name"
    node_count       = 2
    manager_profile  = "cx2-2x4"
    scylla_node_profile = "bx2-2x8"
    ```

## Despliegue

1. Inicializa el directorio de trabajo de Terraform.

    ```sh
    terraform init
    ```

2. Revisa el plan de ejecución para asegurarte de que los recursos se crearán según lo esperado.

    ```sh
    terraform plan
    ```

3. Aplica el plan para crear los recursos.

    ```sh
    terraform apply
    ```

    Escribe `yes` cuando se te solicite confirmar.

## Limpieza

Para destruir los recursos creados por Terraform, ejecuta:

```sh
terraform destroy