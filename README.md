## Tech Challenge - FASE 3

### Criação de cluster EKS utilizando Terraform

Projeto para criar um cluster na AWS utilizando Terraform.

**Requisitos para executar**

- Conta AWS
- Conta Terraform Cloud
- AWS CLI
- Terraform CLI
- Kubectl CLI
- Credenciais de acesso AWS

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

**Configurações adicionais após criação do cluster***





