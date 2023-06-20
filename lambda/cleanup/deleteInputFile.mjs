import { S3Client, DeleteObjectCommand } from "@aws-sdk/client-s3";

export default async (inputFile) => {
  const s3Client = new S3Client({ region: "ap-northeast-1" });
  const deleteObjectCommand = new DeleteObjectCommand({
    Bucket: process.env.INPUT_BUCKET,
    Key: inputFile.split("/").pop(),
  });

  const response = await s3Client.send(deleteObjectCommand);
  return response;
};
