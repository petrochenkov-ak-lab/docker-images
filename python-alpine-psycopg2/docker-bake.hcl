variable "IMAGE_NAME" {
  default = "petrochenkov-ak-lab/python-alpine-psycopg2"
}
variable "TAG" {
  default = "3.14"
}
target "prod" {
  dockerfile = "python-alpine-psycopg2/Dockerfile"
}
