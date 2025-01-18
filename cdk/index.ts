import * as cdk from "aws-cdk-lib";
import { IamStack } from "./stacks/iam";

const env = {
  region: process.env.CDK_DEFAULT_REGION,
  account: process.env.CDK_DEFAULT_ACCOUNT,
};

const vars = getEnvVars();

const app = new cdk.App();
new IamStack(app, "IamStack", {
  env,
  repositoryConfig: [vars.repositoryConfig],
});

function getEnvVars() {
  const vars = {
    repositoryConfig: {
      owner: process.env.GITHUB_OWNER!,
      repo: process.env.GITHUB_REPO!,
    },
  };
  for (const key in vars) {
    if (!vars[key as keyof typeof vars]) {
      throw new Error(`Environment variable ${key} is missing`);
    }
  }

  return vars;
}
