# DevOps Challenge

Neste desafio foi me pedido para automatizar o deploy de uma nova versão de uma aplicação Sinatra (Ruby) com zero-downtime
Para tal, segui o tutorial (link 1) da AWS para montar a infraestrutura e adaptei o processo para terraform.

Nota: O deploy automatizado ainda não foi implementado, uma vez que o AWS CodePipeline não consegue dar pull de tags (apenas de branches),
portanto vai ser necessário uma nova abordagem. No entanto, é possivel fazer a gestão do deploy com zero-downtime (link 2) manualmente com a infraestrutura fornecida pelo codigo de Terraform 

    * https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ruby-sinatra-tutorial.html

    * https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.CNAMESwap.html

Nota 2: A minha nova abordagem vai ser um bash script no terraform:
    
    *git clone
    *git chekout da tag
    *build/zip 
    *aws cli para deploy com zero-downtime
    

## Pre-requesitos

    * Conta AWS (Access e Private keys)
    * Conta Github associada com a AWS ( CodeStar Connection )
    * Preencher o ficheiro terraform.tfvars com os valores adequados (geralmente coloco este ficheiro no gitignore)

## Montar Infraestrutura

Dentro do repositório: 

    *cd terraform
    *terraform init
    *terraform apply

## Deploy da Aplicação (manual)

    * Aceder ao environment (dev ou prod) pela AWS
    * Carregar em  

## Deploy da Aplicação com zero-downtime (manual)

    *

## Infraestrutura

    *1 AWS VPC
    *2 AWS Elastic Beanstalk (prod e dev environments)
    *1 AWS CodePipeline (dev)



## 


