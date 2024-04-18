provider "aws" {
  region = var.region
}

locals {
  cluster_name = "tr-lanchonete-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_eks_cluster" "tr-lanchonete-eks" {

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.serviceIpv4
  }

  name     = local.cluster_name
  role_arn = data.aws_iam_role.name.arn
  version  = var.eksVersion

  vpc_config {
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = [for subnet in data.aws_subnet.selected : subnet.id if subnet.availability_zone != "us-east-1e"]
  }

  access_config {
    authentication_mode = var.authenticationMode
  }

}

resource "aws_eks_node_group" "tr-lanchonete-eks-node" {
  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  cluster_name  = local.cluster_name
  disk_size     = 20

  instance_types = ["t3.medium"]

  node_group_name = "node-${local.cluster_name}"
  node_role_arn   = data.aws_iam_role.name.arn
  subnet_ids      = [for subnet in data.aws_subnet.selected : subnet.id if subnet.availability_zone != "us-east-1e"]
  version         = var.eksVersion

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  depends_on = [aws_eks_cluster.tr-lanchonete-eks]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name                = local.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.28.0-eksbuild.1"
  resolve_conflicts_on_create = "NONE"
  resolve_conflicts_on_update = "NONE"

  depends_on = [aws_eks_node_group.tr-lanchonete-eks-node]
}

# resource "aws_security_group_rule" "allow_eks_to_rds" {
#   type                     = "ingress"
#   from_port                = 1433
#   to_port                  = 1433
#   protocol                 = "tcp"
#   security_group_id        = data.terraform_remote_state.rds.outputs.security_group_id
#   source_security_group_id = data.aws_security_group.eks-sg.id
# }

resource "aws_security_group" "eks-sg" {
  name        = "eks-default-sg"
  description = "Default security group for the EKS cluster"
  vpc_id      = aws_eks_cluster.tr-lanchonete-eks.vpc_config[0].vpc_id

}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = local.cluster_name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.16.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.tr-lanchonete-eks-node]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = local.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.29.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_addon.vpc_cni
  ]
}

resource "aws_eks_addon" "core_dns" {
  cluster_name                = local.cluster_name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.4"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_addon.vpc_cni
  ]
}

# Conf para acessar o cluster via kubectl. Substituir o principal_arn pelo usuario configurado no AWS CLI
resource "aws_eks_access_entry" "access" {
  cluster_name      = aws_eks_cluster.tr-lanchonete-eks.name
  principal_arn = var.principalArn
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "access_policy_association" {
  cluster_name  = aws_eks_cluster.tr-lanchonete-eks.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.principalArn

  access_scope {
    type       = "cluster"
  }
}
