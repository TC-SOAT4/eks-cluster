## Tech Challenge - FASE 3

### Criação de cluster EKS utilizando Terraform

Projeto para criar um cluster na AWS utilizando Terraform.

**Requisitos para executar**

- Conta AWS
- Conta Terraform Cloud
- AWS CLI
- Terraform CLI
- Kubectl CLI

- AWS:
    - Criar/Gerar credenciais de acesso AWS no IAM:
        - AWS_ACCESS_KEY_ID
        - AWS_SECRET_ACCESS_KEY
        


- Terraform Cloud:
    - Criar um **organization** e substituir no  arquivo **terraform.tf**
    - Criar **Variable sets**:
        - Criar uma entrada para: AWS_ACCESS_KEY_ID
        - Criar uma entrada para: AWS_SECRET_ACCESS_KEY


- Terraform CLI: Executar comonado abaxio para realizar login e gerar token de acesso.
```
$ terraform login
```
------------

**Executar**

- Inicializar
```
$ terraform init
```
- Aplicar mudanças
```
$ terraform apply
```
- Aplicar mudanças
```
$ aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```
- Configurar **kubectl** com cluster criado 
```
$ terraform destroy
```

------------

**Configurações adicionais após criação do cluster**



