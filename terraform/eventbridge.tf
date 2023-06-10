resource "aws_cloudwatch_event_rule" "media_convert_job_completed" {
  name = var.event_bridge_rule_name

  event_pattern = jsonencode({
    "source" : ["aws.mediaconvert"],
    "detail-type" : ["MediaConvert Job State Change"],
    "detail" : {
      "status" : ["COMPLETE"]
    }
  })
}

resource "aws_cloudwatch_event_target" "media_convert_job_completed" {
  rule = aws_cloudwatch_event_rule.media_convert_job_completed.name
  arn  = aws_lambda_function.media_convert_job_completed.arn
}
