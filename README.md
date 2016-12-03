# Mikado

## Intro

Mikado helps managing your AWS infrastructure for Wordpress sites by defining an out-of-box, highly available, easy-to-deploy setup.

The project goals are:
- Provide an oversimplified but flexible and resilient one-click Wordpress deployment
- Create a widely used standardized Wordpress infrastructure
- Implement performance, security and infrastructure best practices
- Have automated, auditable, and idempotent configuration


## Overview

Mikado provides a fully automated way to deploy and maintain your infrastructure built with [Terraform](https://terraform.io/) and [Packer](https://packer.io/) + [Ansible](https://www.ansible.com/) with the following services integrated optionally:

- [Fastly](https://fastly.com/) - CDN
- [Statuscake](https://statuscake.com/) - external monitoring
- [Datadog](http://datadog.com/) - server monitoring & AWS resource monitoring
- [Loggly](https://loggly.com/) - remote log collection
- [Newrelic](https://newrelic.com/) - application monitoring

## Infrastructure overview

![Mikado overview](https://github.com/dominis/mikado/blob/master/resources/mikado-infra.png)

- Mikado will create its own VPC with public and private subnets in all the available Availability Zones in the selected region - providing a geo-redundant highly-available setup
- The Wordpress site will be deployed to an Multi-AZ Auto scaling group with a set of pre-defined but fine tunable up/down scaling rules
- Uploaded assets are stored on an EFS drive
- A Multi-AZ RDS cluster is used in the database layer
- Route53 used to manage DNS for the site
- Optionally you can deploy a Fastly service for your site to cache all your requests.

## Quick start

```
curl -s https://raw.githubusercontent.com/dominis/mikado/master/scripts/mikado-boom > /tmp/mikado-boom ; bash /tmp/mikado-boom
```

### Building your base AWS infra

Mikado provides a Vagrant instance for local development with all the dependencies installed.

Also a dialog based installer provided.

![installer](https://cloud.githubusercontent.com/assets/157738/20834138/cb8d69cc-b893-11e6-9abc-d3d48dc32b43.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20834140/cb906384-b893-11e6-860f-4742cd1668bc.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20834141/cb908008-b893-11e6-95e5-4a936874845e.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20834137/cb8c66a8-b893-11e6-9cba-df01e8eaac01.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20834139/cb8de0a0-b893-11e6-995f-3bd7e0b60b16.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20834136/cb8c2940-b893-11e6-97f8-289e902a68ee.png)
![installer](https://cloud.githubusercontent.com/assets/157738/20837059/9b65aa3e-b8a2-11e6-892a-82a0e8083ab3.png)


### Deploying your website

Mikado has a very simple automated deploy workflow based on git and branches.

You need to set the `site_repo` variable in the `env.mk` file in the following format: `https://YOUR_GITHUB_OAUTH_TOKEN:x-oauth-basic@github.com/YOUR_GITHUB_USER/wordpress.example.com.git`

[More info on the token creation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)


Take a look at the [example repository](https://github.com/dominis/wordpress.example.com). The simplest way to start is forking this repo.

#### Important information about the wordpress deploy process:

- `develop` branch will be deployed to the test server
- `production` branch will be deployed to the prod server
- the `wp-contents/uploads` directory should be ignored in the `.gitignore` and shouldn't exists in the repo, a symlink is created pointing to the EFS mount here automatically
- for the test/prod database config check out the [wp-config.php](https://github.com/dominis/wordpress.example.com/blob/develop/wp-config-sample.php#L32-L36)
- [this is the script](https://github.com/dominis/mikado/blob/master/ansible/roles/wordpress/templates/deploy_wordpress.j2) which pulls the changes from git every minute on the instances


## FAQ

- Q: How can I ssh to my instances
- A: Both the test and prod ELB exposes ssh for the IP blocks in the internal SG (TF_VAR_allowed_cidrs env var), so you can simply `ssh ec2-user@origin.domain.com` or `ssh ec2-user@test.domain.com`.


- Q: The following error is thrown during `vagrant up`:
    _The box 'bento/centos-7.1' could not be found or could not be accessed in the remote catalog. If this is a private box on HashiCorp's Atlas, please verify you're logged in via `vagrant login`. Also, please double-check the name. The expanded URL and error message are shown below:_ (sic!)
- A: On version 1.8.7 the embedded curl Vagrant uses had a [bug](https://github.com/mitchellh/vagrant/issues/7969).
    Workaround for v1.8.7: `sudo rm -rf /opt/vagrant/embedded/bin/curl`
    Or, update Vagrant to v1.8.8

## Mailing list

https://groups.google.com/forum/#!forum/mikado-dev
