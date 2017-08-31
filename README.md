# pipeline-samples
Samples for creating CD pipelines in Jenkins using Terraform

## jenkins
Sample pipeline script for jenkins deployments.

## backup
Backs up the JENKINS_HOME folder to S3.

## deploy-test
Deploy an ECS cluster to AWS using terraform. The pipeline pulls the tools from git,
copies artifacts from upstream projects, and uses terraform to deploy the cluster.

## deploy upstream
A generic script to deploy based on an upstream job, importing the artifacts which
specify the builds to deploy using terraform.

## destroy-test
Destroys the test cluster. This build can be scheduled in Jenkins to run over-night to
tear down on demand environments.

## service1
A sample pipeline script for a microservice, which tags and publishes the images
and archives an artifact containing the tag for downstream builds to import.

## terraform
A tool for managing terraform source and sample code for creating and deploying an ECS cluster to AWS.

### Folder Structure
* terraform/config - config files for a set of terraform resources. For regional stacks
create a folder for the region and create the stack folder under there: e.g. config/ap-southeast-2/stack-name.

* src - terraform source code for stacks of resources
* src/modules - reusable modules

Config folders should contain two files:
* tf-config.tf - configure terraform and backend state
* variables.tfvars - variables to configure your stack

### Tools
./orchestrate - A tool to manage orchestration of terraform source code.

Run as follows:
TF_USER=yourname ./orchestrate plan appcluster-test ap-southeast-2

Run the tool with no parameters for further instructions.
