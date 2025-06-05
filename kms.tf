resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_kms_key" "my_key" {
  description             = "KMS key for EKS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks_alias" {
  name          = "alias/eks/my-eks-cluster-${random_string.suffix.result}"
  target_key_id = aws_kms_key.my_key.key_id
}
