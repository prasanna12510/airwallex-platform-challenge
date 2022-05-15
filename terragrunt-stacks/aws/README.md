# AWS Terragrunt Stacks

Each subdirectory in this folder is a deployment domain, which are separate but interdependent terragrunt stacks.

## Prerequisite

* Setup AWS credential and point it to the correct environment.
* Setup necessay CLI for module execution. e.g. skaffold, jsonnet, jb, etc.

## Setup

* A `common.yaml` is put at the root directory, to keep the common variable among all terragrunt stacks.
  * `common.yaml.example` is provided as an example.
* `vars.yaml` is used in each of the stack to supply variables to different module execution.
  * `vars.yaml.example` is provided as an example in each domain subdirectory.

## General Workfolw

1. `cd` to the desired domain subdirectory.
2. Run terragrunt:
  ```shell
  # if external dependencies is to be ignored
  terragrunt apply-all --terragrunt-ignore-external-dependencies

  # if external dependencies is to be included
  terragrunt apply-all --terragrunt-include-external-dependencies
  ```
3. User can choose to deploy only the required stack.
