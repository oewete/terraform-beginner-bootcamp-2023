
# Terraform Beginner Bootcamp 2023 - Week 0 

- [Terraform Beginner Bootcamp 2023 - Week 0](#terraform-beginner-bootcamp-2023---week-0)
  - [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
    - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
    - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    - [Considerations for Linux Distribution](#considerations-for-linux-distribution)
      - [Shebang Considerations](#shebang-considerations)
  - [Execution Considerations](#execution-considerations)
      - [Linux Permissions Considerations](#linux-permissions-considerations)
    - [Gitpod Lifecycle (Init,Before, Command)](#gitpod-lifecycle-initbefore-command)
    - [Working Env Vars](#working-env-vars)
    - [env command](#env-command)
    - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
    - [Printing Vars](#printing-vars)
    - [Scoping of Env vars](#scoping-of-env-vars)
    - [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
    - [AWS CLI Installation](#aws-cli-installation)
  - [Terraform Basics](#terraform-basics)
    - [Terraform Registry](#terraform-registry)
  - [Terraform Console](#terraform-console)
      - [Terraform Init](#terraform-init)
      - [Terraform Plan](#terraform-plan)
      - [Terraform Apply](#terraform-apply)
      - [Terraform Destroy](#terraform-destroy)
      - [Terraform Lock files](#terraform-lock-files)
      - [Terraform State Files](#terraform-state-files)
      - [Terraform Directory](#terraform-directory)
      - [Issues with Terraform Cloud Login \& Gitpod workspace](#issues-with-terraform-cloud-login--gitpod-workspace)
      - [Set Execution Mode in Terraform Cloud from remote to local](#set-execution-mode-in-terraform-cloud-from-remote-to-local)
  
## Semantic Versioning

This project is going to utilize semantic versioning for its tagging.

[semver.org](https://semver.org/)

The general format :

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`
 
- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

# Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for installation

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues we noticed that bash scripts steps were a considerable mmount more code. So w decided to create a bash script to install the Terraform CLI

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy
- This allow us an easier way to debug & execute manually Terraform
  
### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)






#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program that will interpret the script eg '#!/bin/bash'

ChatGPT recommended this format for bash: '#!/usr/bin/env bash'

- for portability for different OS distribution
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

## Execution Considerations

When executing the bash script we can use the './' shorthand notation to execute the bash script

eg. './bin/install_terrraform_cli'

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. 'source ./bin/install_terraform_cli'

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```
https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle (Init,Before, Command)

We need to be careful when using the init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the 'env' command

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
within a bash script we can set env without writing export
```sh
#!/usr/bin/env bash
HELLO='world'

echo HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo HELLO`

### Scoping of Env vars

When you open new bash terminals in VSCode, it will not be aware of env vars that you have set in another window

If you want to env vars to persist across all future bash terminals that are open uou need to set env vars in your bash profile eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the '.gitpod.yml' but this can only contain non-sensitive env vars.


### AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS Credentials is configured correctly by running the following command

```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload retrun that looks like this :
```
{
    "UserId": "AIEASY2ISN4BTVOR2QBSW",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-user"
}
```

We'll need to generate AWS CLI credentials from IAM user inorder to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules form the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io)

- **Providers** is an interface to APIs that will allow you to create resources in Terraform
- **Modules** are a way to make large amount of terraform code modular, portable and shareable

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)
## Terraform Console

We can see a list of all the terraform commands by simply typing `terraform`

#### Terraform Init

`terraform init`

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset i.e. "plan" to be passed to an apply, but often you can just ignore outputting

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt us yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`

This will destroy resources, you can also use the auto-approve flag to skip the approval prompt
eg `terraform destroy --auto-approve`

#### Terraform Lock files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The terraform lock file **should be committed** to your Version Control System (VSC) e.g. Github


#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terrform providers

#### Issues with Terraform Cloud Login & Gitpod workspace

After attempting to migrate the state file to terraform cloud , there was a prompt to login using `terraform login`

This shows an editor but ran into some issues where i had to exit `/Q` & manually generated a token by launching [] (https://app.terraform.io/app/settings/tokens?source=terraform-login) to generate a token and pasted in command prompt for a succcesful  terraform login.

OR

Create & Open the file manually

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code & replace your token
```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR TERRAFORM CLOUD TOKEN"
    }
  }
}
```

We have automated this workaround using the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)

#### Set Execution Mode in Terraform Cloud from remote to local

On running `terraform apply` , an error **Error: No valid credential sources found for AWS Provider.**

This was fixed by changing the Execution mode on Terraform Cloud Organization settings from Remote to Local

eg [[link](https://app.terraform.io/app/YOUR-ORGANIZATION/settings/profile)](https://app.terraform.io/app/YOUR-ORGANIZATION/settings/profile)