import {
  DescribeEndpointsCommand,
  MediaConvertClient,
} from "@aws-sdk/client-mediaconvert";

export default async () => {
  const config = {
    region: "ap-northeast-1",
  };

  const client = new MediaConvertClient(config);
  const endpointCommand = new DescribeEndpointsCommand({});
  const endpoints = await client.send(endpointCommand);

  return endpoints;
};
