import {
  MediaConvertClient,
  GetJobCommand,
} from "@aws-sdk/client-mediaconvert";
import mediaConvertEndpoint from "./mediaConvertEndpoint.mjs";

export default async (event) => {
  const endpoints = await mediaConvertEndpoint();
  const config = {
    region: "ap-northeast-1",
    endpoint: endpoints.Endpoints[0].Url,
  };

  const mediaConvertClient = new MediaConvertClient(config);
  const getJobCommand = new GetJobCommand({ Id: event.detail.jobId });
  const response = await mediaConvertClient.send(getJobCommand);
  const inputFile = response.Job.Settings.Inputs[0].FileInput;

  return inputFile;
};
