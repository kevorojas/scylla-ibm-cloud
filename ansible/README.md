# Playbook Scylla Nodes

Este playbook de Ansible está diseñado para configurar y gestionar nodos ScyllaDB. A continuación, se detallan los pasos necesarios para utilizar este playbook.

## Prerrequisitos

1. **Ansible**: Asegúrate de tener Ansible instalado en tu máquina local. Puedes instalarlo utilizando pip:
    ```sh
    pip install ansible
    ```

2. **Inventario**: Configura el archivo de inventario `inventory.ini` con las IPs públicas de tus nodos ScyllaDB. Aquí tienes un ejemplo:
    ```ini
    [scylla]
    public-ip-node1 dc=location rack=rack-number ansible_user=user ansible_connection='ssh' ansible_ssh_extra_args='-o StrictHostKeyChecking=no' ansible_ssh_private_key_file=path/to/your/ssh/key
    public-ip-node2 dc=location rack=rack-number ansible_user=user ansible_connection='ssh' ansible_ssh_extra_args='-o StrictHostKeyChecking=no' ansible_ssh_private_key_file=path/to/your/ssh/key
    ```

3. **parameters.yml**: Este archivo `parameters.yml` contiene la configuración necesaria para desplegar y configurar un clúster de ScyllaDB utilizando Ansible. A continuación, se describen las principales secciones y variables del archivo.
    1. Secciones Principales
        - **swap configuration**: Configuración del archivo de intercambio (swap).
        - **RAID**: Configuración para el setup de RAID (actualmente comentado).- **Scylla Manager agent**: Configuración del agente de Scylla Manager.- **monitoring configuration**: Configuración para la generación de archivos de monitoreo.
        - **Scylla configuration**: Configuración principal de ScyllaDB.
        - **scylla_yaml_params**: Parámetros adicionales para el archivo `scylla.yaml`.

    2. Variables Importantes a Modificar
        - **`scylla_seeds`**
        Esta variable define las direcciones IP de las semillas del clúster de ScyllaDB. Es crucial para la formación del clúster y debe ser configurada con las direcciones IP de los nodos iniciales. Agregar solo IP privada
        - **`scylla_cluster_name`**
        Esta variable define el nombe del cluster


## Uso

1. **Ejecutar el Playbook**: Navega al directorio `ansible` y ejecuta el playbook `scylla_nodes.yml` con el siguiente comando:
    ```sh
    ansible-playbook -i inventory.ini -e '@parameters.yml' scylla_nodes.yml
    ```

2. **Verificar la Configuración**: Asegúrate de que todos los nodos se hayan configurado correctamente y que el servicio ScyllaDB esté en funcionamiento.

## Estructura del Proyecto

```plaintext
ansible/
├── inventory.ini
├── parameters.yml
├── roles/
│   └── ansible-scylla-node/
│       ├── defaults/
│       │   └── main.yml
│       ├── files/
│       │   └── hex2list.py
│       ├── handlers/
│       │   └── main.yml
│       ├── meta/
│       │   └── main.yml
│       ├── molecule/
│       │   ├── debian10/
│       │   │   └── molecule.yml
│       │   ├── centos7/
│       │   │   └── molecule.yml
│       │   └── centos8/
│       │       └── molecule.yml
│       ├── tasks/
│       ├── templates/
│       │   └── scylla-node-exporter.j2
│       ├── tests/
│       │   └── test.yml
│       └── vars/
├── scylla_nodes.yml