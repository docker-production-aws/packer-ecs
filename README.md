# Docker in Production using AWS - Packer Build for ECS Images

This repository provides a Packer build script for creating Amazon Machine Images (AMIs) for running custom AWS EC2 Container Service (ECS) Container Instance images, as described in the Pluralsight course Docker in Production using AWS.

## Branches

This repository contains two branches:

- [`master`](https://github.com/docker-production-aws/packer-ecs/tree/master) - represents the initial starting state of the repository as viewed in the course.  Specifically this is an empty repository that you are instructed to create in the module **Customizing ECS Container Instances**.

- [`final`](https://github.com/docker-production-aws/packer-ecs/tree/final) - represents the final state of the repository after completing all configuration tasks as described in the course material.

> The `final` branch is provided as a convenience in the case you get stuck, or want to avoid manually typing out large configuration files.  In most cases however, you should attempt to configure this repository by following the course material.

To clone this repository and checkout a branch you can simply use the following commands:

```
$ git clone https://github.com/docker-production-aws/packer-ecs.git
...
...
$ git checkout final
Switched to branch 'final'
$ git checkout master
Switched to branch 'master'
```

## Errata

No known issues.

## Further Reading

- [Latest Amazon ECS-Optimized AMI](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)
- [Packer AMI Builder reference](https://www.packer.io/docs/builders/amazon-ebs.html)
- [Configuring CloudWatch logs](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_cloudwatch_logs.html)