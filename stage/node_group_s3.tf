# resource "aws_iam_role_policy" "node_s3" {
#     name = "node_s3_access"
#     role = module.eks.worker_iam_role_name
#     policy = jsonencode(
#         {
#             "Version": "2012-10-17",
#             "Statement": [
#                 {
#                     "Effect": "Allow",
#                     "Action": [
#                         "s3:*",
#                     ],
#                     "Resource": "*"
#                 }
#             ]
#         }
#     )
  
# }