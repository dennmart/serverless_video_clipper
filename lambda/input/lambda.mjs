import { S3Client, HeadObjectCommand } from "@aws-sdk/client-s3";
import triggerMediaConvertJob from "./mediaConvertJob.mjs";

export const handler = async (event) => {
  const s3Bucket = event.Records[0].s3.bucket.name;
  const s3Object = event.Records[0].s3.object.key;

  const config = {
    region: "ap-northeast-1",
  };

  const s3Client = new S3Client(config);
  const s3HeadCommand = new HeadObjectCommand({
    Bucket: s3Bucket,
    Key: s3Object,
  });

  try {
    const response = await s3Client.send(s3HeadCommand);

    if (response.ContentType == "video/mp4") {
      const job = await triggerMediaConvertJob(s3Bucket, s3Object);
      return {
        statusCode: 201,
        body: JSON.stringify(job),
      };
    } else {
      return {
        statusCode: 400,
        body: "Not an mp4 video file",
      };
    }
  } catch (error) {
    console.log(JSON.stringify(error));

    return {
      statusCode: 500,
      body: JSON.stringify(error),
    };
  }
};
