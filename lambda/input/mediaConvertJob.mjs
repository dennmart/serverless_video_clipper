import fs from "fs";

import {
  MediaConvertClient,
  CreateJobCommand,
} from "@aws-sdk/client-mediaconvert";

export default async (s3Bucket, s3Object) => {
  const config = {
    region: "ap-northeast-1",
    endpoint: "https://1muozxeta.mediaconvert.ap-northeast-1.amazonaws.com",
  };

  const client = new MediaConvertClient(config);

  const jobSettings = JSON.parse(fs.readFileSync("jobSettings.json", "utf8"));
  jobSettings.Settings.Inputs[0].FileInput = `s3://${s3Bucket}/${s3Object}`;
  jobSettings.Settings.OutputGroups[0].OutputGroupSettings.FileGroupSettings.Destination = `s3://${process.env.OUTPUT_BUCKET}/`;
  jobSettings.Role = process.env.MEDIACONVERT_ROLE_ARN;

  const command = new CreateJobCommand(jobSettings);
  const response = await client.send(command);

  return response;
};
