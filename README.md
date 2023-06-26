# Serverless Video Clipper

This project demonstrates how to set up a serverless application using [Terraform](https://www.terraform.io/) to process video files using various AWS services:

- Amazon S3
- AWS Lambda
- AWS Elemental MediaConvert
- AWS EventBridge
- Amazon SNS for failure notifications

## Application overview

The application's basic functionality is to allow a user to upload an MP4 video file into an Amazon S3 bucket and have it processed into a 15-second preview clip with thumbnails in a separate Amazon S3 bucket. A good use case for this type of application can be to help content creators efficiently create video and image previews of their video files.

## High-level architecture overview

![Serverless Video Clipper Architecture](/docs/serverless_video_clipper_architecture.png?raw=true)

## Step-by-step overview of the application

1. A user uploads an MP4 video file to the designated input bucket on Amazon S3.
1. The bucket sends an event notification to invoke a Lambda function with details on the newly-stored object.
1. If the object is an MP4 video file, the Lambda function triggers a new Elemental MediaConvert job using predefined job parameters to create a 15-second clip of the video and thumbnails.
1. Elemental MediaConvert processes the job and stores the output in the designated output bucket on Amazon S3.
1. An EventBridge rule will detect the successful Elemental MediaConvert job completion and invokes another Lambda function with the job details.
1. The second Lambda function moves the source MP4 file from the input bucket into a designated processed bucket on Amazon S3, setting a deletion marker to remove the file in a specified number of days to save on storage costs.
1. If the Lambda functions or the Elemental MediaConvert job fail for any reason, an Amazon SNS topic will receive the message and email an administrator to let them know about the failure.

## Setting up AWS serverless infrastructure

We're using Terraform and the [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to provision the entire serverless infrastructure required for the application.

To provision the serverless infrastructure, ensure you [configure authentication for the Terraform AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) as needed with the necessary permissions to create all the resources required by the application.

1. Initialize the working directory using `terraform init`.
1. Set up the project variables by copying the `terraform.tfvars.example` file to `terraform.tfvars` and adding the values as desired. See the `variables.tf` file in the root directory for a description of each variable.
1. Run `terraform plan` to preview the changes in your AWS account.
1. Once you've confirmed the infrastructure changes, run `terraform apply` to execute the changes.

After creating the AWS resources, you can immediately test the application by uploading an MP4 video file to your Amazon S3 input bucket. If everything works well, you should have the clipped video and thumbnails in the output bucket.

## Unaddressed issues

Since this is an example application, some known issues and tradeoffs were intentionally left unaddressed to keep the application and architecture as lean as possible. For production environments, these cases would be addressed as needed for a more robust and reliable application.

- The Lambda function for processing the input files looks for MP4 files only. Ideally, the function would work with any video file that Elemental MediaConvert accepts.
- Error handling is minimal, with only an SNS email notification sending the failed event. Some areas left uncovered are modifying the notification email and cleaning up any invalid objects uploaded to the input bucket.
- A nice-to-have function is to send a notification after processing the video with presigned URLs to allow the recipient to download the files from the private output bucket.
