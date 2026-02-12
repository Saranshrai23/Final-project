terraform {
  backend "s3" {
    bucket         = "eks-saransh-dev-tfstate"
    key            = "eks/infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "eks-saransh-dev-tflock"
    encrypt        = true
  }
}

