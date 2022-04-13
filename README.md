# DevOps Challenge

Neste desafio foi me pedido para automatizar o deploy de uma aplicação Sinatra (Ruby) com zero-downtime
Para tal, segui o tutorial da AWS (link 1) para montar a infraestrutura e adaptei o processo para terraform.


    * https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-sinatra-tutorial.html

    * https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.CNAMESwap.html

    * https://docs.aws.amazon.com/cli/latest/reference/elasticbeanstalk/index.html#cli-aws-elasticbeanstalk

    

## Pre-requesitos

    * Git instalado na consola
    * Conta AWS (Access e Private keys)
    * AWS CLI configurado com a Access e Private keys ( aws configure --profile indie )
    * Preencher o ficheiro terraform.tfvars com os valores adequados (geralmente coloco este ficheiro no gitignore)

## Montar Infraestrutura

Dentro do repositório: 

    * cd terraform
    * terraform init
    * terraform apply

O resultado são dois ambientes:

    * dev com a versão 3.0.0
    * prod com a versão 1.0.0  

## Infraestrutura

    *1 AWS VPC
    *2 AWS Elastic Beanstalk Environments (prod e dev)

## Deploy da Aplicação (manual)

    * Aceder ao environment (dev ou prod) pela AWS
    * Carregar em "Upload and Deploy" e selecionar a build
    * Verificar se deploy foi bem sucedido

## Deploy da Aplicação com zero-downtime (manual)

    *Criar um novo ambiente no beanstalk (temp-prod)
    *Verificar que o deploy foi bem sucedido (nesse novo ambiente)
    *Realizar a troca de URL pela consola da AWS

## Green/Blue Deploy
 
Este deploy consiste na troca de url's entre dev e prod, para tal é necessário mudar o valor 
count para "1" no "swap" do ficheiro terraform/main.tf....ou basta mudar pela AWS Home Console

