-- Configurações seguras para ambientes de desenvolvimento/produção
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET TIME_ZONE = "+00:00";

-- Criação do banco de dados
DROP DATABASE IF EXISTS `controle_pecas`;
CREATE DATABASE `controle_pecas`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `controle_pecas`;

-- Tabela: fazendas
CREATE TABLE `fazendas` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

-- Inserir uma fazenda de teste
INSERT INTO fazendas (nome) VALUES ('Fazenda Teste');

-- Tabela: maquinas
CREATE TABLE `maquinas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `codigo` VARCHAR(30) UNIQUE NOT NULL COMMENT 'Código interno da máquina',
    `nome` VARCHAR(100) NOT NULL,
    `modelo` VARCHAR(50),
    `categoria` VARCHAR(50),
    `fazenda` VARCHAR(100),
    `renavam` VARCHAR(20),
    `placa` VARCHAR(10),
    `alugado` ENUM('S', 'N') DEFAULT 'N',
    `horas_uso` INT DEFAULT 0 COMMENT 'Horas totais de operação',
    `imagem_path` VARCHAR(255) COMMENT 'Caminho da imagem do equipamento',
    `data_cadastro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `status` ENUM('ativo', 'manutenção', 'desativado') DEFAULT 'ativo',
    
    -- Índices
    INDEX `idx_nome` (`nome`),
    INDEX `idx_status` (`status`),
    INDEX `idx_categoria` (`categoria`),
    INDEX `idx_fazenda` (`fazenda`),
    INDEX `idx_placa` (`placa`),
    INDEX `idx_alugado` (`alugado`)
) ENGINE=InnoDB;

-- Inserção de dados iniciais para testes
INSERT INTO `maquinas` (`codigo`, `nome`, `modelo`, `categoria`, `fazenda`, `renavam`, `placa`, `alugado`, `status`) VALUES
('MCH-JD-001', 'Trator John Deere', 'JD-5050', 'Trator', 'Fazenda Boa Esperança', '12345678900', 'ABC1D23', 'N', 'ativo'),
('MCH-CH-002', 'Colheitadeira Massey', 'CH-2020', 'Colheitadeira', 'Fazenda Vale Verde', '98765432100', 'XYZ9E88', 'S', 'ativo'),
('MCH-PL-003', 'Pulverizador Montana', 'PL-3000', 'Pulverizador', 'Fazenda Santa Ana', '56473829100', 'QWE3R21', 'N', 'manutenção');


-- Tabela: modelos de peças (nome/modelo da peça)
CREATE TABLE modelos_pecas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela: tamanhos das peças
CREATE TABLE tamanhos_pecas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) UNIQUE NOT NULL
);

-- Tabela principal: peças
CREATE TABLE pecas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    modelo_id INT NOT NULL,
    tamanho_id INT NOT NULL,
    quantidade INT DEFAULT 0 CHECK (quantidade >= 0),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Relações
    FOREIGN KEY (modelo_id) REFERENCES modelos_pecas(id),
    FOREIGN KEY (tamanho_id) REFERENCES tamanhos_pecas(id)
);

-- Tabela de relacionamento: peças ↔ máquinas compatíveis
CREATE TABLE pecas_maquinas (
    peca_id INT,
    maquina_id INT,
    PRIMARY KEY (peca_id, maquina_id),
    FOREIGN KEY (peca_id) REFERENCES pecas(id) ON DELETE CASCADE,
    FOREIGN KEY (maquina_id) REFERENCES maquinas(id) ON DELETE CASCADE
);

-- Inserir modelos de peças
INSERT INTO modelos_pecas (nome) VALUES 
('Pneu Dianteiro'),
('Correia de Transmissão'),
('Filtro de Óleo');

-- Inserir tamanhos
INSERT INTO tamanhos_pecas (descricao) VALUES 
('14.9-28'),
('20x1900mm'),
('Spin-On 320');

-- Inserir peças
INSERT INTO pecas (modelo_id, tamanho_id, quantidade) VALUES 
(1, 1, 10),  -- Pneu Dianteiro 14.9-28
(2, 2, 5),   -- Correia 20x1900mm
(3, 3, 8);   -- Filtro Spin-On 320

-- Relacionar peças com máquinas compatíveis
INSERT INTO pecas_maquinas (peca_id, maquina_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(3, 3);
INSERT INTO maquinas (nome) VALUES  ('Trator John Deere'), ('Colheitadeira Massey'), ('Pulverizador Montana')
