// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedChain {

    // Estrutura que define quais dados um Exame Médico terá armazenado na blockchain
    struct Exam {
        string examType;       // Ex: "Hemograma", "Ressonância Magnética"
        string hospitalName;   // Ex: "Hospital São Luiz", "Laboratório Fleury"
        string examDate;       // Ex: "28/05/2026"
        string ipfsHash;       // O link seguro/hash onde o PDF do exame está guardado (ex: IPFS)
        uint256 timestamp;     // Momento exato em que o registro foi gravado na blockchain
    }

    // Mapeamento que vincula uma ID do Paciente (pode ser o CPF mascarado/criptografado ou um ID anônimo) 
    // a uma lista (array) de todos os exames dele.
    mapping(string => Exam[]) private patientExams;

    // Evento que avisa a rede sempre que um novo exame for cadastrado (ótimo para sistemas lerem em tempo real)
    event ExamRegistered(string indexed patientId, string examType, string hospitalName);

    /**
     * @dev Função para cadastrar um novo exame para um paciente.
     * @param _patientId ID identificadora do paciente (ex: string do CPF ou Hash anônimo).
     * @param _examType Tipo do exame realizado.
     * @param _hospitalName Nome da instituição de saúde que realizou o exame.
     * @param _examDate Data em que o exame foi realizado.
     * @param _ipfsHash Hash/Link do arquivo digital do exame.
     */
    function registerExam(
        string memory _patientId,
        string memory _examType,
        string memory _hospitalName,
        string memory _examDate,
        string memory _ipfsHash
    ) public {
        // Cria o objeto do exame com os dados recebidos
        Exam memory newExam = Exam({
            examType: _examType,
            hospitalName: _hospitalName,
            examDate: _examDate,
            ipfsHash: _ipfsHash,
            timestamp: block.timestamp
        });

        // Adiciona o exame na lista correspondente à ID daquele paciente
        patientExams[_patientId].push(newExam);

        // Dispara o evento na rede blockchain
        emit ExamRegistered(_patientId, _examType, _hospitalName);
    }

    /**
     * @dev Função que busca e retorna a lista completa de exames de um paciente específico.
     * @param _patientId ID identificadora do paciente.
     */
    function getPatientExams(string memory _patientId) public view returns (Exam[] memory) {
        return patientExams[_patientId];
    }
}
