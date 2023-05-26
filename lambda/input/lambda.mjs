import { S3Client, HeadObjectCommand } from "@aws-sdk/client-s3";

export const handler = async (event) => {
  console.log(JSON.stringify(event));
  const s3Bucket = event.Records[0].s3.bucket.name;
  const s3Object = event.Records[0].s3.object.key;

  const config = {
    region: "ap-northeast-1",
  };
  const client = new S3Client(config);
  const command = new HeadObjectCommand({
    Bucket: s3Bucket,
    Key: s3Object,
  });

  try {
    const response = await client.send(command);

    if (response.ContentType == "video/mp4") {
      return {
        statusCode: 200,
        body: "You uploaded a video!",
      };
    } else {
      return {
        statusCode: 400,
        body: "Stop uploading incorrect file types!",
      };
    }
  } catch {
    return {
      statusCode: 404,
      body: "File not found!",
    };
  }
};
