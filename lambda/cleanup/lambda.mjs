import {
  MediaConvertClient,
  GetJobCommand,
} from "@aws-sdk/client-mediaconvert";
import {
  S3Client,
  CopyObjectCommand,
  DeleteObjectCommand,
} from "@aws-sdk/client-s3";
import mediaConvertEndpoint from "./mediaConvertEndpoint.mjs";

export const handler = async (event) => {
  // console.log(JSON.stringify(event));

  const endpoints = await mediaConvertEndpoint();
  const config = {
    region: "ap-northeast-1",
    endpoint: endpoints.Endpoints[0].Url,
  };

  const client = new MediaConvertClient(config);
  const command = new GetJobCommand({ Id: event.detail.jobId });
  const response = await client.send(command);

  const inputFile = response.Job.Settings.Inputs[0].FileInput;

  const s3Client = new S3Client({ region: "ap-northeast-1" });
  const copyCommand = new CopyObjectCommand({
    CopySource: inputFile.replace("s3://", ""),
    Bucket: process.env.PROCESSED_BUCKET,
    Key: `${inputFile.split("/").pop()}`,
  });
  const s3Response = await s3Client.send(copyCommand);

  const deleteCommand = new DeleteObjectCommand({
    Bucket: process.env.INPUT_BUCKET,
    Key: inputFile.split("/").pop(),
  });
  await s3Client.send(deleteCommand);

  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
};
