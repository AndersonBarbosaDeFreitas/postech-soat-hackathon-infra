data "aws_eks_cluster" "target_eks" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "target_eks_auth" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.target_eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target_eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target_eks_auth.token
}

# Create configMap with the variables necessary for the application
resource "kubernetes_config_map" "hackaton-configmap" {
  metadata {
    name = "hackaton-configmap"
  }

  data = {
    RUN_ON               = "production"
    SERVER_PORT          = "3000"
    DATABASE_HOST        = "${aws_db_instance.hackaton_db.address}"
    DATABASE_NAME        = "${aws_db_instance.hackaton_db.db_name}"
    DATABASE_PORT        = "${aws_db_instance.hackaton_db.port}"
    DATABASE_USER        = "${aws_db_instance.hackaton_db.username}"
    DATABASE_PASSWORD    = "${aws_db_instance.hackaton_db.password}"
    JWT_SECRET           = "TESTE"
    RESEND_MAIL_KEY      = "re_f1sJqNBZ_CypSyGTsHZzA4BWmt5wPceLJ"
    EMAIL_SENDER_ADDRESS = "onboarding@resend.dev"
  }
}
