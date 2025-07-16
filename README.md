# 📺 TV Assinatura

Sistema de gestão de assinaturas com planos, pacotes, serviços adicionais, cobranças e faturas, feito com **Ruby on Rails 8.0.2** e **Ruby 3.4.4**.

## ⚙️ Requisitos

Antes de começar, você precisa ter instalado:

- [Ruby 3.4.4](https://www.ruby-lang.org/pt/downloads/)
- [Rails 8.0.2](https://rubyonrails.org/)
- [Node.js](https://nodejs.org/) (recomendado v18+)
- [Bundler](https://bundler.io/)
- [Google Chrome](https://www.google.com/chrome/) (caso vá rodar testes system)

## 🚀 Rodando o projeto localmente

### 1. Clone o repositório

```bash
git clone git@github.com:ronaldosenajr/tv-assinatura.git
cd tv-assinatura
```

### 2. Instalar as dependências

```bash
bundle install
```

### 3. Criar o banco de dados

```bash
rails db:create
rails db:migrate
```

### 4. Iniciar o servidor

```bash
rails server
```

Acesse a aplicação em [http://localhost:3000](http://localhost:3000).

## 🧪 Rodando os testes

### Banco de dados dos testes

```bash
rails db:test:prepare
```

### Rodando os Testes RSpec

```bash
bundle exec rspec
```

### ✅ Checklist de ambiente

- Ruby: ruby -v deve mostrar 3.4.4

- Rails: rails -v deve mostrar 8.0.2

- Node.js: node -v deve mostrar v18 ou superior

## 🗂️ Estrutura do projeto

```text
app/
├── controllers/
├── models/
├── views/
├── services/
├── jobs/
└── ...
spec/
├── models/
├── requests/
└── ...
```

## 📝 Licença

Este projeto está sob a licença MIT.

## 👤 Autor

[Ronaldo Sena Jr.](https://www.linkedin.com/in/ronaldo-sena-junior/)
Desenvolvedor Full Stack | Estudante de Jogos Digitais
[ronaldosenajr@gmail.com](mailto:ronaldosenajr@gmail.com)
