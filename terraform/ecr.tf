#ECRのリポジトリを作成
resource "aws_ecr_repository" "my_ecr_repo" {
  name = "my-ecr-repo"
}
