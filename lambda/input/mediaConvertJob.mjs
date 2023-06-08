import fs from "fs";
import path from "path";
import {
  MediaConvertClient,
  CreateJobCommand,
} from "@aws-sdk/client-mediaconvert";
import mediaConvertEndpoint from "./mediaConvertEndpoint.mjs";

export default async (s3Bucket, s3Object) => {
  const endpoints = await mediaConvertEndpoint();
  const config = {
    region: "ap-northeast-1",
    endpoint: endpoints.Endpoints[0].Url,
  };

  const client = new MediaConvertClient(config);
  const inputFile = `s3://${s3Bucket}/${s3Object}`;
  const outputFolder = path.parse(s3Object).name;
  const outputBucket = `s3://${process.env.OUTPUT_BUCKET}/${outputFolder}/`;

  const jobSettings = JSON.parse(fs.readFileSync("jobSettings.json", "utf8"));
  jobSettings.Settings.Inputs[0].FileInput = inputFile;
  jobSettings.Settings.OutputGroups[0].OutputGroupSettings.FileGroupSettings.Destination =
    outputBucket;
  jobSettings.Role = process.env.MEDIACONVERT_ROLE_ARN;
  jobSettings.Queue = process.env.MEDIACONVERT_QUEUE_ARN;

  const command = new CreateJobCommand(jobSettings);
  const response = await client.send(command);

  return response;
};
