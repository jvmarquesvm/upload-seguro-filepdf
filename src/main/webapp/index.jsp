<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exemplo Java 17 + JSP, Bootstrap & Upload Seguro</title>

    <!-- Bootstrap 5 CSS via CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- CSS Customizado -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Barra de Navegação -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-filetype-java text-danger fs-3"></i>
                <span>Java 17 & JSP Demo</span>
            </a>
            <span class="navbar-text text-light-emphasis small">
                Bootstrap 5 &middot; Upload Seguro &middot; Magic Bytes Check
            </span>
        </div>
    </nav>

    <div class="container py-2">
        <!-- Banner de Apresentação -->
        <div class="hero-header mb-4 text-center text-md-start d-md-flex align-items-center justify-content-between">
            <div>
                <h1 class="h3 fw-bold mb-2">Formulário com Upload de Arquivo Seguro</h1>
                <p class="mb-0 text-white-50">Exemplo completo com inputs, checkboxes, botões e validação rigorosa de PDF (Magic Bytes & máx. 15MB).</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2 justify-content-center">
                <span class="badge bg-light text-dark px-3 py-2 fs-6 shadow-sm">
                    <i class="bi bi-shield-check text-success me-1"></i> Proteção contra PDF Falso
                </span>
                <span class="badge bg-light text-dark px-3 py-2 fs-6 shadow-sm">
                    <i class="bi bi-file-earmark-pdf text-danger me-1"></i> Até 15MB
                </span>
            </div>
        </div>

        <%
            // Exibição de Alerta de Erro de Segurança / Validação
            String erro = (String) request.getAttribute("erro");
            if (erro != null && !erro.isBlank()) {
        %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-shield-exclamation fs-2 text-danger"></i>
                    <div>
                        <h5 class="alert-heading mb-1 fw-bold">Bloqueio de Validação / Segurança</h5>
                        <p class="mb-0"><%= erro %></p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>

        <!-- Se os dados e o arquivo tiverem sido submetidos com sucesso -->
        <%
            Boolean sucesso = (Boolean) request.getAttribute("sucesso");
            if (sucesso != null && sucesso) {
                String nome = (String) request.getAttribute("nome");
                String email = (String) request.getAttribute("email");
                String cargo = (String) request.getAttribute("cargo");
                String bio = (String) request.getAttribute("bio");
                Boolean aceitouTermos = (Boolean) request.getAttribute("aceitouTermos");
                java.util.List<?> habilidades = (java.util.List<?>) request.getAttribute("habilidades");
                String nomeArquivoOriginal = (String) request.getAttribute("nomeArquivoOriginal");
                String nomeArquivoSalvo = (String) request.getAttribute("nomeArquivoSalvo");
                String tamanhoFormatado = (String) request.getAttribute("tamanhoArquivoFormatado");
        %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 mb-4" role="alert">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check2-circle fs-2 text-success"></i>
                    <div>
                        <h5 class="alert-heading mb-1 fw-bold">Formulário e Arquivo Processados com Sucesso!</h5>
                        <p class="mb-0 small text-body-secondary">A integridade do arquivo PDF foi confirmada no servidor (Magic Bytes validados com sucesso):</p>
                    </div>
                </div>
                <hr>
                <div class="row g-2">
                    <div class="col-sm-6"><strong>Candidato:</strong> <%= nome != null ? nome : "-" %></div>
                    <div class="col-sm-6"><strong>E-mail:</strong> <%= email != null ? email : "-" %></div>
                    <div class="col-sm-6"><strong>Cargo/Área:</strong> <%= cargo != null ? cargo : "-" %></div>
                    <div class="col-sm-6"><strong>Termos Aceitos:</strong> <%= (aceitouTermos != null && aceitouTermos) ? "Sim" : "Não" %></div>

                    <!-- Dados do Arquivo Validado -->
                    <div class="col-12 mt-2">
                        <div class="p-3 bg-white rounded border">
                            <h6 class="fw-bold text-primary mb-2">
                                <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i> Currículo Armazenado no Servidor
                            </h6>
                            <ul class="list-unstyled mb-0 small">
                                <li><strong>Nome original enviado:</strong> <%= nomeArquivoOriginal %></li>
                                <li><strong>Identificador seguro salvo:</strong> <code><%= nomeArquivoSalvo %></code></li>
                                <li><strong>Tamanho validado:</strong> <%= tamanhoFormatado %> (limite: 15MB)</li>
                                <li><strong>Localização no projeto:</strong> <code>uploads/curriculos/<%= nomeArquivoSalvo %></code></li>
                                <li><strong>Assinatura binária verificada:</strong> <span class="badge bg-success-subtle text-success border border-success-subtle">Válido (%PDF-)</span></li>
                            </ul>
                        </div>
                    </div>

                    <div class="col-12 mt-2">
                        <strong>Habilidades selecionadas:</strong>
                        <div class="mt-1">
                            <% 
                                if (habilidades != null && !habilidades.isEmpty()) {
                                    for (Object hab : habilidades) {
                            %>
                                        <span class="badge-skill"><i class="bi bi-tag-fill me-1"></i><%= hab %></span>
                            <% 
                                    }
                                } else {
                            %>
                                <span class="text-muted fst-italic">Nenhuma selecionada.</span>
                            <% } %>
                        </div>
                    </div>
                    <% if (bio != null && !bio.isBlank()) { %>
                        <div class="col-12 mt-2">
                            <strong>Apresentação / Bio:</strong>
                            <p class="mb-0 bg-white p-2 rounded border small text-muted"><%= bio %></p>
                        </div>
                    <% } %>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Card do Formulário -->
                <div class="card custom-card p-4 p-md-5 mb-5">
                    <div class="d-flex align-items-center justify-content-between pb-3 mb-4 border-bottom">
                        <h2 class="h4 fw-bold mb-0 text-dark">
                            <i class="bi bi-person-lines-fill me-2 text-primary"></i>Inscrição & Envio de Currículo
                        </h2>
                        <span class="text-muted small">* Campos obrigatórios</span>
                    </div>

                    <!-- Início do Formulário com enctype="multipart/form-data" -->
                    <form action="${pageContext.request.contextPath}/cadastrar" 
                          method="POST" 
                          enctype="multipart/form-data" 
                          class="needs-validation" 
                          novalidate>
                        
                        <!-- Inputs de Texto e Email -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="nome" class="form-label">
                                    <i class="bi bi-person me-1"></i> Nome Completo <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="nome" name="nome" placeholder="Ex: Maria da Silva" required>
                                <div class="invalid-feedback">Por favor, informe seu nome.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope me-1"></i> E-mail <span class="text-danger">*</span>
                                </label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="nome@exemplo.com" required>
                                <div class="invalid-feedback">Informe um e-mail válido.</div>
                            </div>
                        </div>

                        <!-- Dropdown de Cargo -->
                        <div class="mb-3">
                            <label for="cargo" class="form-label">
                                <i class="bi bi-briefcase me-1"></i> Área de Atuação
                            </label>
                            <select class="form-select" id="cargo" name="cargo">
                                <option value="Desenvolvedor Backend">Desenvolvedor Backend (Java)</option>
                                <option value="Desenvolvedor Frontend">Desenvolvedor Frontend</option>
                                <option value="Fullstack">Desenvolvedor Full Stack</option>
                                <option value="Engenheiro DevOps">Engenheiro DevOps</option>
                                <option value="Estudante/Outro">Estudante / Outro</option>
                            </select>
                        </div>

                        <!-- UPLOAD DE ARQUIVO (Currículo PDF - Máx 15MB) -->
                        <div class="mb-3">
                            <label for="curriculo" class="form-label d-flex justify-content-between align-items-center">
                                <span>
                                    <i class="bi bi-file-earmark-pdf-fill text-danger me-1"></i> 
                                    Currículo (.PDF) <span class="text-danger">*</span>
                                </span>
                                <span class="badge bg-secondary-subtle text-secondary small fw-normal">Máx: 15 MB</span>
                            </label>
                            <input class="form-control" 
                                   type="file" 
                                   id="curriculo" 
                                   name="curriculo" 
                                   accept=".pdf,application/pdf" 
                                   required>
                            <div class="form-text small text-muted">
                                Apenas arquivos com extensão <code>.pdf</code> genuínos até 15MB. O conteúdo binário do arquivo é inspecionado contra adulterações.
                            </div>
                            <div class="invalid-feedback" id="curriculoFeedback">
                                Selecione um arquivo de currículo em formato .pdf válido (até 15MB).
                            </div>
                        </div>

                        <!-- Checkboxes: Habilidades -->
                        <div class="mb-4">
                            <label class="form-label d-block">
                                <i class="bi bi-check-square me-1"></i> Habilidades e Preferências
                            </label>
                            <div class="row g-2 pt-1">
                                <div class="col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="habilidades" value="Java 17" id="checkJava" checked>
                                        <label class="form-check-label" for="checkJava">
                                            Java 17 / Jakarta EE
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="habilidades" value="JSP & Servlets" id="checkJsp" checked>
                                        <label class="form-check-label" for="checkJsp">
                                            JSP & Servlets
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="habilidades" value="HTML5 & Bootstrap" id="checkBootstrap">
                                        <label class="form-check-label" for="checkBootstrap">
                                            HTML5 & Bootstrap 5
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="habilidades" value="Segurança Web" id="checkSec" checked>
                                        <label class="form-check-label" for="checkSec">
                                            Segurança & Magic Bytes
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Input Textarea: Apresentação -->
                        <div class="mb-4">
                            <label for="bio" class="form-label">
                                <i class="bi bi-chat-left-text me-1"></i> Mensagem / Apresentação
                            </label>
                            <textarea class="form-control" id="bio" name="bio" rows="3" placeholder="Conte brevemente sobre seu perfil..."></textarea>
                        </div>

                        <!-- Checkbox Único com Switch (Termos de Uso) -->
                        <div class="form-check form-switch mb-4">
                            <input class="form-check-input" type="checkbox" id="termos" name="termos" required>
                            <label class="form-check-label" for="termos">
                                Concordo com o envio do currículo e termos do exemplo <span class="text-danger">*</span>
                            </label>
                            <div class="invalid-feedback">Você precisa aceitar os termos antes de enviar.</div>
                        </div>

                        <!-- Botões de Ação -->
                        <div class="d-flex flex-column flex-sm-row gap-2 justify-content-end pt-2 border-top">
                            <button type="reset" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Limpar Campos
                            </button>
                            <button type="submit" class="btn btn-primary" id="btnSubmit">
                                <i class="bi bi-cloud-upload-fill me-1"></i> Enviar Inscrição
                            </button>
                        </div>

                    </form>
                    <!-- Fim do Formulário -->

                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS (com Popper) via CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
    <!-- Script Customizado com Validação de Arquivo -->
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
