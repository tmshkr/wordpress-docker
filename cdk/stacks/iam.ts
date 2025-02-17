import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { aws_iam as iam } from "aws-cdk-lib";

export interface IamStackProps extends cdk.StackProps {
  readonly repositoryConfig: { owner: string; repo: string; filter?: string }[];
}

export class IamStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: IamStackProps) {
    super(scope, id, props);

    const githubProvider = new iam.OpenIdConnectProvider(
      this,
      "GithubActionsProvider",
      {
        url: "https://token.actions.githubusercontent.com",
        clientIds: ["sts.amazonaws.com"],
      }
    );

    const authorizedRepositories = props.repositoryConfig.map(
      ({ owner, repo, filter }) => `repo:${owner}/${repo}:${filter ?? "*"}`
    );

    const ghaRole = new iam.Role(this, "GitHubActionsRole", {
      assumedBy: new iam.WebIdentityPrincipal(
        githubProvider.openIdConnectProviderArn,
        {
          StringEquals: {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          },
          StringLike: {
            "token.actions.githubusercontent.com:sub": authorizedRepositories,
          },
        }
      ),
      roleName: "GitHubActionsRole",
      description: "IAM Role for use with GitHub Actions via OIDC provider",
      maxSessionDuration: cdk.Duration.hours(1),
      managedPolicies: [
        iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "AdministratorAccess-AWSElasticBeanstalk",
          "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"
        ),
      ],
    });

    this.exportValue(ghaRole.roleArn, {
      name: "GitHubActionsRoleARN",
      description: "ARN of IAM role for use with GitHub Actions",
    });

    const instanceRole = new iam.Role(this, "InstanceRole", {
      assumedBy: new iam.ServicePrincipal("ec2.amazonaws.com"),
      roleName: "aws-elasticbeanstalk-ec2-role",
      managedPolicies: [
        iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "AWSElasticBeanstalkWebTier",
          "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
        ),
        iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "AmazonSSMManagedInstanceCore",
          "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        ),
      ],
      inlinePolicies: {
        BeanstalkInstancePolicy: iam.PolicyDocument.fromJson({
          Version: "2012-10-17",
          Statement: [
            {
              Sid: "BeanstalkInstancePolicy",
              Effect: "Allow",
              Resource: "*",
              Action: [
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:DescribeEnvironmentResources",
                "ssm:GetParametersByPath",
              ],
            },
          ],
        }),
      },
    });

    this.exportValue(instanceRole.roleArn, {
      name: "BeanstalkInstanceRoleARN",
    });

    const instanceProfile = new iam.InstanceProfile(this, "InstanceProfile", {
      instanceProfileName: "aws-elasticbeanstalk-ec2-role",
      role: instanceRole,
    });

    const serviceRole = new iam.Role(this, "EbServiceRole", {
      assumedBy: new iam.ServicePrincipal("elasticbeanstalk.amazonaws.com"),
      path: "/service-role/",
      roleName: "aws-elasticbeanstalk-service-role",
      managedPolicies: [
        iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "AWSElasticBeanstalkEnhancedHealth",
          "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
        ),
        iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy",
          "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
        ),
      ],
    });
  }
}
