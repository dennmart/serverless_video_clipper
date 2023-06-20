import getInputFileFromEvent from "./getInputFileFromEvent.mjs";
import copyInputFileToProcessedBucket from "./copyInputFileToProcessedBucket.mjs";
import deleteInputFile from "./deleteInputFile.mjs";

export const handler = async (event) => {
  const inputFile = await getInputFileFromEvent(event);

  await copyInputFileToProcessedBucket(inputFile);
  await deleteInputFile(inputFile);

  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
};
