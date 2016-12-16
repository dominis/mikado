# Mikado

## Intro

Mikado helps managing your AWS infrastructure for WordPress sites by defining an out-of-box, highly available, easy-to-deploy setup.

The project goals are:
- Provide an oversimplified but flexible and resilient one-click WordPress deployment
- Create a widely used standardized WordPress infrastructure
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
- The WordPress site will be deployed to an Multi-AZ Auto scaling group with a set of pre-defined but fine tunable up/down scaling rules
- Uploaded assets are stored on an EFS drive
- A Multi-AZ RDS cluster is used in the database layer
- Route53 used to manage DNS for the site
- Optionally you can deploy a Fastly service for your site to cache all your requests.

## Quick start

```
curl -s https://raw.githubusercontent.com/dominis/mikado/master/scripts/mikado-boom > /tmp/mikado-boom ; bash /tmp/mikado-boom
```

Mikado provides a Vagrant instance for local development with all the dependencies installed.

Also a dialog based installer provided.

![mikado](https://cloud.githubusercontent.com/assets/157738/21269257/54795560-c3b2-11e6-90d9-8432dcb38e01.gif)

### Manual setup

If you don't want to use the installer or you want more control of what's happening you can run the following steps:

```
git clone https://github.com/dominis/mikado.git
cd mikado

# create your configuration
cp mikado.conf.example mikado.conf
vi mikado.conf

# now you can build the base infra
# this will create a VPC with subnets, IAM roles, trusted SG, EFS storage for the uploads
# more info in terraform/base*.tf
# NB terraform always called through make because of the config
make apply


# the next step is building your first AMI
# this image will be used in the Auto Scaling Group
make build-ami

# at this point you need to deploy this AMI to your production ASG
# this step is only needed because you need an AMI id to be able to create the ASG
# in the future you can create a new AMI and only deploy it to the test ASG
# more info at: https://github.com/dominis/mikado#working-with-amis
make deploy-ami

# go to the examples directory and find a config suitable for you
cp examples/basic.tf terraform/mydomain.tf
sed -i -e "s|###DOMAIN###|mydomain.com|g" terraform/mydomain.tf

make apply

# Apply complete! Resources: 45 added, 0 changed, 0 destroyed.
# 👏 🍾
```



### Deploying your website

Mikado has a very simple automated deploy workflow based on git and branches.

You need to set the `site_repo` variable in your `mikado.conf` file in the following format: `https://YOUR_GITHUB_OAUTH_TOKEN:x-oauth-basic@github.com/YOUR_GITHUB_USER/wordpress.example.com.git`

[More info on the token creation](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)


Take a look at the [example repository](https://github.com/dominis/wordpress.example.com). The simplest way to start is forking this repo.

#### Important information about the WordPress deploy process:

- `develop` branch will be deployed to the test server
- `production` branch will be deployed to the prod server
- the `wp-contents/uploads` directory should be ignored in the `.gitignore` and shouldn't exists in the repo, a symlink is created pointing to the EFS mount here automatically
- for the test/prod database config check out the [wp-config.php](https://github.com/dominis/wordpress.example.com/blob/develop/wp-config-sample.php#L32-L36)
- [this is the script](https://github.com/dominis/mikado/blob/master/ansible/roles/wordpress/templates/deploy_wordpress.j2) which pulls the changes from git every minute on the instances

### Working with AMIs

With `make build-ami` you can generate new AMIs and with running `make apply` the latest AMI will be rolled out to the `test` ASG.

If you happy with the result on your test site you can run `make deploy-ami` to tag the AMI as production ready and with `make apply` you can initiate a rolling update on your production ASG.

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
