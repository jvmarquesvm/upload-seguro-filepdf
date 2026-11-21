package com.exemplo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * Servlet responsável por receber e processar a submissão do formulário,
 * incluindo validações rigorosas de segurança no upload de currículos em PDF.
 */
@WebServlet(name = "FormServlet", urlPatterns = {"/cadastrar"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB (armazena em memória antes de gravar em disco temp)
    maxFileSize = 15 * 1024 * 1024,         // 15 MB (limite estrito para o arquivo)
    maxRequestSize = 20 * 1024 * 1024       // 20 MB (limite total da requisição)
)
public class FormServlet extends HttpServlet {

    private static final long MAX_FILE_SIZE_BYTES = 15 * 1024 * 1024; // 15MB
    // Assinatura mágica obrigatória para arquivos PDF legítimos: %PDF-
    private static final String PDF_MAGIC_HEADER = "%PDF-";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Captura dos inputs normais
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String cargo = request.getParameter("cargo");
        String bio = request.getParameter("bio");

        // Captura do checkbox único (aceite de termos)
        String aceitouTermosParam = request.getParameter("termos");
        boolean aceitouTermos = aceitouTermosParam != null;

        // Captura de múltiplos checkboxes (habilidades)
        String[] habilidadesArray = request.getParameterValues("habilidades");
        List<String> habilidades = (habilidadesArray != null) ? Arrays.asList(habilidadesArray) : Collections.emptyList();

        // Variáveis para resultado do arquivo
        String nomeArquivoOriginal = null;
        String nomeArquivoSalvo = null;
        long tamanhoArquivo = 0;
        String erroUpload = null;

        try {
            Part arquivoPart = request.getPart("curriculo");

            if (arquivoPart == null || arquivoPart.getSize() == 0) {
                erroUpload = "O envio do currículo no formato .PDF é obrigatório.";
            } else {
                tamanhoArquivo = arquivoPart.getSize();
                nomeArquivoOriginal = Paths.get(arquivoPart.getSubmittedFileName()).getFileName().toString();

                // 1. Verificação de tamanho (máximo 15MB)
                if (tamanhoArquivo > MAX_FILE_SIZE_BYTES) {
                    erroUpload = "O arquivo excede o tamanho máximo permitido de 15MB (" 
                            + formatarTamanho(tamanhoArquivo) + ").";
                }
                // 2. Verificação de extensão declarada
                else if (!nomeArquivoOriginal.toLowerCase().endsWith(".pdf")) {
                    erroUpload = "Extensão inválida! O arquivo deve possuir a extensão .pdf.";
                } else {
                    // 3. Verificação de Segurança Profunda: Assinatura de Magic Bytes (%PDF-)
                    // Impede arquivos maliciosos renomeados (ex: malware.exe renomeado para curriculo.pdf)
                    validarMagicBytesPdf(arquivoPart);

                    // 4. Armazenamento seguro dentro do projeto (pasta uploads/curriculos)
                    // Sanitização de nome para evitar ataques de Path Traversal
                    String extensao = ".pdf";
                    nomeArquivoSalvo = "curriculo_" + UUID.randomUUID().toString() + extensao;

                    // Obtém caminho base do projeto ou diretório local de execução
                    Path diretorioDestino = Paths.get(System.getProperty("user.dir"), "uploads", "curriculos");
                    if (!Files.exists(diretorioDestino)) {
                        Files.createDirectories(diretorioDestino);
                    }

                    Path arquivoFinal = diretorioDestino.resolve(nomeArquivoSalvo);
                    try (InputStream input = arquivoPart.getInputStream()) {
                        Files.copy(input, arquivoFinal, StandardCopyOption.REPLACE_EXISTING);
                    }
                }
            }
        } catch (SecurityException se) {
            erroUpload = se.getMessage();
        } catch (IllegalStateException ise) {
            erroUpload = "O arquivo enviado excedeu o limite máximo de tamanho de 15MB permitido pelo servidor.";
        } catch (Exception e) {
            erroUpload = "Erro ao processar o upload do arquivo: " + e.getMessage();
        }

        // Se houve erro no upload ou validação
        if (erroUpload != null) {
            request.setAttribute("erro", erroUpload);
        } else {
            request.setAttribute("sucesso", true);
            request.setAttribute("nomeArquivoOriginal", nomeArquivoOriginal);
            request.setAttribute("nomeArquivoSalvo", nomeArquivoSalvo);
            request.setAttribute("tamanhoArquivoFormatado", formatarTamanho(tamanhoArquivo));
        }

        // Devolve os dados para o JSP
        request.setAttribute("nome", nome);
        request.setAttribute("email", email);
        request.setAttribute("cargo", cargo);
        request.setAttribute("bio", bio);
        request.setAttribute("aceitouTermos", aceitouTermos);
        request.setAttribute("habilidades", habilidades);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    /**
     * Valida os Magic Bytes do arquivo. Todo documento PDF legítimo inicia com "%PDF-".
     * Caso o arquivo tenha sido forjado (ex: script executável renomeado para .pdf),
     * a exceção de segurança é disparada.
     */
    private void validarMagicBytesPdf(Part part) throws IOException, SecurityException {
        byte[] cabecalho = new byte[5];
        try (InputStream is = part.getInputStream()) {
            int bytesLidos = is.read(cabecalho);
            if (bytesLidos < 5) {
                throw new SecurityException("Arquivo inválido ou corrompido: tamanho insuficiente para cabeçalho PDF.");
            }
            String cabecalhoStr = new String(cabecalho, StandardCharsets.US_ASCII);
            if (!PDF_MAGIC_HEADER.equals(cabecalhoStr)) {
                throw new SecurityException("Alerta de Segurança: O arquivo enviado possui extensão .pdf, "
                        + "mas seu conteúdo real NÃO é um PDF legítimo (cabeçalho detectado: '" + cabecalhoStr + "'). Upload bloqueado!");
            }
        }
    }

    private String formatarTamanho(long bytes) {
        if (bytes < 1024) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(1024));
        char pre = ("KMGTPE").charAt(exp - 1);
        return String.format("%.2f %sB", bytes / Math.pow(1024, exp), pre);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
