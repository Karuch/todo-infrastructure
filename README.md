**Infrastrucutre for todo**

**Description**
This repository contains the needed files to deploy the right recourses for todo app and it’s CICD infrastructure using Terraform.

* Note that you need to add the CSI driver addon manualy after terrafrom done deploying all the recourses using the CSI role defiend in the terraform files!

* You need to configure manually the secret group outbound and inbound rules to allow ingress!

**Tags**
"Owner"           = "talk"
"bootcamp"        = "int"
"expiration_date" = "30-02-23"

we need those specific tags to get the right permissions on develeap's AWS.
the rest are optional.

**Providers:**
s3 -> so the tf state will be maintained remotly on the cloud and not locally.
aws 
helm 

**argo_release recourses:**
ingress controller chart 
ArgoCD chart

**VPC**
3 public subnets
3 private subnets

**ECR**
**EKS**
**CSI EBS Driver role**
some of the components in our CICD arhitecture requires CSI EBS driver to be installed so they will be able to create persistent volumes etc’.
We need to attach the CSI EBS Driver role to the CSI EBS driver after it being deployed.

**Installation**
git clone https://gitlab.com/tal_docs/portfolio-infrastructure.git

**Support**
talk474747@gmail.com

**Roadmap**
Adding values to the terraform, adding option for adding outbound and inbound values in terraform, make the code more clear and less complicated using loops, operators etc’. 

**Contributing**
Not intersting in contributing currently.

**Authors and acknowledgment**
Written by Tal.

**Project status**
On track