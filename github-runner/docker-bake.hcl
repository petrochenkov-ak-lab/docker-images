variable "IMAGE_NAME" {
  default = "petrochenkov-ak-lab/github-runner"
}
target "prod" {
  dockerfile = "github-runner/Dockerfile"
}
