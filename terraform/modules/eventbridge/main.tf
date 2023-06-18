resource "aws_cloudwatch_event_rule" "mediaconvert_job_completed" {
  name = var.eventbridge_rule_name

  event_pattern = jsonencode({
    "source" : ["aws.mediaconvert"],
    "detail-type" : ["MediaConvert Job State Change"],
    "detail" : {
      "status" : ["COMPLETE"]
    }
  })
}

resource "aws_cloudwatch_event_target" "mediaconvert_job_completed" {
  rule = aws_cloudwatch_event_rule.mediaconvert_job_completed.name
  arn  = var.cleanup_function_arn
}
