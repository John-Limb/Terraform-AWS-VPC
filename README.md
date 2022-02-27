# Terraform - AWS VPC

This repo is designed to spin up a basic 3 tier AWS VPC

# Details

The provided terraform files will create a VPC with 3 tiers. Public, Private, Restricted.
Nat Gateways will be spawned based on how may AZ's are in a region, meaning any amount of  Elastic IP's will be taken and used. 
It has been designed this way so that regardless of an AZ being alive or not, hosts in both public and private subnets will have internet access. 
It has been mostly designed around regions with 3 Availability zones. 

Example : in EU-West-2 there are 3AZ's therefore, 3 subnets of each type will be spawned and 3 NAT Gateways will also be created.

## Routes and NACLS and IP addressing

Each AZ in the private and Restricted subnets have their own route tables, this might seem a bit over kill but it means that we are able to attach multiple NAT Gateways and use them as gateway of last resort. 
Public will have a single route table as in most cases EC2 instances will have their own Elastic IP's attached to them. 

NACL's will allow all traffic in and out on both Public and Private subnets, Restricted subnets do not have internet access only VPC traffic is allowed.

The overall VPC CIDR is a /22 with each tier being passed a /24 respectively, this is then split up further so that each tier in a given AZ is given a /26 - which equates to 62 hosts per AZ - clearly this will change if there are more or less AZ's in each region.

## Security groups
Basic design is to keep it open,this is basic infra no security groups will be created at spawn, create and attach own security groups based on the services that will be built on top of this.

## Terraform backend

Terraform backend has been set to S3 and dynamo DB - pass your own DB id and s3 bucket along with key into the variables file 

![Alt text](/src/Files/awsvpc.jpg "VPC Diagram")