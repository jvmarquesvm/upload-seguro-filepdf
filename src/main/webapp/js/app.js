// Validação client-side do formulário via Bootstrap e restrições de arquivo
(() => {
    'use strict';

    const MAX_SIZE_BYTES = 15 * 1024 * 1024; // 15 Megabytes
    const forms = document.querySelectorAll('.needs-validation');
    const inputCurriculo = document.getElementById('curriculo');
    const curriculoFeedback = document.getElementById('curriculoFeedback');

    // Validação em tempo real do arquivo selecionado
    if (inputCurriculo) {
        inputCurriculo.addEventListener('change', () => {
            validarArquivo(inputCurriculo);
        });
    }

    function validarArquivo(input) {
        const file = input.files[0];
        if (!file) {
            input.setCustomValidity('Por favor, selecione um arquivo de currículo em PDF.');
            if (curriculoFeedback) {
                curriculoFeedback.textContent = 'Por favor, selecione um arquivo de currículo em PDF.';
            }
            return false;
        }

        // 1. Checagem de extensão
        const fileName = file.name.toLowerCase();
        if (!fileName.endsWith('.pdf')) {
            input.setCustomValidity('Formato inválido. Apenas arquivos com extensão .pdf são aceitos.');
            if (curriculoFeedback) {
                curriculoFeedback.textContent = 'Formato inválido! O arquivo precisa ser obrigatoriamente um documento .pdf.';
            }
            return false;
        }

        // 2. Checagem de tamanho (máximo 15MB)
        if (file.size > MAX_SIZE_BYTES) {
            const tamanhoMB = (file.size / (1024 * 1024)).toFixed(2);
            input.setCustomValidity('Arquivo muito grande.');
            if (curriculoFeedback) {
                curriculoFeedback.textContent = `Tamanho excessivo: ${tamanhoMB} MB. O limite máximo permitido é de 15 MB.`;
            }
            return false;
        }

        // Se passar nas validações do cliente
        input.setCustomValidity('');
        return true;
    }

    // Interceptação da submissão do formulário
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            let isFileValid = true;
            if (inputCurriculo) {
                isFileValid = validarArquivo(inputCurriculo);
            }

            if (!form.checkValidity() || !isFileValid) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();
