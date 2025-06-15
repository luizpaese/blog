---
layout: post
title: "Infraestrutura como código: Primeiros passos com CloudFormation"
date: 2025-06-14 17:04 -0300
categories: [IaC, DevOps]
tags: [CloudFormation]     # TAG names should always be lowercase
---

## O que é IaC?
Infraestrutura como Código é uma maneira de gerenciar uma infraestrutura utilizando código ao invés de utilizar os métodos "tradicionais" manuais, como por exemplo um Console Web.

IaC é um componente importante para o mundo DevOps, pois com ele conseguimos automatizar e acelerar o processo de criação de uma infraestrutura.
Com ele o gerenciamento de configurações do ambiente fica mais simples e rápido, conseguimos replicar o mesmo ambiente diversas vezes com o mesmo código e temos menores inconsistências entre ambientes similares.

### Ferramentas de IaC
Alguns exemplos de ferramentas para IaC são:
1. CloudFormation
2. Terraform
3. Pulumi

Neste post estaremos abordando o CloudFormation, sendo uma ferramenta nativa da AWS, e também estaremos criando nossa primeira stack em CloudFormation.


## O que é CloudFormation?
[CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) é uma ferramenta nativa da AWS para gerenciamento e planejamento de infraestrutura como código.<br>
No CloudFormation os arquivos podem ser escritos em [YAML](https://yaml.org/) ou em [JSON](https://www.json.org/json-en.html).

### Beneficios
A utilização de IaC nos traz alguns beneficios e também seguranças, estão entre estes:

##### Automação
Com a utilização do IaC, podemos nos beneficiar de automatizar a criação de uma infraestrutura sob demanda utilizando uma pipeline no Github Actions por exemplo. No momento em que determinado código é enviado ao Github, a pipeline de criação da infraestrutura é iniciada, e assim todos os recursos necessários são criados de forma automatizada.

##### Reusabilidade
Não há necessidade de criar toda vez o mesmo servidor, com as mesmas configurações do zero manualmente.
Com um código de infraestrutura, basta "copiar e colar" as mesmas instruções e pronto, sua infraestrutura está praticamente pronta.<br>
> _O autor não se responsabiliza por cagadas feitas com "copia e cola", risos._
{: .prompt-warning }

##### Controle de versão
Tratando-se de um código, é importatissimo que ele seja versionado para garantir a estabilidade da infraestrutura.<br>
Com o versionamento, a colaboração também é um ponto que pode ser explorado, garantindo ainda mais confiabilidade e estabilidade (_se o seu coleguinha fazer code review_).


## Como funciona um template CloudFormation?
Bom, vamos começar do começo e para facilitar a leitura de todos vamos utilizar o YAML.

### Estrutura básica de um template CloudFormation

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: A sample template

Parameters:
  S3BucketName:
    Description: The bucket name
    Type: String
    Default: my-awesome-bucket

Resources:
  S3Bucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      BucketName: !Ref S3BucketName

Outputs:
  MyBucketName:
    Value: !Ref S3Bucket
    Description: Bucket name
```
{: file="sample.yaml" }

Acima temos um pedaço de código de um template CloudFormation que pode ser usado para criar um Bucket S3 na AWS.<br>
Podemos notar algumas chaves, que são importantes para o funcionamento do CloudFormation, vamos por partes...

#### "First lines"

Aqui existem alguns valores opcionais, mas que é interessante serem adicionados para ter uma descrição do que se trata aquele template.

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: A sample template
```

_**AWSTemplateFormatVersion**_ - Aqui temos a versão do template utilizado para o CloudFormation, essa informção tem um único valor disponível no momento de escrita deste post, que é o valor mencionado no arquivo acima.<br>
_**Description**_ - É a descrição do que esse template CloudFormation está fazendo


#### Parameters

Aqui podemos definir "variáveis"/parâmetros que serão utilizados ao longo do template CloudFormation.<br>
Os parâmetros não são obrigatórios, mas o ideal é que existam para que o template seja reutilizável, e nada fique "chumbado" em código.

```yaml
Parameters:
  S3BucketName:
    Description: The bucket name 
    Type: String
    Default: my-awesome-bucket
```

_**Parameters**_ - Início da declaração dos parâmetros.<br>
_**S3BucketName**_ - Nome do parâmetro.<br>
_**Description**_ - Descrição do que é este parâmetro, e para que ele será utilizado.<br>
_**Type**_ - O tipo do parâmetro.<br>
_**Default**_ - Valor padrão, caso nenhum definido.

Mais detalhes sobre os parâmetros podem ser encontrados na documentação da AWS, [neste](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html) link.


#### Resources

Aqui serão definidos os recursos que serão criados com este template.<br>

```yaml
Resources:
  S3Bucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      BucketName: !Ref S3BucketName
```

_**Resources**_ - Início da declaração dos recursos.<br>
_**S3Bucket**_ - Nome do recurso, neste caso um Bucket S3. Poderia ser definido qualquer nome que fosse de melhor entendimento para você, por exemplo "banana" se você estivesse criando uma banana.<br>
_**Type**_ - O tipo do recurso que está sendo criado, aqui é importante respeitar os tipos fornecidos na [documentação](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-template-resource-type-ref.html) da AWS.<br>
_**Properties**_ - Início da declaração das propriedades do recurso sendo criado.<br>
_**BucketName**_ - Propriedade chamada "BucketName", aqui é onde definimos o nome do bucket que foi declarado no parâmetro "S3BucketName" na seção anterior.<br>
> **"!Ref"** é utilizado para referênciar um parâmetro. [Documentação sobre Return Values](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html#using-cross-resource-references)
{: .prompt-tip }


#### Outputs

Aqui serão definidas alguns retornos que a stack do CloudFormation dará ao fim da sua execução.<br>
Poderíamos ter definido também uma URL do Bucket S3, ou talvez o seu ARN.<br>
Não é obrigatório a definição, mas é util para ser utilizado em outro template, por exemplo.

```yaml
Outputs:
  MyBucketName:
    Value: !Ref S3Bucket
    Description: Bucket name
```

_**Outputs**_ - Início da declaração das saídas.<br>
_**MyBucketName**_ - Nome dado ao valor da saída.<br>
_**Value**_ - Valor da saída. Neste caso referênciamos o nome do Bucket S3, mas dependendo do recurso, a forma que isso é feito pode mudar. Na [documentação](https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/TemplateReference/aws-resource-s3-bucket.html#aws-resource-s3-bucket-return-values) do CloudFormation sobre o Bucket S3, existem alguns exemplos diferentes.<br>
_**Description**_ - Descrição do que é aquela saída, texto livre que pode ser usado para descrever para que servirá aquela saída, ou o que ela é.<br>


Beleza, detalhamos um template CloudFormation para criação de um Bucket S3 na AWS, e agora vamos rodar essa stack.


## Criação da stack
> É obrigatório que você tenha uma conta AWS devidamente cadastrada e configurada para rodar a stack.
{: .prompt-warning }

Para este post estaremos utilizando o Console da AWS para criar a nossa stack, mas a criação pode ser feita puramente com o AWS CLI.<br><br>

### Acessando o CloudFormation
Dentro do Console da AWS, encontre o serviço CloudFormation.
![CloudFormation Search](/assets/posts/iac-cloudformation-101/cloudformation-search.png)

### Criando a stack
Após entrar no serviço, selecione o botão "Create Stack", e preencha os campos conforme a imagem.
![CloudFormation Stack Creation 1](/assets/posts/iac-cloudformation-101/cloudformation-stack-creation-1.png)
> No botão "Choose file", faça o upload do arquivo de exemplo disponível [neste](https://github.com/luizpaese/blog-posts-codes/blob/main/iac-cloudformation-101/sample.yaml) link.
{: .prompt-info }

Após concluir o upload, clique em "Next" e você será direcionado a esta tela.
![CloudFormation Stack Creation 2](/assets/posts/iac-cloudformation-101/cloudformation-stack-creation-2.png)

Aqui deve ser definido o nome da Stack, no meu caso eu defini como "Sample-Stack".<br>
Também pode ser definido o valor para o parâmetro "S3BucketName", que nós definimos no template do CloudFormation. Caso não seja definido nenhum, o valor "Default" será atribuído a ele.

### Revisão da stack
Clique em "Next" até que a página de "Review" esteja visível, confira se o nome da stack está correta, e se o parâmetro definido está com o valor que você deseja.
![CloudFormation Stack Creation 3](/assets/posts/iac-cloudformation-101/cloudformation-stack-creation-3.png)

Note que alguns valores que definimos apenas no template estão presentes aqui, como o "Stack description" e também o valor padrão do "S3BucketName" que é "my-awesome-bucket".

### Rodando a stack
Feitas as suas validações, clique em "Submit" no fim da página.<br>
Você deve ser redirecionado para uma página para acompanhar o processo de criação dos recursos da Stack, conforme abaixo.
![CloudFormation Stack Creation 4](/assets/posts/iac-cloudformation-101/cloudformation-stack-creation-4.png)

> Como o nome "my-awesome-bucket" é muito comum, pode ser que a sua stack dê erro, nesse caso, recrie a stack com um nome menos comum.
{: .prompt-warning }

Aproveite o tempo de criação para navegar entre os menus "Stack info", "Events", "Resources", "Outputs", "Parameters" e "Template".<br>
Veja como os valores que definimos anteriormente estão todos presentes nestas telas.<br>

### Acessando os recursos criados
Agora na tela de "Events", clicando em "S3Bucket" você será redirecionado ao Bucket S3 recém criado.
![Bucket S3](/assets/posts/iac-cloudformation-101/bucket-s3.png)

Se você chegou até aqui e conseguiu acessar o Bucket S3, parabéns, a sua primeira stack em CloudFormation foi concluída com sucesso!!<br>
A maioria dos serviços da AWS podem ser criados dessa forma, a partir daqui uma grande janela de criatividade e oportunidades está aberta.

### Deletando a stack
>Para evitar gastos com a sua conta AWS, sempre lembre de deletar as stacks ao fim dos seus estudos.<br>
{: .prompt-danger }
Para deletar a sua stack, basta clicar em "Delete", dentro da sua stack conforme imagem abaixo.
![CloudFormation Stack Delete 1](/assets/posts/iac-cloudformation-101/cloudformation-stack-delete-1.png)

Após confirmar, acompanhe se todos os recursos foram deletados.

![CloudFormation Stack Delete 2](/assets/posts/iac-cloudformation-101/cloudformation-stack-delete-2.png)


## Finalização
Neste post abordamos o que é o CloudFormation, como funciona e como criar a sua primeira stack.<br>
Se você conseguiu criar com sucesso a sua stack, parabéns! Não esqueça de compartilhar o post e deixar um comentário para motivar o escritor :P<br>
Se você teve dificuldades ou gostaria de sugerir algo, deixe nos comentários abaixo.<br><br>

Obrigado por passar aqui, e nos vemos em breve[!](https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley)
