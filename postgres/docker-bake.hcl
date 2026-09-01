variable "IMAGE_NAME" {
  default = "petrochenkov-ak-lab/postgresql"
}
variable "TAG" {
  default = "18"
}
target "prod" {
  dockerfile = "postgres/Dockerfile"
}
