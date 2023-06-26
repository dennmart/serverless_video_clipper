# EventBridge rule to match completed MediaConvert jobs.
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

# EventBridge target to invoke the Lambda cleanup function when a
# MediaConvert job completes successfully.
resource "aws_cloudwatch_event_target" "mediaconvert_job_completed" {
  rule = aws_cloudwatch_event_rule.mediaconvert_job_completed.name
  arn  = var.cleanup_function_arn
}

# EventBridge rule to match errors in MediaConvert jobs.
resource "aws_cloudwatch_event_rule" "mediaconvert_job_error" {
  name = var.eventbridge_error_rule_name

  event_pattern = jsonencode({
    "source" : ["aws.mediaconvert"],
    "detail-type" : ["MediaConvert Job State Change"],
    "detail" : {
      "status" : ["ERROR"]
    }
  })
}

# EventBridge target to send the event to the same SNS topic as the
# Lambda Dead Letter Queue to notify about any errors for MediaConvert
# jobs.
resource "aws_cloudwatch_event_target" "mediaconvert_job_error" {
  rule = aws_cloudwatch_event_rule.mediaconvert_job_error.name
  arn  = var.sns_error_topic_arn
}

