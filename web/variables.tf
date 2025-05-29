
# █░█ ▄▀█ █▀█ █ ▄▀█ █▄▄ █░░ █▀▀ █▀ 
# ▀▄▀ █▀█ █▀▄ █ █▀█ █▄█ █▄▄ ██▄ ▄█ 

# NOTE: create a terraform.tfvars file with these defined
#  to avoid being prompted at every plan or apply

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

