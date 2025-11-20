locals {
  bucket_final_name = coalesce(var.bucket_name, lower(replace("${var.project_name}-${var.environment}-uploads", ":", "-")))
}

// S3 bucket for uploads
resource "aws_s3_bucket" "uploads" {
  bucket = local.bucket_final_name
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

// S3 bucket policy: allow backend and frontend task roles, and public read/write for local testing
data "aws_iam_policy_document" "bucket_policy" {
  # Allow ECS task roles (backend + frontend)
  statement {
    sid     = "AllowBackendAndFrontendTaskRoles"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [var.backend_task_role_arn, var.frontend_task_role_arn]
    }
  }

  # Allow public access for local testing
  statement {
    sid     = "AllowPublicAccessForTesting"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.uploads.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  # Still deny insecure transport
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.bucket_policy.json
  
  # Ensure public access block is disabled before applying public policy
  depends_on = [aws_s3_bucket_public_access_block.uploads]
}
