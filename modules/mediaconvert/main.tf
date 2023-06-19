# Create a separate Elemental MediaConvert on-demand queue
# for processing MediaConvert jobs from Lambda.
resource "aws_media_convert_queue" "queue" {
  name = var.media_convert_queue_name
}
