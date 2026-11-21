# Projeto Exemplo: Java 17 + JSP + Bootstrap 5 + Upload Seguro de PDF

Este projeto demonstra uma aplicação web completa utilizando **Java 17**, **JSP (JavaServer Pages)**, **Jakarta Servlets**, **Bootstrap 5**, **HTML5** e **CSS3**, com destaque para o **upload seguro de arquivos (currículos)** até **15MB**.

---

## 🚀 Funcionalidades e Componentes

### 1. Elementos de Interface (Frontend com Bootstrap 5)
- **`<label>`:** Rótulos acessíveis associados aos campos (`for="..."`) com ícones Bootstrap Icons e badges de aviso.
- **`<input>`:**
  - Campos de texto (`type="text"`), e-mail (`type="email"`), além de `<select>` e `<textarea>`.
  - **Upload de Arquivo (`type="file"`):** Campo estilizado para envio de currículo aceitando apenas arquivos `.pdf`.
- **`<input type="checkbox">`:**
  - **Múltipla escolha:** Habilidades e tecnologias selecionáveis (`name="habilidades"`), capturadas no Java via `request.getParameterValues()`.
  - **Switch / Checkbox único:** Aceite obrigatório dos termos (`name="termos"`).
- **`<button>`:** Botão principal de envio com ícone (`btn btn-primary`) e botão de redefinição/limpeza (`btn btn-outline-secondary`).

---

## 🛡️ Mecanismos de Segurança no Upload de Currículos

Para evitar ataques comuns de upload de arquivos maliciosos (ex: atacantes que pegam scripts `.jsp`, `.exe` ou `.sh` e apenas renomeiam a extensão para `.pdf`):

1. **Inspeção de Assinatura Binária (Magic Bytes):**
   - No `FormServlet.java`, o backend lê diretamente os primeiros bytes do fluxo binário (`InputStream`).
   - Todo arquivo PDF genuíno inicia impreterivelmente com a sequência `%PDF-` (bytes hexadecimais `25 50 44 46 2D`). Se os bytes não corresponderem, o upload é **rejeitado imediatamente com alerta de segurança**.
2. **Limite Rigoroso de Tamanho (15MB):**
   - **Backend:** Configurado na anotação `@MultipartConfig(maxFileSize = 15 * 1024 * 1024)`.
   - **Frontend:** Validação instantânea via JavaScript no `app.js` antes da submissão para poupar banda de rede.
3. **Prevenção de Path Traversal & Execução Maliciosa:**
   - O nome original fornecido pelo usuário nunca é utilizado como nome do arquivo no disco.
   - O arquivo é persistido com identificador único seguro via `UUID` (ex: `curriculo_123e4567-e89b-12d3-a456-426614174000.pdf`).
4. **Armazenamento no Projeto:**
   - Os arquivos são salvos na pasta interna: `uploads/curriculos/`.

---

## 📂 Estrutura de Arquivos

```
projeto-java-jsp-antigravity/
├── .mvn/wrapper/                                # Arquivos do Maven Wrapper (não necessita Maven instalado)
├── uploads/
│   └── curriculos/                              # Pasta interna para armazenamento seguro dos PDFs
├── pom.xml                                      # Configuração Maven para Java 17 e Jakarta EE
├── mvnw.cmd                                     # Script Windows para compilar e empacotar via Maven Wrapper
├── mvnw                                         # Script Linux/macOS para compilar e empacotar via Maven Wrapper
├── README.md                                    # Documentação do projeto
├── run.bat                                      # Script Windows CMD para inicialização rápida via CLI
├── run.ps1                                      # Script PowerShell para inicialização rápida via CLI
├── src/main/
│   ├── java/com/exemplo/
│   │   ├── FormServlet.java                     # Servlet multipart com validação de Magic Bytes e persistência
│   │   └── Main.java                            # Classe inicializadora com Tomcat embutido
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml                          # Descritor web Jakarta EE 6
│       ├── css/
│       │   └── style.css                        # Estilos personalizados (gradientes, cartões e badges)
│       ├── js/
│       │   └── app.js                           # Validações client-side (extensão, tamanho e Bootstrap)
│       └── index.jsp                            # Página principal com formulário completo e alertas
```

---

## 🔨 Como Compilar o Projeto (Sem Maven Instalado)

Caso você tenha baixado ou clonado o projeto e tenha **apenas a pasta `src/`, o `pom.xml` e o Java 17 instalado**, você não precisa instalar o Maven manualmente. Use o **Maven Wrapper** que acompanha o projeto:

- **No Windows (PowerShell / Prompt de Comando):**
  ```powershell
  # Apenas compilar as classes
  .\mvnw.cmd compile

  # Ou gerar o pacote completo (.war e dependências)
  .\mvnw.cmd package
  ```

- **No Linux / macOS (Bash):**
  ```bash
  ./mvnw compile
  # ou
  ./mvnw package
  ```

O wrapper baixa automaticamente a versão oficial exata do Maven na primeira execução e constrói o projeto sem poluir o sistema operacional.

---

## 🛠️ Modos de Execução da Aplicação

Você pode executar esta aplicação de 3 maneiras diferentes:

### Opção 1: Via Servidor Tomcat 10+ Externo (Arquivo `.war`)
1. Gere o pacote `.war`:
   ```powershell
   .\mvnw.cmd package
   ```
2. Realize o deploy do arquivo `target/app.war` em um servidor Apache Tomcat 10+ (compatível com Jakarta EE e Java 17).
3. Acesse: `http://localhost:8080/app/` (ou de acordo com o contexto configurado no seu Tomcat).

---

### Opção 2: Execução Direta pela IDE (Eclipse, IntelliJ IDEA ou VS Code)
1. Abra o projeto na sua IDE Java configurada com o **JDK 17**.
2. Navegue até a classe:
   `src/main/java/com/exemplo/Main.java`
3. Execute o método `main()`.
4. Acesse no navegador: `http://localhost:8080/`.

---

### Opção 3: Execução via Linha de Comando (Terminal / CLI com `java Main`)

#### Modo A: Comando direto `java`
- No **Windows (PowerShell ou Prompt de Comando)**:
  ```powershell
  java -cp "target/classes;target/app/WEB-INF/lib/*" com.exemplo.Main
  ```
- No **Linux ou macOS**:
  ```bash
  java -cp "target/classes:target/app/WEB-INF/lib/*" com.exemplo.Main
  ```

#### Modo B: Usando os scripts de conveniência
- No **Prompt de Comando (CMD)**:
  ```cmd
  run.bat
  ```
- No **PowerShell**:
  ```powershell
  .\run.ps1
  ```

Ao iniciar, você verá as mensagens de inicialização no terminal:
```
=================================================
 Servidor JSP iniciado com sucesso em Java 17!
 Acesse no navegador: http://localhost:8080
 Pressione Ctrl+C para encerrar o servidor.
=================================================
```
Para encerrar a execução a qualquer momento, pressione `Ctrl + C` no terminal.
