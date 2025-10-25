variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS API"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}

variable "enabled_cluster_log_types" {
  description = "List of control plane logging types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "capacity_type" {
  description = "Type of capacity for node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "arm_instance_types" {
  description = "List of ARM instance types for node group"
  type        = list(string)
  default     = ["t4g.medium", "t4g.large"]
}

variable "arm_desired_size" {
  description = "Desired number of ARM nodes"
  type        = number
  default     = 2
}

variable "arm_max_size" {
  description = "Maximum number of ARM nodes"
  type        = number
  default     = 5
}

variable "arm_min_size" {
  description = "Minimum number of ARM nodes"
  type        = number
  default     = 1
}

variable "vpc_cni_version" {
  description = "VPC CNI addon version"
  type        = string
  default     = null
}

variable "coredns_version" {
  description = "CoreDNS addon version"
  type        = string
  default     = null
}

variable "kube_proxy_version" {
  description = "Kube-proxy addon version"
  type        = string
  default     = null
}
