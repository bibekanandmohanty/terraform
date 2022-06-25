######## Variables ###########

variable "project" {
  default = "arboreal-avatar-342311"
}

variable "service_account_email" {
  default = ""
}

variable "ssh_user" {
  default = "centos"
}

variable "ssh_pub_key_file" {
  default = ".ssh/google_compute_engine.pub"
}

variable "region" {
  default = "us-west1"
}

variable "cluster_name" {
  default = "staging-cluster"
}

variable "cluster_zone" {
  default = "us-west1-a"
}

variable "network"{
  default = "staging-cluster-net-1"
}

variable "subnetwork"{
  default = "staging-cluster-subnet-1"
}

variable "subnetwork_range"{
  default = "192.168.0.0/20"
}

variable "cluster_secondary_name"{
  default = "staging-pods-1"
}

variable "cluster_service_name"{
  default = "staging-services-1"
}

variable "cluster_secondary_range"{
  default = "10.4.0.0/14"
}

variable "cluster_service_range"{
  default = "10.0.32.0/20"
}

variable "master_cidr"{
  default = "172.16.32.0/28"
}

#variable "k8s_version" {
#  default = "1.12"
#}

variable "initial_node_count" {
  default = 1
}

variable "node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 50
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-2"
}

######## Outputs ###########
###### Cluster endpoints ######
output "cluster_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

###### Jumphost Compute instance ######
output "instance_ip" {
  value = google_compute_instance.gke-jumphost.network_interface.0.access_config.0.nat_ip
}