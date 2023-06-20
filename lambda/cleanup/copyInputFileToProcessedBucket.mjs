import { S3Client, CopyObjectCommand } from "@aws-sdk/client-s3";

export default async (inputFile) => {
  const s3Client = new S3Client({ region: "ap-northeast-1" });
  const copyObjectCommand = new CopyObjectCommand({
    CopySource: inputFile.replace("s3://", ""),
    Bucket: process.env.PROCESSED_BUCKET,
    Key: `${inputFile.split("/").pop()}`,
  });

  const response = await s3Client.send(copyObjectCommand);
  return response;
};
