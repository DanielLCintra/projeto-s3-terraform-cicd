# DevOps na Prática: Site Estático no AWS S3 com Terraform e GitHub Actions

Este repositório contém um projeto de demonstração que mostra como hospedar um site estático no Amazon S3, com a infraestrutura sendo gerenciada pelo Terraform e o processo de deploy automatizado pelo GitHub Actions.

![AWS](https://img.shields.io/badge/AWS-S3-orange)
![IaC](https://img.shields.io/badge/IaC-Terraform-purple)
![CI/CD](https://img.shields.io/badge/CI/CD-GitHub_Actions-blue)

## 📋 Sobre o Projeto

Este projeto demonstra um fluxo de trabalho DevOps completo para hospedar um site estático:

- **Infraestrutura como Código (IaC)**: Uso do Terraform para criar e gerenciar recursos da AWS
- **CI/CD**: Configuração de pipeline com GitHub Actions para automação de deploy
- **Hospedagem na Nuvem**: Utilização do Amazon S3 para hospedar um site estático de forma econômica e escalável

## 🛠️ Tecnologias Utilizadas

- **Frontend**: HTML, CSS, JavaScript
- **Cloud**: AWS S3
- **IaC**: Terraform
- **CI/CD**: GitHub Actions

## 🚀 Como Usar Este Repositório

### Pré-requisitos

- Conta na AWS
- Acesso ao [GitHub](https://github.com/)
- Git instalado localmente
- [AWS CLI](https://aws.amazon.com/cli/) (opcional para testes locais)

### 🔑 Configuração das Credenciais da AWS

1. No console da AWS, navegue até o serviço IAM
2. Crie um novo usuário com acesso programático
3. Anexe as seguintes políticas:
   - `AmazonS3FullAccess`
   - Ou crie uma política personalizada limitada apenas ao bucket específico
4. Guarde o Access Key ID e Secret Access Key

### 📁 Configuração do Repositório

1. Faça um fork deste repositório
2. Clone-o para sua máquina local:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```
3. No GitHub, vá para Settings > Secrets and variables > Actions
4. Adicione os seguintes secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

### 🧰 Configuração do Terraform

1. Modifique o arquivo `terraform/variables.tf` para ajustar:
   - Nome do bucket
   - Região da AWS
   - Ambiente de deploy

### 🏃‍♂️ Executando o Projeto

Após configurar os secrets no GitHub, basta fazer push para a branch main:

```bash
git add .
git commit -m "Atualização do site"
git push origin main
```

O GitHub Actions irá:
1. Executar o Terraform para garantir que a infraestrutura esteja atualizada
2. Fazer o deploy dos arquivos do site para o bucket S3

## 📚 Estrutura do Projeto

```
projeto-s3-terraform-cicd/
├── index.html            # Página principal do site
├── error.html            # Página de erro 404
├── css/
│   └── styles.css        # Estilos do site
├── js/
│   └── script.js         # JavaScript do site
├── terraform/
│   ├── main.tf           # Configuração principal do Terraform
│   ├── variables.tf      # Variáveis do Terraform
│   └── outputs.tf        # Outputs do Terraform
└── .github/
    └── workflows/
        └── deploy.yml    # Workflow de CI/CD do GitHub Actions
```

## 🔍 Detalhes da Implementação

### Terraform

O Terraform cria:
- Um bucket S3
- Configuração para hospedagem de site estático
- Políticas para tornar o conteúdo público

### GitHub Actions

O workflow realiza:
- Checkout do código
- Configuração das credenciais da AWS
- Execução do Terraform para atualizar a infraestrutura
- Deploy dos arquivos para o S3

## 📈 Melhorias Futuras

Algumas melhorias que podem ser implementadas:
- Adicionar CloudFront para CDN
- Configurar HTTPS com AWS Certificate Manager
- Implementar testes automatizados
- Adicionar Route 53 para domínio personalizado
- Monitoramento com CloudWatch

## 📝 Licença

Este projeto está licenciado sob a licença MIT - consulte o arquivo LICENSE para mais detalhes.

## 📞 Contato

Para dúvidas ou sugestões, abra uma issue neste repositório.

---

⭐️ Se este projeto foi útil para você, considere dar uma estrela no GitHub! ⭐️