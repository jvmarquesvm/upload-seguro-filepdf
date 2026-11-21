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
├── uploads/
│   └── curriculos/                              # Pasta interna para armazenamento seguro dos PDFs
├── pom.xml                                      # Configuração Maven para Java 17 e Jakarta EE
├── README.md                                    # Documentação do projeto
├── src/main/
│   ├── java/com/exemplo/
│   │   ├── FormServlet.java                     # Servlet multipart com validação de Magic Bytes e persistência
│   │   └── Main.java                            # Inicializador com Tomcat embutido (opcional)
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

## 🛠️ Como Executar

### Opção 1: Via Servidor Tomcat 10+ Local
1. Gere o pacote `.war` através da sua IDE ou comando Maven:
   ```bash
   mvn package
   ```
2. Realize o deploy do `.war` gerado em um servidor compatível com Jakarta EE / Java 17 (ex: Apache Tomcat 10+).
3. Acesse `http://localhost:8080/`.

### Opção 2: Execução Standalone via Main (Tomcat Embutido)
1. Execute a classe Java [Main.java](file:///c:/Users/joaovictor/Documents/Projetos/projeto-java-jsp-antigravity/src/main/java/com/exemplo/Main.java).
2. Acesse a aplicação no navegador em `http://localhost:8080/`.
