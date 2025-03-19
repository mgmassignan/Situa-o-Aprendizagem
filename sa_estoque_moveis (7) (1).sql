-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/03/2025 às 21:14
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `sa_estoque_moveis`
--
CREATE DATABASE IF NOT EXISTS `sa_estoque_moveis` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `sa_estoque_moveis`;

DELIMITER $$
--
-- Procedimentos
--
DROP PROCEDURE IF EXISTS `AdicionarFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdicionarFuncionario` (IN `p_id_funcionario` INT, IN `p_nome` VARCHAR(45), IN `p_cpf` VARCHAR(18), IN `p_telefone` VARCHAR(15), IN `p_email` VARCHAR(45), IN `p_cargo` VARCHAR(50), IN `p_salario` DECIMAL(10,2), IN `p_data_contratacao` DATE)   BEGIN
    INSERT INTO funcionario (
        id_funcionario, 
        nome, 
        cpf, 
        telefone, 
        email, 
        cargo, 
        salario, 
        data_contratacao
    ) VALUES (
        p_id_funcionario, 
        p_nome, 
        p_cpf, 
        p_telefone, 
        p_email, 
        p_cargo, 
        p_salario, 
        p_data_contratacao
    );
END$$

DROP PROCEDURE IF EXISTS `AtualizarContatoFornecedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarContatoFornecedor` (IN `p_cnpj` VARCHAR(15), IN `p_novo_telefone` VARCHAR(18), IN `p_novo_email` VARCHAR(45))   BEGIN
    UPDATE fornecedor
    SET telefone = p_novo_telefone, email = p_novo_email
    WHERE cnpj = p_cnpj;
END$$

DROP PROCEDURE IF EXISTS `AtualizarContatoFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarContatoFuncionario` (IN `p_id_funcionario` INT, IN `p_novo_telefone` VARCHAR(15), IN `p_novo_email` VARCHAR(100))   BEGIN
    UPDATE funcionario 
    SET telefone = p_novo_telefone, 
        email = p_novo_email
    WHERE id_funcionario = p_id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `AtualizarDistribuidora`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarDistribuidora` (IN `p_id_distribuidora` INT, IN `p_nome` VARCHAR(255), IN `p_cnpj` VARCHAR(18), IN `p_telefone` VARCHAR(20), IN `p_email` VARCHAR(255), IN `p_endereco` TEXT, IN `p_produto_id` INT)   BEGIN
    DECLARE v_count INT;
    
    -- Verifica se a distribuidora existe
    SELECT COUNT(*) INTO v_count FROM distribuidora WHERE id_distribuidora = p_id_distribuidora;
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Distribuidora não encontrada';
    ELSE
        -- Atualiza os dados da distribuidora
        UPDATE distribuidora
        SET nome = p_nome,
            cnpj = p_cnpj,
            telefone = p_telefone,
            email = p_email,
            endereco = p_endereco,
            produto_id_produto = p_produto_id
        WHERE id_distribuidora = p_id_distribuidora;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `AtualizarEstoqueProduto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarEstoqueProduto` (IN `p_id_produto` INT, IN `p_estoque` INT)   BEGIN
    -- Verifica se o produto existe antes de atualizar
    IF NOT EXISTS (SELECT 1 FROM produto WHERE id_produto = p_id_produto) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não encontrado!';
    END IF;

    -- Verifica se o estoque é negativo
    IF p_estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O estoque não pode ser negativo!';
    END IF;

    -- Atualiza o estoque do produto
    UPDATE produto 
    SET estoque = p_estoque
    WHERE id_produto = p_id_produto;
END$$

DROP PROCEDURE IF EXISTS `AtualizarNomeFornecedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarNomeFornecedor` (IN `p_id_fornecedor` INT, IN `p_novo_nome` VARCHAR(45))   BEGIN
    UPDATE fornecedor
    SET nome = p_novo_nome
    WHERE id_fornecedor = p_id_fornecedor;
END$$

DROP PROCEDURE IF EXISTS `AtualizarPedidoValores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarPedidoValores` (IN `p_id_pedido` INT, IN `p_nova_quantidade` INT, IN `p_novo_preco` DECIMAL(10,2))   BEGIN
    UPDATE pedido
    SET quantidade = p_nova_quantidade,
        preco_unitario = p_novo_preco,
        total = p_nova_quantidade * p_novo_preco
    WHERE id_pedido = p_id_pedido;
END$$

DROP PROCEDURE IF EXISTS `AtualizarProdutoNomeDesc`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarProdutoNomeDesc` (IN `p_id_produto` INT, IN `p_nome` VARCHAR(45), IN `p_descricao` TEXT)   BEGIN
    -- Verifica se o produto existe antes de atualizar
    IF NOT EXISTS (SELECT 1 FROM produto WHERE id_produto = p_id_produto) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não encontrado!';
    END IF;

    -- Atualiza o nome e a descrição do produto
    UPDATE produto 
    SET nome = p_nome, 
        descricao = p_descricao
    WHERE id_produto = p_id_produto;
END$$

DROP PROCEDURE IF EXISTS `AtualizarSalarioFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarSalarioFuncionario` (IN `p_id_funcionario` INT, IN `p_novo_salario` DECIMAL(10,2))   BEGIN
    UPDATE funcionario 
    SET salario = p_novo_salario
    WHERE id_funcionario = p_id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `AtualizarStatusPedido`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarStatusPedido` (IN `p_id_pedido` INT, IN `p_novo_status` VARCHAR(50))   BEGIN
    UPDATE pedido
    SET status = p_novo_status
    WHERE id_pedido = p_id_pedido;
END$$

DROP PROCEDURE IF EXISTS `BuscarClientePorID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarClientePorID` (IN `p_id_cliente` INT)   BEGIN
    SELECT 
        c.id_cliente, 
        c.nome AS nome_cliente, 
        c.cpf, 
        c.telefone, 
        c.email, 
        c.endereco, 
        f.id_funcionario, 
        f.nome AS nome_funcionario
    FROM cliente c
    LEFT JOIN funcionario f ON c.funcionario_id_funcionario = f.id_funcionario
    WHERE c.id_cliente = p_id_cliente;
END$$

DROP PROCEDURE IF EXISTS `BuscarClientesPorFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarClientesPorFuncionario` (IN `p_id_funcionario` INT)   BEGIN
    SELECT 
        c.id_cliente, 
        c.nome AS nome_cliente, 
        c.cpf AS cpf_cliente, 
        c.telefone AS telefone_cliente, 
        c.email AS email_cliente, 
        c.endereco AS endereco_cliente, 
        f.id_funcionario, 
        f.nome AS nome_funcionario, 
        f.cargo AS cargo_funcionario
    FROM cliente c
    JOIN funcionario f ON c.funcionario_id_funcionario = f.id_funcionario
    WHERE f.id_funcionario = p_id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `ConsultarProdutosComCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConsultarProdutosComCliente` ()   BEGIN
    SELECT 
        p.id_produto, 
        p.nome AS nome_produto, 
        p.descricao, 
        p.estoque, 
        c.id_cliente, 
        c.nome AS nome_cliente
    FROM produto p
    JOIN cliente c ON p.cliente_id_cliente = c.id_cliente;
END$$

DROP PROCEDURE IF EXISTS `ConsultarProdutosComFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConsultarProdutosComFuncionario` ()   BEGIN
    SELECT 
        p.id_produto, 
        p.nome AS nome_produto, 
        p.descricao, 
        p.estoque, 
        f.id_funcionario, 
        f.nome AS nome_funcionario
    FROM produto p
    JOIN funcionario f ON p.funcionario_id_funcionario = f.id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `InserirCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirCliente` (IN `p_nome` VARCHAR(45), IN `p_cpf` VARCHAR(18), IN `p_telefone` VARCHAR(15), IN `p_email` VARCHAR(45), IN `p_endereco` VARCHAR(60), IN `p_funcionario_id` INT(11))   BEGIN
    DECLARE v_count INT;
    
    -- Verifica se já existe um cliente com o mesmo CPF
    SELECT COUNT(*) INTO v_count FROM cliente WHERE cpf = p_cpf;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: CPF já cadastrado';
    ELSE
        INSERT INTO cliente (nome, cpf, telefone, email, endereco, funcionario_id_funcionario)
        VALUES (p_nome, p_cpf, p_telefone, p_email, p_endereco, p_funcionario_id);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `InserirDistribuidora`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirDistribuidora` (IN `p_nome` VARCHAR(255), IN `p_cnpj` VARCHAR(18), IN `p_telefone` VARCHAR(20), IN `p_email` VARCHAR(255), IN `p_endereco` TEXT, IN `p_produto_id` INT)   BEGIN
    INSERT INTO distribuidora (nome, cnpj, telefone, email, endereco, produto_id_produto)
    VALUES (p_nome, p_cnpj, p_telefone, p_email, p_endereco, p_produto_id);
END$$

DROP PROCEDURE IF EXISTS `InserirFornecedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirFornecedor` (IN `f_id_fornecedor` INT, IN `f_nome` VARCHAR(45), IN `f_cnpj` VARCHAR(15), IN `f_telefone` VARCHAR(18), IN `f_email` VARCHAR(45))   BEGIN
    INSERT INTO fornecedor (fornecedor.id_fornecedor, fornecedor.nome, fornecedor.cnpj, fornecedor.telefone, fornecedor.email)
    VALUES (f_nome, f_cnpj, f_telefone, f_email);
END$$

DROP PROCEDURE IF EXISTS `InserirFornecedorNovo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirFornecedorNovo` (IN `f_nome` VARCHAR(45), IN `f_cnpj` VARCHAR(15), IN `f_telefone` VARCHAR(18), IN `f_email` VARCHAR(45))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM fornecedor WHERE cnpj = f_cnpj) THEN
        INSERT INTO fornecedor (nome, cnpj, telefone, email)
        VALUES (f_nome, f_cnpj, f_telefone, f_email);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fornecedor com esse CNPJ já existe.';
    END IF;
END$$

DROP PROCEDURE IF EXISTS `InserirFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirFuncionario` (IN `p_id_funcionario` INT, IN `p_nome` VARCHAR(45), IN `p_cpf` VARCHAR(18), IN `p_telefone` VARCHAR(15), IN `p_email` VARCHAR(45), IN `p_cargo` VARCHAR(50), IN `p_salario` DECIMAL(10,2), IN `p_data_contratacao` DATE)   BEGIN
    INSERT INTO funcionario (
        id_funcionario, 
        nome, 
        cpf, 
        telefone, 
        email, 
        cargo, 
        salario, 
        data_contratacao
    ) VALUES (
        p_id_funcionario, 
        p_nome, 
        p_cpf, 
        p_telefone, 
        p_email, 
        p_cargo, 
        p_salario, 
        p_data_contratacao
    );
END$$

DROP PROCEDURE IF EXISTS `InserirPedidoComCalculo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirPedidoComCalculo` (IN `p_data_pedido` DATE, IN `p_status` VARCHAR(20), IN `p_cliente_id` INT, IN `p_produto_id` INT, IN `p_quantidade` INT, IN `p_preco_unitario` DECIMAL(10,2))   BEGIN
    DECLARE v_total DECIMAL(10,2);

    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_cliente_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Cliente não encontrado!';
    ELSE
        -- Calcula o total automaticamente
        SET v_total = p_quantidade * p_preco_unitario;

        -- Insere o pedido
        INSERT INTO pedido (data_pedido, status, total, cliente_id, produto_id, quantidade, preco_unitario)
        VALUES (p_data_pedido, p_status, v_total, p_cliente_id, p_produto_id, p_quantidade, p_preco_unitario);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `InserirPedidoComData`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirPedidoComData` (IN `p_cliente_id` INT, IN `p_produto_id` INT, IN `p_quantidade` INT, IN `p_preco_unitario` DECIMAL(10,2), IN `p_data_pedido` DATE)   BEGIN
    INSERT INTO pedido (cliente_id, produto_id, quantidade, preco_unitario, total, data_pedido)
    VALUES (p_cliente_id, p_produto_id, p_quantidade, p_preco_unitario, p_quantidade * p_preco_unitario, p_data_pedido);
END$$

DROP PROCEDURE IF EXISTS `InserirProduto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirProduto` (IN `p_nome` VARCHAR(45), IN `p_descricao` TEXT, IN `p_estoque` INT, IN `p_funcionario_id` INT, IN `p_cliente_id` INT)   BEGIN
    INSERT INTO produto (nome, descricao, estoque, funcionario_id_funcionario, cliente_id_cliente)
    VALUES (p_nome, p_descricao, p_estoque, p_funcionario_id, p_cliente_id);
END$$

DROP PROCEDURE IF EXISTS `InserirProdutoV3`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InserirProdutoV3` (IN `p_nome` VARCHAR(45), IN `p_descricao` TEXT, IN `p_estoque` INT, IN `p_funcionario_id` INT, IN `p_cliente_id` INT)   BEGIN
    -- Verifica se o nome do produto está vazio
    IF p_nome IS NULL OR p_nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O nome do produto não pode ser nulo ou vazio!';
    END IF;

    -- Verifica se o estoque é um valor negativo
    IF p_estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O estoque não pode ser negativo!';
    END IF;

    -- Verifica se o funcionário e o cliente possuem valores válidos
    IF p_funcionario_id IS NULL OR p_cliente_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O funcionário e o cliente devem ser informados!';
    END IF;

    -- Insere os dados na tabela caso todas as verificações sejam passadas
    INSERT INTO produto (nome, descricao, estoque, funcionario_id_funcionario, cliente_id_cliente)
    VALUES (p_nome, p_descricao, p_estoque, p_funcionario_id, p_cliente_id);
END$$

DROP PROCEDURE IF EXISTS `InsertClienteVerificaEmail`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertClienteVerificaEmail` (IN `p_nome` VARCHAR(45), IN `p_cpf` VARCHAR(18), IN `p_telefone` VARCHAR(15), IN `p_email` VARCHAR(45), IN `p_endereco` VARCHAR(60), IN `p_funcionario_id` INT)   BEGIN
    -- Verifica se o e-mail já está cadastrado
    IF EXISTS (SELECT 1 FROM cliente WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Este e-mail já está cadastrado!';
    ELSE
        -- Insere o novo cliente
        INSERT INTO cliente (nome, cpf, telefone, email, endereco, funcionario_id_funcionario)
        VALUES (p_nome, p_cpf, p_telefone, p_email, p_endereco, p_funcionario_id);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `InsertDistribuidoraVerificaCnpj`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertDistribuidoraVerificaCnpj` (IN `p_nome` VARCHAR(255), IN `p_cnpj` VARCHAR(18), IN `p_telefone` VARCHAR(20), IN `p_email` VARCHAR(255), IN `p_endereco` TEXT, IN `p_produto_id` INT)   BEGIN
    DECLARE v_count INT;
    
    -- Verifica se já existe uma distribuidora com o mesmo CNPJ
    SELECT COUNT(*) INTO v_count FROM distribuidora WHERE cnpj = p_cnpj;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: CNPJ já cadastrado';
    ELSE
        INSERT INTO distribuidora (nome, cnpj, telefone, email, endereco, produto_id_produto)
        VALUES (p_nome, p_cnpj, p_telefone, p_email, p_endereco, p_produto_id);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `JuntaDistribuidorasEstoqueBaixo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `JuntaDistribuidorasEstoqueBaixo` ()   BEGIN
    SELECT d.id_distribuidora, d.nome AS distribuidora, p.nome AS produto, p.estoque
    FROM distribuidora d
    INNER JOIN produto p ON p.id_distribuidora = d.id_distribuidora
    WHERE p.estoque < 10;
END$$

DROP PROCEDURE IF EXISTS `JuntaProdutosDistribuidoras`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `JuntaProdutosDistribuidoras` ()   BEGIN
    SELECT p.id_produto, p.nome AS produto, d.nome AS distribuidora
    FROM produto p
    INNER JOIN distribuidora d ON p.id_distribuidora = d.id_distribuidora;
END$$

DROP PROCEDURE IF EXISTS `ListarClientesComFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarClientesComFuncionario` ()   BEGIN
    SELECT 
        c.id_cliente, 
        c.nome AS nome_cliente, 
        c.cpf, 
        c.telefone, 
        c.email, 
        c.endereco, 
        f.id_funcionario, 
        f.nome AS nome_funcionario
    FROM cliente c
    LEFT JOIN funcionario f ON c.funcionario_id_funcionario = f.id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `ListarClientesComFuncionarios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarClientesComFuncionarios` ()   BEGIN
    SELECT 
        c.id_cliente, 
        c.nome AS nome_cliente, 
        c.cpf AS cpf_cliente, 
        c.telefone AS telefone_cliente, 
        c.email AS email_cliente, 
        c.endereco AS endereco_cliente, 
        f.id_funcionario, 
        f.nome AS nome_funcionario, 
        f.cargo AS cargo_funcionario
    FROM cliente c
    JOIN funcionario f ON c.funcionario_id_funcionario = f.id_funcionario;
END$$

DROP PROCEDURE IF EXISTS `ListarPedidosClientes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarPedidosClientes` ()   BEGIN
    SELECT p.id_pedido, p.data_pedido, p.status, p.total, 
           c.id_cliente AS cliente_id, c.nome AS nome_cliente
    FROM pedido p
    JOIN cliente c ON p.cliente_id = c.id_cliente;
END$$

DROP PROCEDURE IF EXISTS `ListarPedidosProdutos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListarPedidosProdutos` ()   BEGIN
    SELECT p.id_pedido, p.data_pedido, p.status, 
           pr.id_produto, pr.nome AS nome_produto,
           p.quantidade, p.preco_unitario, p.total
    FROM pedido p
    JOIN produto pr ON p.produto_id = pr.id_produto;
END$$

DROP PROCEDURE IF EXISTS `SP_ConsultaProdutosComCliente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ConsultaProdutosComCliente` (IN `p_cliente_id` INT)   BEGIN SELECT p.id_produto, p.nome, p.descricao, p.estoque, c.nome AS nome_cliente FROM produto p JOIN cliente c ON p.cliente_id_clientes = c.id_cliente WHERE p.cliente_id_clientes = p_cliente_id;
END$$

DROP PROCEDURE IF EXISTS `SP_ConsultaProdutosComFuncionario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ConsultaProdutosComFuncionario` ()   BEGIN SELECT p.id_produto, p.nome, p.descricao, p.estoque, f.nome AS nome_funcionario FROM produto p JOIN funcionario f ON p.funcionario_id_funcionario = f.id_funcionario;

END$$

DROP PROCEDURE IF EXISTS `UpdateClienteCompleto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateClienteCompleto` (IN `p_id_cliente` INT, IN `p_nome` VARCHAR(45), IN `p_cpf` VARCHAR(18), IN `p_telefone` VARCHAR(15), IN `p_email` VARCHAR(45), IN `p_endereco` VARCHAR(60), IN `p_funcionario_id` INT)   BEGIN
    -- Verifica se o novo e-mail já pertence a outro cliente
    IF EXISTS (SELECT 1 FROM cliente WHERE email = p_email AND id_cliente <> p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Este e-mail já está cadastrado para outro cliente!';
    ELSE
        -- Atualiza os dados do cliente
        UPDATE cliente 
        SET nome = p_nome,
            cpf = p_cpf,
            telefone = p_telefone,
            email = p_email,
            endereco = p_endereco,
            funcionario_id_funcionario = p_funcionario_id
        WHERE id_cliente = p_id_cliente;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `UpdateClienteContato`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateClienteContato` (IN `p_id_cliente` INT, IN `p_telefone` VARCHAR(15), IN `p_endereco` VARCHAR(60))   BEGIN
    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Cliente não encontrado!';
    ELSE
        -- Atualiza telefone e endereço do cliente
        UPDATE cliente 
        SET telefone = p_telefone,
            endereco = p_endereco
        WHERE id_cliente = p_id_cliente;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `UpdateDistribuidoraNome`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDistribuidoraNome` (IN `p_id_distribuidora` INT, IN `p_novo_nome` VARCHAR(100))   BEGIN
    UPDATE distribuidora
    SET nome = p_novo_nome
    WHERE id_distribuidora = p_id_distribuidora;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `cpf` varchar(18) NOT NULL,
  `telefone` varchar(15) NOT NULL,
  `email` varchar(45) NOT NULL,
  `endereco` varchar(60) NOT NULL,
  `funcionario_id_funcionario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`id_cliente`, `nome`, `cpf`, `telefone`, `email`, `endereco`, `funcionario_id_funcionario`) VALUES
(1, 'João Silva', '123.456.789-00', '(47) 98765-4321', 'joao.silva@email.com', 'Rua A, 123, Joinville', 1),
(2, 'Maria Souza', '234.567.890-11', '(47) 98765-4322', 'maria.souza@email.com', 'Rua B, 456, Joinville', 2),
(3, 'Pedro Oliveira', '345.678.901-22', '(47) 98765-4323', 'pedro.oliveira@email.com', 'Rua C, 789, Joinville', 3),
(4, 'Ana Costa', '456.789.012-33', '(47) 98765-4324', 'ana.costa@email.com', 'Rua D, 101, Joinville', 4),
(5, 'Carlos Pereira', '567.890.123-44', '(47) 98765-4325', 'carlos.pereira@email.com', 'Rua E, 202, Joinville', 5),
(6, 'Patrícia Lima', '678.901.234-55', '(47) 98765-4326', 'patricia.lima@email.com', 'Rua F, 303, Joinville', 6),
(7, 'Lucas Rocha', '789.012.345-66', '(47) 98765-4327', 'lucas.rocha@email.com', 'Rua G, 404, Joinville', 7),
(8, 'Juliana Martins', '890.123.456-77', '(47) 98765-4328', 'juliana.martins@email.com', 'Rua H, 505, Joinville', 8),
(9, 'Gabriel Santos', '901.234.567-88', '(47) 98765-4329', 'gabriel.santos@email.com', 'Rua I, 606, Joinville', 9),
(10, 'Larissa Alves', '012.345.678-99', '(47) 98765-4330', 'larissa.alves@email.com', 'Rua J, 707, Joinville', 10),
(11, 'Felipe Costa', '123.456.789-01', '(47) 98765-4331', 'felipe.costa@email.com', 'Rua K, 808, Joinville', 1),
(12, 'Beatriz Silva', '234.567.890-12', '(47) 98765-4332', 'beatriz.silva@email.com', 'Rua L, 909, Joinville', 2),
(13, 'Ricardo Pereira', '345.678.901-23', '(47) 98765-4333', 'ricardo.pereira@email.com', 'Rua M, 1001, Joinville', 3),
(14, 'Jéssica Oliveira', '456.789.012-34', '(47) 98765-4334', 'jessica.oliveira@email.com', 'Rua N, 1102, Joinville', 4),
(15, 'Rodrigo Martins', '567.890.123-45', '(47) 98765-4335', 'rodrigo.martins@email.com', 'Rua O, 1203, Joinville', 5),
(16, 'Renata Rocha', '678.901.234-56', '(47) 98765-4336', 'renata.rocha@email.com', 'Rua P, 1304, Joinville', 6),
(17, 'Fábio Souza', '789.012.345-67', '(47) 98765-4337', 'fabio.souza@email.com', 'Rua Q, 1405, Joinville', 7),
(18, 'Tânia Lima', '890.123.456-78', '(47) 98765-4338', 'tania.lima@email.com', 'Rua R, 1506, Joinville', 8),
(19, 'Maurício Silva', '901.234.567-89', '(47) 98765-4339', 'mauricio.silva@email.com', 'Rua S, 1607, Joinville', 9),
(20, 'Sofia Costa', '012.345.678-10', '(47) 98765-4340', 'sofia.costa@email.com', 'Rua T, 1708, Joinville', 10),
(21, 'André Santos', '123.456.789-11', '(47) 98765-4341', 'andre.santos@email.com', 'Rua U, 1809, Joinville', 1),
(22, 'Eliane Alves', '234.567.890-22', '(47) 98765-4342', 'eliane.alves@email.com', 'Rua V, 1901, Joinville', 2),
(23, 'Cláudio Rocha', '345.678.901-33', '(47) 98765-4343', 'claudio.rocha@email.com', 'Rua W, 2002, Joinville', 3),
(24, 'Cristiane Martins', '456.789.012-44', '(47) 98765-4344', 'cristiane.martins@email.com', 'Rua X, 2103, Joinville', 4),
(25, 'Gustavo Pereira', '567.890.123-55', '(47) 98765-4345', 'gustavo.pereira@email.com', 'Rua Y, 2204, Joinville', 5),
(26, 'Mariana Oliveira', '678.901.234-66', '(47) 98765-4346', 'mariana.oliveira@email.com', 'Rua Z, 2305, Joinville', 6),
(27, 'Ricardo Souza', '789.012.345-77', '(47) 98765-4347', 'ricardo.souza@email.com', 'Rua AA, 2406, Joinville', 7),
(28, 'Verônica Lima', '890.123.456-88', '(47) 98765-4348', 'veronica.lima@email.com', 'Rua BB, 2507, Joinville', 8),
(29, 'Felipe Martins', '901.234.567-99', '(47) 98765-4349', 'felipe.martins@email.com', 'Rua CC, 2608, Joinville', 9),
(30, 'Patricia Santos', '012.345.678-21', '(47) 98765-4350', 'patricia.santos@email.com', 'Rua DD, 2709, Joinville', 10),
(31, 'Rafael Pereira', '123.456.789-32', '(47) 98765-4351', 'rafael.pereira@email.com', 'Rua EE, 2801, Joinville', 1),
(32, 'Marcos Costa', '234.567.890-43', '(47) 98765-4352', 'marcos.costa@email.com', 'Rua FF, 2902, Joinville', 2),
(33, 'Lucas Silva', '345.678.901-54', '(47) 98765-4353', 'lucas.silva@email.com', 'Rua GG, 3003, Joinville', 3),
(34, 'Adriana Lima', '456.789.012-65', '(47) 98765-4354', 'adriana.lima@email.com', 'Rua HH, 3104, Joinville', 4),
(35, 'Fernando Oliveira', '567.890.123-76', '(47) 98765-4355', 'fernando.oliveira@email.com', 'Rua II, 3205, Joinville', 5),
(36, 'Roberta Rocha', '678.901.234-87', '(47) 98765-4356', 'roberta.rocha@email.com', 'Rua JJ, 3306, Joinville', 6),
(37, 'Mariana Souza', '789.012.345-98', '(47) 98765-4357', 'mariana.souza@email.com', 'Rua KK, 3407, Joinville', 7),
(38, 'Giovanni Costa', '890.123.456-09', '(47) 98765-4358', 'giovanni.costa@email.com', 'Rua LL, 3508, Joinville', 8),
(39, 'Viviane Santos', '901.234.567-10', '(47) 98765-4359', 'viviane.santos@email.com', 'Rua MM, 3609, Joinville', 9),
(40, 'Caio Martins', '012.345.678-31', '(47) 98765-4360', 'caio.martins@email.com', 'Rua NN, 3710, Joinville', 10),
(41, 'Ana Paula Rocha', '123.456.789-42', '(47) 98765-4361', 'ana.paula.rocha@email.com', 'Rua OO, 3811, Joinville', 1),
(42, 'Eduardo Pereira', '234.567.890-53', '(47) 98765-4362', 'eduardo.pereira@email.com', 'Rua PP, 3912, Joinville', 2),
(43, 'Rita Costa', '345.678.901-64', '(47) 98765-4363', 'rita.costa@email.com', 'Rua QQ, 4013, Joinville', 3),
(44, 'Felipe Lima', '456.789.012-75', '(47) 98765-4364', 'felipe.lima@email.com', 'Rua RR, 4114, Joinville', 4),
(45, 'Simone Santos', '567.890.123-86', '(47) 98765-4365', 'simone.santos@email.com', 'Rua SS, 4215, Joinville', 5),
(46, 'Joana Silva', '678.901.234-97', '(47) 98765-4366', 'joana.silva@email.com', 'Rua TT, 4316, Joinville', 6),
(47, 'Guilherme Rocha', '789.012.345-08', '(47) 98765-4367', 'guilherme.rocha@email.com', 'Rua UU, 4417, Joinville', 7),
(48, 'Eliane Martins', '890.123.456-19', '(47) 98765-4368', 'eliane.martins@email.com', 'Rua VV, 4518, Joinville', 8),
(49, 'Arthur Souza', '901.234.567-20', '(47) 98765-4369', 'arthur.souza@email.com', 'Rua WW, 4619, Joinville', 9),
(50, 'Carolina Pereira', '012.345.678-41', '(47) 98765-4370', 'carolina.pereira@email.com', 'Rua XX, 4720, Joinville', 10),
(51, 'Samuel Lima', '123.456.789-52', '(47) 98765-4371', 'samuel.lima@email.com', 'Rua YY, 4821, Joinville', 1),
(52, 'Cláudia Rocha', '234.567.890-63', '(47) 98765-4372', 'claudia.rocha@email.com', 'Rua ZZ, 4922, Joinville', 2),
(53, 'Renato Oliveira', '345.678.901-74', '(47) 98765-4373', 'renato.oliveira@email.com', 'Rua AAA, 5023, Joinville', 3),
(54, 'Sérgio Santos', '456.789.012-85', '(47) 98765-4374', 'sergio.santos@email.com', 'Rua BBB, 5124, Joinville', 4),
(55, 'Marta Martins', '567.890.123-96', '(47) 98765-4375', 'marta.martins@email.com', 'Rua CCC, 5225, Joinville', 5),
(56, 'Carlos Rocha', '678.901.234-07', '(47) 98765-4376', 'carlos.rocha@email.com', 'Rua DDD, 5326, Joinville', 6),
(57, 'Vanessa Souza', '789.012.345-18', '(47) 98765-4377', 'vanessa.souza@email.com', 'Rua EEE, 5427, Joinville', 7),
(58, 'Renato Costa', '890.123.456-29', '(47) 98765-4378', 'renato.costa@email.com', 'Rua FFF, 5528, Joinville', 8),
(59, 'Sandra Pereira', '901.234.567-30', '(47) 98765-4379', 'sandra.pereira@email.com', 'Rua GGG, 5629, Joinville', 9),
(60, 'Eduardo Rocha', '012.345.678-51', '(47) 98765-4380', 'eduardo.rocha@email.com', 'Rua HHH, 5730, Joinville', 10),
(61, 'Beatriz Lima', '123.456.789-62', '(47) 98765-4381', 'beatriz.lima@email.com', 'Rua III, 5831, Joinville', 1),
(62, 'Gilberto Souza', '234.567.890-73', '(47) 98765-4382', 'gilberto.souza@email.com', 'Rua JJJ, 5932, Joinville', 2),
(63, 'Vivian Costa', '345.678.901-84', '(47) 98765-4383', 'vivian.costa@email.com', 'Rua KKK, 6033, Joinville', 3),
(64, 'João Martins', '456.789.012-95', '(47) 98765-4384', 'joao.martins@email.com', 'Rua LLL, 6134, Joinville', 4),
(65, 'Laura Pereira', '567.890.123-06', '(47) 98765-4385', 'laura.pereira@email.com', 'Rua MMM, 6235, Joinville', 5),
(66, 'Tânia Souza', '678.901.234-17', '(47) 98765-4386', 'tania.souza@email.com', 'Rua NNN, 6336, Joinville', 6),
(67, 'Alex Rocha', '789.012.345-28', '(47) 98765-4387', 'alex.rocha@email.com', 'Rua OOO, 6437, Joinville', 7),
(68, 'Glória Lima', '890.123.456-39', '(47) 98765-4388', 'gloria.lima@email.com', 'Rua PPP, 6538, Joinville', 8),
(69, 'Vinícius Costa', '901.234.567-40', '(47) 98765-4389', 'vinicius.costa@email.com', 'Rua QQQ, 6639, Joinville', 9),
(70, 'Sérgio Pereira', '012.345.678-51', '(47) 98765-4390', 'sergio.pereira@email.com', 'Rua RRR, 6740, Joinville', 10);

-- --------------------------------------------------------

--
-- Estrutura para tabela `distribuidora`
--

DROP TABLE IF EXISTS `distribuidora`;
CREATE TABLE `distribuidora` (
  `id_distribuidora` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `cnpj` varchar(18) NOT NULL,
  `telefone` varchar(15) NOT NULL,
  `email` varchar(45) NOT NULL,
  `endereco` varchar(60) NOT NULL,
  `produto_id_produto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `distribuidora`
--

INSERT INTO `distribuidora` (`id_distribuidora`, `nome`, `cnpj`, `telefone`, `email`, `endereco`, `produto_id_produto`) VALUES
(1, 'Global Distributors Ltda', '12.345.678/0001-01', '(47) 98888-2001', 'global@distribuidora.com', 'Rua das Indústrias, 101, Joinville - SC', 1),
(2, 'Distribuidora Silva & Cia', '23.456.789/0001-02', '(47) 98888-2002', 'silva@distribuidora.com', 'Avenida Central, 204, Joinville - SC', 2),
(3, 'Prime Distributors', '34.567.890/0001-03', '(47) 98888-2003', 'prime@distribuidora.com', 'Rua Marinho, 305, Joinville - SC', 3),
(4, 'Tech Supplies', '45.678.901/0001-04', '(47) 98888-2004', 'techsupplies@distribuidora.com', 'Rua Silveira, 407, Joinville - SC', 4),
(5, 'Distribuidora Mundo Novo', '56.789.012/0001-05', '(47) 98888-2005', 'mundonovo@distribuidora.com', 'Rua da Paz, 512, Joinville - SC', 5),
(6, 'Lux Supply Co.', '67.890.123/0001-06', '(47) 98888-2006', 'lux@distribuidora.com', 'Avenida Dom Pedro, 617, Joinville - SC', 6),
(7, 'Vega Distribution', '78.901.234/0001-07', '(47) 98888-2007', 'vega@distribuidora.com', 'Rua 25 de Julho, 710, Joinville - SC', 7),
(8, 'Distech Global', '89.012.345/0001-08', '(47) 98888-2008', 'distech@distribuidora.com', 'Avenida Brasil, 815, Joinville - SC', 8),
(9, 'Royal Distributors', '90.123.456/0001-09', '(47) 98888-2009', 'royal@distribuidora.com', 'Rua do Comércio, 920, Joinville - SC', 9),
(10, 'Speed Distribution', '01.234.567/0001-10', '(47) 98888-2010', 'speed@distribuidora.com', 'Rua Getúlio Vargas, 102, Joinville - SC', 10),
(11, 'Distribuidora Costa & Silva', '12.345.678/0001-11', '(47) 98888-2011', 'costa@distribuidora.com', 'Avenida Beira Mar, 220, Joinville - SC', 11),
(12, 'GlobalTech Supplies', '23.456.789/0001-12', '(47) 98888-2012', 'globaltech@distribuidora.com', 'Rua São José, 331, Joinville - SC', 12),
(13, 'Eagle Distribution', '34.567.890/0001-13', '(47) 98888-2013', 'eagle@distribuidora.com', 'Rua Rio de Janeiro, 442, Joinville - SC', 13),
(14, 'Central Distributors', '45.678.901/0001-14', '(47) 98888-2014', 'central@distribuidora.com', 'Rua do Sol, 553, Joinville - SC', 14),
(15, 'Sunshine Distribution', '56.789.012/0001-15', '(47) 98888-2015', 'sunshine@distribuidora.com', 'Avenida Central, 664, Joinville - SC', 15),
(16, 'Alfa Distribuições', '67.890.123/0001-16', '(47) 98888-2016', 'alfa@distribuidora.com', 'Rua da Liberdade, 775, Joinville - SC', 16),
(17, 'Nova Era Distribution', '78.901.234/0001-17', '(47) 98888-2017', 'novaera@distribuidora.com', 'Rua da Vitória, 886, Joinville - SC', 17),
(18, 'Mercado Global', '89.012.345/0001-18', '(47) 98888-2018', 'mercadoglobal@distribuidora.com', 'Rua da Esperança, 997, Joinville - SC', 18),
(19, 'Skyline Distributors', '90.123.456/0001-19', '(47) 98888-2019', 'skyline@distribuidora.com', 'Avenida do Comércio, 1108, Joinville - SC', 19),
(20, 'Top Distributors', '01.234.567/0001-20', '(47) 98888-2020', 'top@distribuidora.com', 'Rua das Palmeiras, 1210, Joinville - SC', 20),
(21, 'Comercial Progresso', '12.345.678/0001-21', '(47) 98888-2021', 'progresso@distribuidora.com', 'Avenida das Águas, 1321, Joinville - SC', 21),
(22, 'Star Distribution Ltd.', '23.456.789/0001-22', '(47) 98888-2022', 'star@distribuidora.com', 'Rua dos Lírios, 1422, Joinville - SC', 22),
(23, 'Distribuidora Nacional', '34.567.890/0001-23', '(47) 98888-2023', 'nacional@distribuidora.com', 'Rua dos Três Pinheiros, 1523, Joinville - SC', 23),
(24, 'Distribuidora Express', '45.678.901/0001-24', '(47) 98888-2024', 'express@distribuidora.com', 'Avenida do Rio, 1624, Joinville - SC', 24),
(25, 'TechnoDistrib', '56.789.012/0001-25', '(47) 98888-2025', 'techno@distribuidora.com', 'Rua São Paulo, 1725, Joinville - SC', 25),
(26, 'Distribuidora Continent', '67.890.123/0001-26', '(47) 98888-2026', 'continent@distribuidora.com', 'Avenida Vitória, 1826, Joinville - SC', 26),
(27, 'Panamericana Distribuição', '78.901.234/0001-27', '(47) 98888-2027', 'panamericana@distribuidora.com', 'Rua da Esperança, 1927, Joinville - SC', 27),
(28, 'WorldTech Distribution', '89.012.345/0001-28', '(47) 98888-2028', 'worldtech@distribuidora.com', 'Avenida Rio Branco, 2028, Joinville - SC', 28),
(29, 'Distribuidora Solução', '90.123.456/0001-29', '(47) 98888-2029', 'solucao@distribuidora.com', 'Rua das Laranjeiras, 2129, Joinville - SC', 29),
(30, 'Distribuidora Norte Sul', '01.234.567/0001-30', '(47) 98888-2030', 'nortesul@distribuidora.com', 'Avenida dos Pioneiros, 2230, Joinville - SC', 30),
(31, 'Quantum Distribuidores', '12.345.678/0001-31', '(47) 98888-2031', 'quantum@distribuidora.com', 'Rua Santa Catarina, 2331, Joinville - SC', 31),
(32, 'Excellence Distributors', '23.456.789/0001-32', '(47) 98888-2032', 'excellence@distribuidora.com', 'Rua São Francisco, 2432, Joinville - SC', 32),
(33, 'Distribuidora Barros & Filhos', '34.567.890/0001-33', '(47) 98888-2033', 'barros@distribuidora.com', 'Avenida Ponta Grossa, 2533, Joinville - SC', 33),
(34, 'Sunset Distribution', '45.678.901/0001-34', '(47) 98888-2034', 'sunset@distribuidora.com', 'Rua das Flores, 2634, Joinville - SC', 34),
(35, 'Prime Logistics', '56.789.012/0001-35', '(47) 98888-2035', 'primelogistics@distribuidora.com', 'Avenida do Porto, 2735, Joinville - SC', 35),
(36, 'Distribuidora Exata', '67.890.123/0001-36', '(47) 98888-2036', 'exata@distribuidora.com', 'Rua Amazonas, 2836, Joinville - SC', 36),
(37, 'FutureTech Distribuição', '78.901.234/0001-37', '(47) 98888-2037', 'futuretech@distribuidora.com', 'Rua Vitória, 2937, Joinville - SC', 37),
(38, 'Infinity Distributors', '89.012.345/0001-38', '(47) 98888-2038', 'infinity@distribuidora.com', 'Avenida do Sol, 3038, Joinville - SC', 38),
(39, 'Distribuidora Liderança', '90.123.456/0001-39', '(47) 98888-2039', 'lideranca@distribuidora.com', 'Rua São João, 3139, Joinville - SC', 39),
(40, 'Vanguard Distribution', '01.234.567/0001-40', '(47) 98888-2040', 'vanguard@distribuidora.com', 'Rua dos Pássaros, 3240, Joinville - SC', 40),
(41, 'Max Distributors', '12.345.678/0001-41', '(47) 98888-2041', 'max@distribuidora.com', 'Avenida das Nações, 3341, Joinville - SC', 41),
(42, 'Distribuidora Valor', '23.456.789/0001-42', '(47) 98888-2042', 'valor@distribuidora.com', 'Rua do Mercado, 3442, Joinville - SC', 42),
(43, 'Gold Supply Co.', '34.567.890/0001-43', '(47) 98888-2043', 'gold@distribuidora.com', 'Rua dos Andrades, 3543, Joinville - SC', 43),
(44, 'MegaDistribuidora', '45.678.901/0001-44', '(47) 98888-2044', 'megadistribuidora@distribuidora.com', 'Avenida Fortaleza, 3644, Joinville - SC', 44),
(45, 'Super Supply', '56.789.012/0001-45', '(47) 98888-2045', 'supersupply@distribuidora.com', 'Rua da Alegria, 3745, Joinville - SC', 45),
(46, 'Mundo Digital Distribuição', '67.890.123/0001-46', '(47) 98888-2046', 'mundodigital@distribuidora.com', 'Rua São Bento, 3846, Joinville - SC', 46),
(47, 'Distribuidora Nova Geração', '78.901.234/0001-47', '(47) 98888-2047', 'novageracao@distribuidora.com', 'Rua do Porto, 3947, Joinville - SC', 47),
(48, 'Distribuidora Central de Vendas', '89.012.345/0001-48', '(47) 98888-2048', 'centralvendas@distribuidora.com', 'Avenida Minas Gerais, 4048, Joinville - SC', 48),
(49, 'TechZone Distributors', '90.123.456/0001-49', '(47) 98888-2049', 'techzone@distribuidora.com', 'Rua dos Jardins, 4149, Joinville - SC', 49),
(50, 'Distribuidora Mundial', '01.234.567/0001-50', '(47) 98888-2050', 'mundial@distribuidora.com', 'Rua do Comercio, 4250, Joinville - SC', 50),
(51, 'Universal Distribution', '12.345.678/0001-51', '(47) 98888-2051', 'universal@distribuidora.com', 'Rua dos Anjos, 4351, Joinville - SC', 51),
(52, 'Power Distribution', '23.456.789/0001-52', '(47) 98888-2052', 'power@distribuidora.com', 'Avenida Conquista, 4452, Joinville - SC', 52),
(53, 'Supernova Distributors', '34.567.890/0001-53', '(47) 98888-2053', 'supernova@distribuidora.com', 'Rua Santa Maria, 4553, Joinville - SC', 53),
(54, 'Optima Distribution', '45.678.901/0001-54', '(47) 98888-2054', 'optima@distribuidora.com', 'Rua do Sol, 4654, Joinville - SC', 54),
(55, 'Distribuidora Fortaleza', '56.789.012/0001-55', '(47) 98888-2055', 'fortaleza@distribuidora.com', 'Rua Rio Grande, 4755, Joinville - SC', 55),
(56, 'Sky Distribuições', '67.890.123/0001-56', '(47) 98888-2056', 'sky@distribuidora.com', 'Avenida Marinha, 4856, Joinville - SC', 56),
(57, 'Alpha Distributors', '78.901.234/0001-57', '(47) 98888-2057', 'alpha@distribuidora.com', 'Rua dos Pirineus, 4957, Joinville - SC', 57),
(58, 'Allied Distributors', '89.012.345/0001-58', '(47) 98888-2058', 'allied@distribuidora.com', 'Avenida dos Trópicos, 5058, Joinville - SC', 58),
(59, 'Distribuidora Future', '90.123.456/0001-59', '(47) 98888-2059', 'future@distribuidora.com', 'Rua do Horizonte, 5159, Joinville - SC', 59),
(60, 'Distribuidora Fronteira', '01.234.567/0001-60', '(47) 98888-2060', 'fronteira@distribuidora.com', 'Rua Libertação, 5260, Joinville - SC', 60),
(61, 'Distribuidora Brava', '12.345.678/0001-61', '(47) 98888-2061', 'brava@distribuidora.com', 'Rua São Miguel, 5361, Joinville - SC', 61),
(62, 'Distribuidora Crystal', '23.456.789/0001-62', '(47) 98888-2062', 'crystal@distribuidora.com', 'Avenida Renascença, 5462, Joinville - SC', 62),
(63, 'Distribuidora Brisa', '34.567.890/0001-63', '(47) 98888-2063', 'brisa@distribuidora.com', 'Rua Amazonas, 5563, Joinville - SC', 63),
(64, 'Distribuidora Horizonte', '45.678.901/0001-64', '(47) 98888-2064', 'horizonte@distribuidora.com', 'Avenida do Sol, 5664, Joinville - SC', 64),
(65, 'Nexus Distribution', '56.789.012/0001-65', '(47) 98888-2065', 'nexus@distribuidora.com', 'Rua Navegantes, 5765, Joinville - SC', 65),
(66, 'Distribuidora Forte', '67.890.123/0001-66', '(47) 98888-2066', 'forte@distribuidora.com', 'Rua do Sol, 5866, Joinville - SC', 66),
(67, 'Distribuidora Galaxy', '78.901.234/0001-67', '(47) 98888-2067', 'galaxy@distribuidora.com', 'Avenida Centro, 5967, Joinville - SC', 67),
(68, 'Smart Distribution', '89.012.345/0001-68', '(47) 98888-2068', 'smart@distribuidora.com', 'Rua Nova Esperança, 6068, Joinville - SC', 68),
(69, 'Distribuidora PowerTech', '90.123.456/0001-69', '(47) 98888-2069', 'powertech@distribuidora.com', 'Rua Cristal, 6169, Joinville - SC', 69),
(70, 'Distribuidora Speed', '01.234.567/0001-70', '(47) 98888-2070', 'speed@distribuidora.com', 'Avenida Rio Branco, 6270, Joinville - SC', 70),
(71, 'Distribuidora MaxPower', '12.345.678/0001-71', '(47) 98888-2071', 'maxpower@distribuidora.com', 'Rua Morumbi, 6371, Joinville - SC', 71),
(72, 'Distribuidora Infinit', '23.456.789/0001-72', '(47) 98888-2072', 'infinit@distribuidora.com', 'Avenida Pioneiros, 6472, Joinville - SC', 72),
(73, 'Global Network Distributors', '34.567.890/0001-73', '(47) 98888-2073', 'globalnetwork@distribuidora.com', 'Rua das Laranjeiras, 6573, Joinville - SC', 73),
(74, 'Distribuidora AlphaTech', '45.678.901/0001-74', '(47) 98888-2074', 'alphatech@distribuidora.com', 'Avenida do Sol, 6674, Joinville - SC', 74),
(75, 'FutureTech Distribuidores', '56.789.012/0001-75', '(47) 98888-2075', 'futuretech@distribuidora.com', 'Rua da Liberdade, 6775, Joinville - SC', 75),
(76, 'Distribuidora Simples', '67.890.123/0001-76', '(47) 98888-2076', 'simples@distribuidora.com', 'Rua do Comércio, 6876, Joinville - SC', 76),
(77, 'Crystal Distributors', '78.901.234/0001-77', '(47) 98888-2077', 'crystal@distribuidora.com', 'Rua Porto, 6977, Joinville - SC', 77),
(78, 'Distribuidora Horizonte Azul', '89.012.345/0001-78', '(47) 98888-2078', 'horizonteazul@distribuidora.com', 'Rua São Paulo, 7078, Joinville - SC', 78),
(79, 'Distribuidora Elevation', '90.123.456/0001-79', '(47) 98888-2079', 'elevation@distribuidora.com', 'Avenida das Palmeiras, 7179, Joinville - SC', 79),
(80, 'Distribuidora Tradição', '01.234.567/0001-80', '(47) 98888-2080', 'tradicao@distribuidora.com', 'Rua do Ouro, 7280, Joinville - SC', 80),
(81, 'Supernova Distribuições', '12.345.678/0001-81', '(47) 98888-2081', 'supernova@distribuidora.com', 'Avenida Pioneiros, 7381, Joinville - SC', 81),
(82, 'Distribuidora New Age', '23.456.789/0001-82', '(47) 98888-2082', 'newage@distribuidora.com', 'Rua Cristalina, 7482, Joinville - SC', 82),
(83, 'Distribuidora Starlight', '34.567.890/0001-83', '(47) 98888-2083', 'starlight@distribuidora.com', 'Avenida Marinha, 7583, Joinville - SC', 83),
(84, 'Sky Distribution Services', '45.678.901/0001-84', '(47) 98888-2084', 'skydistribution@distribuidora.com', 'Rua do Comércio, 7684, Joinville - SC', 84),
(85, 'Distribuidora Performa', '56.789.012/0001-85', '(47) 98888-2085', 'performa@distribuidora.com', 'Rua das Palmeiras, 7785, Joinville - SC', 85),
(86, 'Distribuidora Nova Tecnologia', '67.890.123/0001-86', '(47) 98888-2086', 'novatecnologia@distribuidora.com', 'Rua São José, 7886, Joinville - SC', 86),
(87, 'Distribuidora TopTech', '78.901.234/0001-87', '(47) 98888-2087', 'toptech@distribuidora.com', 'Rua Rio de Janeiro, 7987, Joinville - SC', 87),
(88, 'Distribuidora Oeste', '89.012.345/0001-88', '(47) 98888-2088', 'oeste@distribuidora.com', 'Avenida Brasília, 8088, Joinville - SC', 88),
(89, 'Distribuidora Vision', '90.123.456/0001-89', '(47) 98888-2089', 'vision@distribuidora.com', 'Rua do Comércio, 8189, Joinville - SC', 89),
(90, 'Distribuidora Intercontinental', '01.234.567/0001-90', '(47) 98888-2090', 'intercontinental@distribuidora.com', 'Rua Amazonas, 8290, Joinville - SC', 90);

-- --------------------------------------------------------

--
-- Estrutura para tabela `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
CREATE TABLE `fornecedor` (
  `id_fornecedor` int(11) NOT NULL,
  `nome` varchar(45) DEFAULT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `fornecedor`
--

INSERT INTO `fornecedor` (`id_fornecedor`, `nome`, `cnpj`, `telefone`, `email`) VALUES
(1, 'João Silva', '12.345.678/0001-01', '(47) 98888-1001', 'joao.silva@fornecedor.com'),
(2, 'Maria Oliveira', '23.456.789/0001-02', '(47) 98888-1002', 'maria.oliveira@fornecedor.com'),
(3, 'Carlos Santos', '34.567.890/0001-03', '(47) 98888-1003', 'carlos.santos@fornecedor.com'),
(4, 'Ana Souza', '45.678.901/0001-04', '(47) 98888-1004', 'ana.souza@fornecedor.com'),
(5, 'Fernando Lima', '56.789.012/0001-05', '(47) 98888-1005', 'fernando.lima@fornecedor.com'),
(6, 'Patrícia Rocha', '67.890.123/0001-06', '(47) 98888-1006', 'patricia.rocha@fornecedor.com'),
(7, 'Ricardo Costa', '78.901.234/0001-07', '(47) 98888-1007', 'ricardo.costa@fornecedor.com'),
(8, 'Juliana Almeida', '89.012.345/0001-08', '(47) 98888-1008', 'juliana.almeida@fornecedor.com'),
(9, 'Gustavo Mendes', '90.123.456/0001-09', '(47) 98888-1009', 'gustavo.mendes@fornecedor.com'),
(10, 'Roberta Nunes', '01.234.567/0001-10', '(47) 98888-1010', 'roberta.nunes@fornecedor.com'),
(11, 'André Fernandes', '12.345.678/0001-11', '(47) 98888-1011', 'andre.fernandes@fornecedor.com'),
(12, 'Vanessa Ribeiro', '23.456.789/0001-12', '(47) 98888-1012', 'vanessa.ribeiro@fornecedor.com'),
(13, 'Eduardo Martins', '34.567.890/0001-13', '(47) 98888-1013', 'eduardo.martins@fornecedor.com'),
(14, 'Tatiane Carvalho', '45.678.901/0001-14', '(47) 98888-1014', 'tatiane.carvalho@fornecedor.com'),
(15, 'Leonardo Pereira', '56.789.012/0001-15', '(47) 98888-1015', 'leonardo.pereira@fornecedor.com'),
(16, 'Carolina Batista', '67.890.123/0001-16', '(47) 98888-1016', 'carolina.batista@fornecedor.com'),
(17, 'Rodrigo Teixeira', '78.901.234/0001-17', '(47) 98888-1017', 'rodrigo.teixeira@fornecedor.com'),
(18, 'Aline Correia', '89.012.345/0001-18', '(47) 98888-1018', 'aline.correia@fornecedor.com'),
(19, 'Bruno Ferreira', '90.123.456/0001-19', '(47) 98888-1019', 'bruno.ferreira@fornecedor.com'),
(20, 'Camila Duarte', '01.234.567/0001-20', '(47) 98888-1020', 'camila.duarte@fornecedor.com'),
(21, 'Fábio Ramos', '12.345.678/0001-21', '(47) 98888-1021', 'fabio.ramos@fornecedor.com'),
(22, 'Helena Barbosa', '23.456.789/0001-22', '(47) 98888-1022', 'helena.barbosa@fornecedor.com'),
(23, 'Thiago Moreira', '34.567.890/0001-23', '(47) 98888-1023', 'thiago.moreira@fornecedor.com'),
(24, 'Débora Monteiro', '45.678.901/0001-24', '(47) 98888-1024', 'debora.monteiro@fornecedor.com'),
(25, 'Marcos Azevedo', '56.789.012/0001-25', '(47) 98888-1025', 'marcos.azevedo@fornecedor.com'),
(26, 'Elaine Freitas', '67.890.123/0001-26', '(47) 98888-1026', 'elaine.freitas@fornecedor.com'),
(27, 'Alexandre Vasconcelos', '78.901.234/0001-27', '(47) 98888-1027', 'alexandre.vasconcelos@fornecedor.com'),
(28, 'Beatriz Campos', '89.012.345/0001-28', '(47) 98888-1028', 'beatriz.campos@fornecedor.com'),
(29, 'Sérgio Figueiredo', '90.123.456/0001-29', '(47) 98888-1029', 'sergio.figueiredo@fornecedor.com'),
(30, 'Natália Guimarães', '01.234.567/0001-30', '(47) 98888-1030', 'natalia.guimaraes@fornecedor.com'),
(31, 'Rafael Cunha', '12.345.678/0001-31', '(47) 98888-1031', 'rafael.cunha@fornecedor.com'),
(32, 'Fernanda Lopes', '23.456.789/0001-32', '(47) 98888-1032', 'fernanda.lopes@fornecedor.com'),
(33, 'Vitor Barros', '34.567.890/0001-33', '(47) 98888-1033', 'vitor.barros@fornecedor.com'),
(34, 'Adriana Mendes', '45.678.901/0001-34', '(47) 98888-1034', 'adriana.mendes@fornecedor.com'),
(35, 'Samuel Rezende', '56.789.012/0001-35', '(47) 98888-1035', 'samuel.rezende@fornecedor.com'),
(36, 'Larissa Antunes', '67.890.123/0001-36', '(47) 98888-1036', 'larissa.antunes@fornecedor.com'),
(37, 'Márcio Xavier', '78.901.234/0001-37', '(47) 98888-1037', 'marcio.xavier@fornecedor.com'),
(38, 'Viviane Cardoso', '89.012.345/0001-38', '(47) 98888-1038', 'viviane.cardoso@fornecedor.com'),
(39, 'Igor Nascimento', '90.123.456/0001-39', '(47) 98888-1039', 'igor.nascimento@fornecedor.com'),
(40, 'Monique Vasconcelos', '01.234.567/0001-40', '(47) 98888-1040', 'monique.vasconcelos@fornecedor.com'),
(41, 'Henrique Campos', '12.345.678/0001-41', '(47) 98888-1041', 'henrique.campos@fornecedor.com'),
(42, 'Raquel Neves', '23.456.789/0001-42', '(47) 98888-1042', 'raquel.neves@fornecedor.com'),
(43, 'Diego Batista', '34.567.890/0001-43', '(47) 98888-1043', 'diego.batista@fornecedor.com'),
(44, 'Priscila Moura', '45.678.901/0001-44', '(47) 98888-1044', 'priscila.moura@fornecedor.com'),
(45, 'Lucas Gomes', '56.789.012/0001-45', '(47) 98888-1045', 'lucas.gomes@fornecedor.com'),
(46, 'Tatiane Martins', '67.890.123/0001-46', '(47) 98888-1046', 'tatiane.martins@fornecedor.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
CREATE TABLE `funcionario` (
  `id_funcionario` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `cpf` varchar(18) NOT NULL,
  `telefone` varchar(15) NOT NULL,
  `email` varchar(45) NOT NULL,
  `cargo` varchar(50) NOT NULL,
  `salario` decimal(10,2) NOT NULL,
  `data_contratacao` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`id_funcionario`, `nome`, `cpf`, `telefone`, `email`, `cargo`, `salario`, `data_contratacao`) VALUES
(1, 'Carlos Almeida', '123.456.789-00', '(47) 98765-1001', 'carlos.almeida@empresa.com', 'Vendedor', 5000.00, '2020-01-15'),
(2, 'Fernanda Souza', '234.567.890-11', '(47) 98765-1002', 'fernanda.souza@empresa.com', 'Vendedor', 2500.00, '2021-03-22'),
(3, 'Ricardo Costa', '345.678.901-22', '(47) 98765-1003', 'ricardo.costa@empresa.com', 'Vendedor', 4000.00, '2019-05-10'),
(4, 'Ana Lima', '456.789.012-33', '(47) 98765-1004', 'ana.lima@empresa.com', 'Vendedor', 2300.00, '2021-08-19'),
(5, 'Lucas Rocha', '567.890.123-44', '(47) 98765-1005', 'lucas.rocha@empresa.com', 'Vendedor', 5500.00, '2018-11-23'),
(6, 'Patrícia Martins', '678.901.234-55', '(47) 98765-1006', 'patricia.martins@empresa.com', 'Vendedor', 6000.00, '2020-06-30'),
(7, 'Juliana Pereira', '789.012.345-66', '(47) 98765-1007', 'juliana.pereira@empresa.com', 'Vendedor', 3200.00, '2021-04-12'),
(8, 'Gustavo Silva', '890.123.456-77', '(47) 98765-1008', 'gustavo.silva@empresa.com', 'Vendedor', 4200.00, '2019-09-25'),
(9, 'Mariana Alves', '901.234.567-88', '(47) 98765-1009', 'mariana.alves@empresa.com', 'Vendedor', 2200.00, '2021-07-15'),
(10, 'Felipe Oliveira', '012.345.678-99', '(47) 98765-1010', 'felipe.oliveira@empresa.com', 'Vendedor', 3100.00, '2020-05-20'),
(11, 'Bruna Costa', '123.456.789-01', '(47) 98765-1011', 'bruna.costa@empresa.com', 'Gerente', 5000.00, '2017-02-14'),
(12, 'Marcelo Souza', '234.567.890-12', '(47) 98765-1012', 'marcelo.souza@empresa.com', 'Coordenador', 5500.00, '2018-12-11'),
(13, 'Carla Martins', '345.678.901-23', '(47) 98765-1013', 'carla.martins@empresa.com', 'Assistente', 2400.00, '2020-10-18'),
(14, 'Vinícius Lima', '456.789.012-34', '(47) 98765-1014', 'vinicius.lima@empresa.com', 'Analista', 3000.00, '2020-08-05'),
(15, 'Jéssica Rocha', '567.890.123-45', '(47) 98765-1015', 'jessica.rocha@empresa.com', 'Supervisor', 4300.00, '2019-04-10'),
(16, 'Roberta Costa', '678.901.234-56', '(47) 98765-1016', 'roberta.costa@empresa.com', 'Coordenadora', 6200.00, '2021-01-23'),
(17, 'Eduardo Pereira', '789.012.345-67', '(47) 98765-1017', 'eduardo.pereira@empresa.com', 'Gerente', 5800.00, '2018-03-19'),
(18, 'Ricardo Oliveira', '890.123.456-78', '(47) 98765-1018', 'ricardo.oliveira@empresa.com', 'Supervisor', 4100.00, '2019-12-08'),
(19, 'Simone Lima', '901.234.567-89', '(47) 98765-1019', 'simone.lima@empresa.com', 'Assistente', 2200.00, '2021-02-17'),
(20, 'Marcelo Rocha', '012.345.678-10', '(47) 98765-1020', 'marcelo.rocha@empresa.com', 'Coordenador', 5600.00, '2020-11-06'),
(21, 'André Costa', '123.456.789-11', '(47) 98765-1021', 'andre.costa@empresa.com', 'Analista', 3100.00, '2020-09-22'),
(22, 'Patrícia Souza', '234.567.890-22', '(47) 98765-1022', 'patricia.souza@empresa.com', 'Assistente', 2500.00, '2021-05-14'),
(23, 'Tiago Martins', '345.678.901-33', '(47) 98765-1023', 'tiago.martins@empresa.com', 'Gerente', 5200.00, '2019-06-09'),
(24, 'Cláudia Rocha', '456.789.012-44', '(47) 98765-1024', 'claudia.rocha@empresa.com', 'Coordenadora', 6300.00, '2018-10-23'),
(25, 'Felipe Santos', '567.890.123-55', '(47) 98765-1025', 'felipe.santos@empresa.com', 'Assistente', 2300.00, '2020-02-14'),
(26, 'Giovanni Souza', '678.901.234-66', '(47) 98765-1026', 'giovanni.souza@empresa.com', 'Analista', 3200.00, '2021-01-30'),
(27, 'Vanessa Lima', '789.012.345-77', '(47) 98765-1027', 'vanessa.lima@empresa.com', 'Supervisor', 4400.00, '2019-07-17'),
(28, 'Leandro Rocha', '890.123.456-88', '(47) 98765-1028', 'leandro.rocha@empresa.com', 'Gerente', 5100.00, '2018-09-14'),
(29, 'Paula Martins', '901.234.567-99', '(47) 98765-1029', 'paula.martins@empresa.com', 'Coordenadora', 5900.00, '2020-07-25'),
(30, 'Aline Pereira', '012.345.678-21', '(47) 98765-1030', 'aline.pereira@empresa.com', 'Assistente', 2400.00, '2021-06-10'),
(31, 'Carlos Rocha', '123.456.789-32', '(47) 98765-1031', 'carlos.rocha@empresa.com', 'Supervisor', 4200.00, '2019-08-30'),
(32, 'Juliana Costa', '234.567.890-43', '(47) 98765-1032', 'juliana.costa@empresa.com', 'Gerente', 5500.00, '2017-12-12'),
(33, 'Ricardo Rocha', '345.678.901-54', '(47) 98765-1033', 'ricardo.rocha@empresa.com', 'Analista', 3000.00, '2020-03-11'),
(34, 'Mariana Pereira', '456.789.012-65', '(47) 98765-1034', 'mariana.pereira@empresa.com', 'Coordenadora', 6000.00, '2021-04-01'),
(35, 'Gustavo Oliveira', '567.890.123-76', '(47) 98765-1035', 'gustavo.oliveira@empresa.com', 'Assistente', 2200.00, '2020-12-18'),
(36, 'Júlia Lima', '678.901.234-87', '(47) 98765-1036', 'julia.lima@empresa.com', 'Supervisor', 4300.00, '2019-05-15'),
(37, 'Eduardo Souza', '789.012.345-98', '(47) 98765-1037', 'eduardo.souza@empresa.com', 'Gerente', 5600.00, '2018-11-09'),
(38, 'Lucas Costa', '890.123.456-09', '(47) 98765-1038', 'lucas.costa@empresa.com', 'Analista', 3100.00, '2020-07-03'),
(39, 'Carla Rocha', '901.234.567-10', '(47) 98765-1039', 'carla.rocha@empresa.com', 'Coordenadora', 5800.00, '2021-02-08'),
(40, 'Tiago Souza', '012.345.678-31', '(47) 98765-1040', 'tiago.souza@empresa.com', 'Assistente', 2500.00, '2020-06-21'),
(41, 'Renata Lima', '123.456.789-42', '(47) 98765-1041', 'renata.lima@empresa.com', 'Gerente', 5400.00, '2018-04-06'),
(42, 'Felipe Pereira', '234.567.890-53', '(47) 98765-1042', 'felipe.pereira@empresa.com', 'Supervisor', 4500.00, '2019-01-13'),
(43, 'Paula Rocha', '345.678.901-64', '(47) 98765-1043', 'paula.rocha@empresa.com', 'Coordenadora', 5900.00, '2020-09-16'),
(44, 'Lucas Martins', '456.789.012-75', '(47) 98765-1044', 'lucas.martins@empresa.com', 'Assistente', 2300.00, '2021-07-11'),
(45, 'Thiago Souza', '567.890.123-86', '(47) 98765-1045', 'thiago.souza@empresa.com', 'Analista', 3200.00, '2020-10-26'),
(46, 'Ana Pereira', '678.901.234-97', '(47) 98765-1046', 'ana.pereira@empresa.com', 'Supervisor', 4400.00, '2019-06-02'),
(47, 'Roberto Costa', '789.012.345-08', '(47) 98765-1047', 'roberto.costa@empresa.com', 'Coordenador', 5800.00, '2018-10-30'),
(48, 'Juliana Martins', '890.123.456-19', '(47) 98765-1048', 'juliana.martins@empresa.com', 'Assistente', 2400.00, '2020-04-15'),
(49, 'Gustavo Pereira', '901.234.567-20', '(47) 98765-1049', 'gustavo.pereira@empresa.com', 'Gerente', 5200.00, '2017-11-03'),
(50, 'Tânia Rocha', '012.345.678-51', '(47) 98765-1050', 'tania.rocha@empresa.com', 'Coordenadora', 5700.00, '2021-03-14'),
(51, 'Carlos Souza', '123.456.789-62', '(47) 98765-1051', 'carlos.souza@empresa.com', 'Assistente', 2200.00, '2021-09-03'),
(52, 'Juliana Oliveira', '234.567.890-73', '(47) 98765-1052', 'juliana.oliveira@empresa.com', 'Analista', 3100.00, '2020-01-04'),
(53, 'Felipe Costa', '345.678.901-84', '(47) 98765-1053', 'felipe.costa@empresa.com', 'Supervisor', 4300.00, '2019-08-10'),
(54, 'Mariana Rocha', '456.789.012-95', '(47) 98765-1054', 'mariana.rocha@empresa.com', 'Coordenadora', 5900.00, '2020-03-29'),
(55, 'Ricardo Pereira', '567.890\r\n\r\n.123-06', '(47) 98765-1055', 'ricardo.pereira@empresa.com', 'Gerente', 5100.00, '2018-06-15'),
(56, 'Paula Oliveira', '678.901.234-17', '(47) 98765-1056', 'paula.oliveira@empresa.com', 'Assistente', 2400.00, '2021-01-25'),
(57, 'Eduardo Rocha', '789.012.345-28', '(47) 98765-1057', 'eduardo.rocha@empresa.com', 'Supervisor', 4200.00, '2019-04-04'),
(58, 'Vinícius Souza', '890.123.456-39', '(47) 98765-1058', 'vinicius.souza@empresa.com', 'Coordenador', 5600.00, '2020-05-22'),
(59, 'Jéssica Oliveira', '901.234.567-40', '(47) 98765-1059', 'jessica.oliveira@empresa.com', 'Assistente', 2200.00, '2021-07-08'),
(60, 'Rafael Costa', '012.345.678-61', '(47) 98765-1060', 'rafael.costa@empresa.com', 'Analista', 3000.00, '2020-02-03'),
(61, 'Letícia Rocha', '123.456.789-72', '(47) 98765-1061', 'leticia.rocha@empresa.com', 'Gerente', 5000.00, '2018-11-21'),
(62, 'Roberta Souza', '234.567.890-83', '(47) 98765-1062', 'roberta.souza@empresa.com', 'Coordenadora', 5900.00, '2020-06-16'),
(63, 'Carlos Pereira', '345.678.901-94', '(47) 98765-1063', 'carlos.pereira@empresa.com', 'Assistente', 2400.00, '2020-03-02'),
(64, 'Ricardo Lima', '456.789.012-05', '(47) 98765-1064', 'ricardo.lima@empresa.com', 'Supervisor', 4200.00, '2019-01-01'),
(65, 'Patrícia Rocha', '567.890.123-16', '(47) 98765-1065', 'patricia.rocha@empresa.com', 'Gerente', 5100.00, '2018-08-24'),
(66, 'André Rocha', '678.901.234-27', '(47) 98765-1066', 'andre.rocha@empresa.com', 'Coordenador', 5700.00, '2020-10-19'),
(67, 'Simone Souza', '789.012.345-38', '(47) 98765-1067', 'simone.souza@empresa.com', 'Assistente', 2300.00, '2021-08-04'),
(68, 'Juliana Lima', '890.123.456-49', '(47) 98765-1068', 'juliana.lima@empresa.com', 'Analista', 3100.00, '2020-11-17'),
(69, 'Thiago Rocha', '901.234.567-50', '(47) 98765-1069', 'thiago.rocha@empresa.com', 'Supervisor', 4200.00, '2019-05-03'),
(70, 'Carlos Oliveira', '012.345.678-61', '(47) 98765-1070', 'carlos.oliveira@empresa.com', 'Coordenador', 5600.00, '2020-02-20');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido`
--

DROP TABLE IF EXISTS `pedido`;
CREATE TABLE `pedido` (
  `id_pedido` int(11) NOT NULL,
  `data_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('Pendente','Processando','Enviado','Entregue','Cancelado') NOT NULL DEFAULT 'Pendente',
  `total` decimal(10,2) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL CHECK (`quantidade` > 0),
  `preco_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido`
--

INSERT INTO `pedido` (`id_pedido`, `data_pedido`, `status`, `total`, `cliente_id`, `produto_id`, `quantidade`, `preco_unitario`) VALUES
(1, '2025-02-28 16:04:38', 'Processando', 91.00, 15, 23, 2, 45.50),
(2, '2025-02-28 16:04:38', 'Pendente', 120.00, 32, 11, 1, 120.00),
(3, '2025-02-28 16:04:38', 'Pendente', 98.97, 7, 45, 3, 32.99),
(4, '2025-02-28 16:04:38', 'Pendente', 63.00, 51, 78, 4, 15.75),
(5, '2025-02-28 16:04:38', 'Pendente', 160.40, 3, 34, 2, 80.20),
(6, '2024-11-13 07:04:38', 'Pendente', 125.00, 28, 5, 5, 25.00),
(7, '2025-02-28 16:04:38', 'Pendente', 99.99, 64, 89, 1, 99.99),
(8, '2025-02-28 16:04:38', 'Pendente', 131.50, 42, 17, 2, 65.75),
(9, '2025-02-28 16:04:38', 'Pendente', 135.30, 9, 68, 3, 45.10),
(10, '2025-02-28 16:04:38', 'Pendente', 95.96, 18, 12, 4, 23.99),
(11, '2025-02-28 16:04:38', 'Pendente', 110.00, 21, 77, 2, 55.00),
(12, '2025-02-28 16:04:38', 'Pendente', 200.00, 66, 3, 1, 200.00),
(13, '2025-02-28 16:04:38', 'Pendente', 99.99, 50, 56, 3, 33.33),
(14, '2025-02-28 16:04:38', 'Pendente', 91.00, 5, 90, 5, 18.20),
(15, '2025-02-28 11:34:48', 'Pendente', 98.98, 34, 29, 2, 49.49),
(16, '2025-02-28 16:04:38', 'Pendente', 119.99, 12, 11, 1, 119.99),
(17, '2025-02-28 16:04:38', 'Pendente', 58.00, 70, 8, 4, 14.50),
(18, '2025-01-31 08:36:23', 'Entregue', 89.97, 47, 22, 3, 29.99),
(19, '2025-02-28 16:04:38', 'Pendente', 154.00, 23, 66, 2, 77.00),
(20, '2025-02-28 16:04:38', 'Pendente', 50.00, 31, 9, 5, 10.00),
(21, '2025-02-28 16:04:38', 'Pendente', 116.85, 6, 49, 3, 38.95),
(22, '2025-02-28 16:04:38', 'Pendente', 75.20, 54, 30, 1, 75.20),
(23, '2025-02-28 16:04:38', 'Pendente', 111.00, 25, 71, 2, 55.50),
(24, '2023-02-08 09:33:38', 'Pendente', 89.00, 8, 37, 4, 22.25),
(25, '2025-02-28 16:04:38', 'Pendente', 122.25, 45, 15, 3, 40.75),
(26, '2025-02-20 16:04:38', 'Enviado', 180.99, 14, 55, 1, 180.99),
(27, '2024-10-15 09:39:38', 'Pendente', 120.60, 35, 24, 2, 60.30),
(28, '2025-02-10 10:37:38', 'Enviado', 62.45, 20, 64, 5, 12.49),
(29, '2025-02-28 16:04:38', 'Entregue', 270.30, 19, 79, 3, 90.10),
(30, '2025-02-28 13:18:26', 'Processando', 66.66, 41, 42, 2, 33.33),
(31, '2025-02-17 11:19:38', 'Cancelado', 83.96, 17, 35, 4, 20.99),
(32, '2024-12-02 12:04:38', 'Entregue', 300.00, 59, 1, 2, 150.00),
(33, '2025-02-28 16:04:38', 'Pendente', 95.90, 38, 63, 1, 95.90),
(34, '2025-02-28 16:04:38', 'Pendente', 128.25, 49, 16, 3, 42.75),
(35, '2025-02-28 16:04:38', 'Pendente', 119.98, 27, 88, 2, 59.99),
(36, '2025-02-28 16:04:38', 'Pendente', 103.96, 13, 52, 4, 25.99),
(37, '2025-02-28 16:04:38', 'Pendente', 67.50, 44, 19, 5, 13.50),
(38, '2025-02-02 06:30:38', 'Cancelado', 140.00, 11, 81, 2, 70.00),
(39, '2025-02-28 16:04:38', 'Pendente', 166.65, 57, 10, 3, 55.55),
(40, '2025-02-28 16:04:38', 'Pendente', 85.75, 4, 47, 1, 85.75),
(41, '2025-02-28 16:04:38', 'Pendente', 97.60, 29, 39, 2, 48.80),
(42, '2025-02-28 16:04:38', 'Pendente', 120.00, 36, 62, 4, 30.00),
(43, '2025-02-28 16:04:38', 'Pendente', 83.97, 2, 14, 3, 27.99),
(44, '2025-02-28 16:04:38', 'Pendente', 199.00, 68, 26, 1, 199.00),
(45, '2024-11-20 15:17:22', 'Cancelado', 63.75, 53, 50, 5, 12.75),
(46, '2025-03-03 11:04:38', 'Pendente', 89.00, 24, 58, 2, 44.50),
(47, '2025-02-28 16:04:38', 'Pendente', 79.96, 37, 21, 4, 19.99),
(48, '2025-02-28 16:04:38', 'Pendente', 106.47, 61, 33, 3, 35.49),
(49, '2025-02-28 16:04:38', 'Pendente', 89.99, 40, 76, 1, 89.99),
(50, '2025-03-01 18:04:38', 'Entregue', 240.00, 10, 4, 2, 120.00),
(51, '2025-02-28 16:04:38', 'Pendente', 125.00, 26, 28, 4, 31.25),
(52, '2025-02-28 16:04:38', 'Pendente', 50.97, 22, 67, 3, 16.99),
(53, '2025-02-28 16:04:38', 'Pendente', 151.00, 16, 60, 2, 75.50),
(54, '2025-02-28 16:04:38', 'Pendente', 106.00, 63, 36, 5, 21.20),
(55, '2025-02-28 16:04:38', 'Pendente', 149.99, 33, 13, 1, 149.99),
(56, '2025-02-28 16:04:38', 'Pendente', 95.60, 30, 46, 2, 47.80),
(57, '2025-02-28 16:04:38', 'Pendente', 195.75, 1, 25, 3, 65.25),
(58, '2025-02-28 16:04:38', 'Pendente', 91.00, 43, 6, 4, 22.75),
(59, '2024-11-15 14:04:38', 'Enviado', 59.50, 58, 70, 1, 59.50),
(60, '2025-02-05 13:04:38', 'Processando', 80.80, 60, 59, 2, 40.40),
(61, '2025-03-05 10:04:38', 'Pendente', 154.95, 48, 32, 5, 30.99),
(62, '2025-02-28 16:04:38', 'Enviado', 53.25, 9, 54, 3, 17.75),
(63, '2023-05-17 07:40:38', 'Entregue', 223.96, 46, 20, 4, 55.99),
(64, '2024-07-15 10:04:38', 'Cancelado', 77.20, 56, 31, 2, 38.60),
(65, '2025-02-12 16:04:38', 'Pendente', 92.99, 67, 48, 1, 92.99),
(66, '2025-02-28 16:04:38', 'Pendente', 150.75, 39, 85, 3, 50.25),
(67, '2024-07-09 08:04:38', 'Cancelado', 77.96, 55, 7, 4, 19.49),
(68, '2025-02-28 16:04:38', 'Pendente', 124.95, 62, 72, 5, 24.99),
(69, '2025-02-28 16:04:38', 'Pendente', 157.60, 65, 18, 2, 78.80),
(70, '2025-02-28 16:04:38', 'Pendente', 89.20, 52, 51, 1, 89.20),
(71, '2025-02-28 16:04:38', 'Pendente', 137.97, 69, 27, 3, 45.99),
(72, '2025-02-28 16:04:38', 'Pendente', 156.00, 3, 41, 4, 39.00),
(73, '2025-02-28 16:04:38', 'Pendente', 59.00, 5, 75, 2, 29.50),
(74, '2025-02-28 16:04:38', 'Pendente', 99.99, 7, 40, 1, 99.99),
(75, '2025-02-28 16:04:38', 'Pendente', 167.25, 70, 2, 3, 55.75),
(76, '2025-02-28 16:04:38', 'Pendente', 105.00, 31, 80, 4, 26.25),
(77, '2025-02-28 16:04:38', 'Pendente', 121.98, 14, 57, 2, 60.99),
(78, '2025-02-28 16:04:38', 'Pendente', 150.50, 47, 43, 1, 150.50),
(79, '2025-02-28 16:04:38', 'Pendente', 145.50, 23, 73, 3, 48.50),
(80, '2025-02-28 16:04:38', 'Pendente', 147.20, 21, 86, 4, 36.80),
(81, '2025-02-28 16:04:38', 'Pendente', 114.95, 8, 74, 5, 22.99),
(82, '2025-02-28 16:04:38', 'Pendente', 136.60, 19, 87, 2, 68.30),
(83, '2025-02-28 16:04:38', 'Pendente', 99.00, 25, 53, 1, 99.00),
(84, '2025-02-28 16:04:38', 'Pendente', 126.75, 50, 38, 3, 42.25),
(85, '2025-02-28 16:04:38', 'Pendente', 75.50, 45, 44, 2, 37.75),
(86, '2025-02-28 16:04:38', 'Pendente', 99.95, 12, 61, 5, 19.99),
(87, '2025-02-28 16:04:38', 'Pendente', 85.50, 66, 82, 3, 28.50),
(88, '2025-02-28 16:04:38', 'Pendente', 99.80, 9, 34, 2, 49.90),
(89, '2025-02-11 09:04:38', 'Pendente', 86.00, 30, 55, 4, 21.50),
(90, '2024-02-28 00:00:00', '', 450.00, 1, 10, 3, 150.00);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

DROP TABLE IF EXISTS `produto`;
CREATE TABLE `produto` (
  `id_produto` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `descricao` text DEFAULT NULL,
  `estoque` int(11) NOT NULL,
  `cliente_id_cliente` int(11) DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `Fornecedor_id_fornecedor` int(11) DEFAULT NULL,
  `Pedido_id_pedido` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`id_produto`, `nome`, `descricao`, `estoque`, `cliente_id_cliente`, `preco`, `Fornecedor_id_fornecedor`, `Pedido_id_pedido`) VALUES
(1, 'Sofá Retrátil', 'Sofá confortável com tecido premium', 15, 34, 200.00, 1, 1),
(2, 'Cadeira Gamer', 'Cadeira ergonômica para longas horas de uso', 20, 21, 700.00, 2, 2),
(3, 'Mesa de Jantar', 'Mesa de madeira para 6 pessoas', 10, 13, 1000.00, 3, 3),
(4, 'Cama Box Casal', 'Cama box de alta durabilidade', 8, 45, 600.00, 2, 4),
(5, 'Guarda-Roupa 6 Portas', 'Guarda-roupa espaçoso com divisórias', 5, 11, 2000.00, 4, 5),
(6, 'Rack para TV', 'Rack moderno para sala', 12, 52, 300.00, 5, 6),
(7, 'Escrivaninha Office', 'Escrivaninha compacta para escritório', 14, 19, 400.00, 6, 7),
(8, 'Poltrona Reclinável', 'Poltrona macia com ajuste de inclinação', 9, 32, 500.00, 7, 8),
(9, 'Estante de Livros', 'Estante de madeira com 5 prateleiras', 11, 14, 300.00, 8, 9),
(10, 'Colchão Queen', 'Colchão de espuma viscoelástica', 7, 40, 500.00, 9, 10),
(11, 'Mesa de Centro', 'Mesa moderna para sala de estar', 10, 8, 300.00, 10, 11),
(12, 'Cabeceira Estofada', 'Cabeceira de tecido para cama casal', 6, 29, 234.00, 11, 12),
(13, 'Penteadeira com Espelho', 'Penteadeira clássica com gavetas', 5, 42, 345.00, 12, 13),
(14, 'Banqueta Alta', 'Banqueta para cozinha ou bar', 18, 9, 800.00, 13, 14),
(15, 'Armário Multiuso', 'Armário versátil para qualquer ambiente', 7, 16, 900.00, 14, 15),
(16, 'Cadeira Dobrável', 'Cadeira compacta para eventos', 22, 5, 450.00, 15, 16),
(17, 'Sofá-Cama', 'Sofá-cama dobrável e confortável', 9, 60, 600.00, 16, 17),
(18, 'Mesa de Escritório', 'Mesa espaçosa com gavetas', 13, 18, 900.00, 17, 18),
(19, 'Cadeira Estofada', 'Cadeira para sala de jantar', 16, 38, 230.99, 18, 19),
(20, 'Armário de Cozinha', 'Armário suspenso com portas de vidro', 8, 27, 555.55, 19, 20),
(21, 'Criado-Mudo', 'Mesa de cabeceira com duas gavetas', 12, 63, 111.11, 20, 21),
(22, 'Painel para TV', 'Painel para TV até 55 polegadas', 10, 23, 234.44, 21, 22),
(23, 'Sapateira', 'Sapateira com portas e prateleiras', 15, 51, 567.55, 22, 23),
(24, 'Buffet para Sala', 'Buffet rústico de madeira maciça', 6, 30, 800.88, 23, 24),
(25, 'Cômoda 4 Gavetas', 'Cômoda espaçosa para roupas', 9, 46, 899.00, 24, 25),
(26, 'Mesa Retrátil', 'Mesa de parede retrátil para otimizar espaço', 11, 3, 809.99, 25, 26),
(27, 'Estante Modular', 'Estante para organização de livros e objetos', 14, 22, 345.55, 26, 27),
(28, 'Balcão para Cozinha', 'Balcão de madeira com portas e gavetas', 7, 12, 345.67, 27, 28),
(29, 'Banco Estofado', 'Banco confortável para sala ou varanda', 19, 7, 890.78, 28, 29),
(30, 'Escrivaninha com Prateleira', 'Escrivaninha compacta com nichos', 10, 36, 567.67, 29, 30),
(31, 'Cadeira de Madeira', 'Cadeira resistente para sala de jantar', 12, 40, 789.89, 30, 31),
(32, 'Mesa de Apoio', 'Mesa lateral para sala de estar', 9, 33, 345.45, 31, 32),
(33, 'Cama Solteiro', 'Cama de madeira com colchão', 7, 14, 567.56, 32, 33),
(34, 'Armário Pequeno', 'Armário compacto para cozinha', 10, 50, 890.89, 33, 34),
(35, 'Mesa de Vidro', 'Mesa moderna com tampo de vidro', 6, 12, 456.67, 33, 35),
(36, 'Banco de Jardim', 'Banco rústico de madeira', 8, 27, 345.67, 33, 36),
(37, 'Sofá de Couro', 'Sofá elegante de couro legítimo', 5, 19, 678.67, 34, 37),
(38, 'Cadeira de Escritório', 'Cadeira giratória com apoio lombar', 14, 9, 987.77, 34, 38),
(39, 'Mesa Dobrável', 'Mesa portátil para diversos usos', 10, 35, 123.44, 34, 39),
(40, 'Armário com Espelho', 'Armário para banheiro com espelho', 9, 42, 567.00, 35, 40),
(41, 'Mesa de Ferro', 'Mesa resistente para área externa', 8, 31, 345.00, 35, 41),
(42, 'Cabeceira de Madeira', 'Cabeceira rústica para cama', 6, 58, 456.88, 36, 42),
(43, 'Cadeira Estilo Industrial', 'Cadeira metálica para decoração moderna', 15, 20, 345.44, 37, 43),
(44, 'Mesa de Madeira Maciça', 'Mesa robusta e durável', 12, 10, 555.66, 38, 44),
(45, 'Puff Redondo', 'Puff confortável para sala', 14, 55, 900.99, 39, 45),
(46, 'Sofá 3 Lugares', 'Sofá espaçoso e aconchegante', 7, 17, 345.00, 40, 46),
(47, 'Estante com Nichos', 'Estante moderna para decoração', 9, 49, 607.00, 41, 47),
(48, 'Cama Box Solteiro', 'Cama box com colchão incluso', 6, 60, 600.99, 42, 48),
(49, 'Rack para Home Theater', 'Rack espaçoso para equipamentos de som', 10, 16, 799.99, 43, 49),
(50, 'Banqueta Industrial', 'Banqueta metálica para cozinha', 13, 5, 890.00, 44, 50),
(51, 'Mesa Rústica', 'Mesa de madeira maciça com acabamento rústico', 8, 35, 678.00, 45, 51),
(52, 'Cadeira de Balanço', 'Cadeira confortável para leitura e descanso', 5, 42, 345.77, 46, 52),
(53, 'Sofá Modular', 'Sofá que pode ser ajustado em diferentes posições', 10, 18, 456.77, 1, 53),
(54, 'Cômoda Retrô', 'Cômoda com design retrô e pés palito', 12, 50, 888.88, 1, 54),
(55, 'Bicama Multifuncional', 'Cama com cama auxiliar para visitas', 7, 12, 908.00, 2, 55),
(56, 'Estante de Aço', 'Estante resistente para organização de materiais', 15, 27, 345.66, 2, 56),
(57, 'Poltrona Egg', 'Poltrona icônica para decoração moderna', 6, 31, 890.00, 2, 57),
(58, 'Mesa Redonda', 'Mesa de jantar redonda para pequenos espaços', 9, 5, 900.99, 3, 58),
(59, 'Gabinete para Banheiro', 'Gabinete compacto para banheiro', 11, 20, 450.00, 3, 59),
(60, 'Berço Infantil', 'Berço de madeira para bebês', 10, 48, 600.00, 4, 60),
(61, 'Prateleira Flutuante', 'Prateleira discreta para decoração', 20, 36, 800.00, 4, 61),
(62, 'Divã Estofado', 'Divã confortável para salas de estar', 7, 13, 345.00, 4, 62),
(63, 'Banco Dobrável', 'Banco de madeira dobrável para varanda', 12, 59, 600.00, 5, 63),
(64, 'Armário de Escritório', 'Armário para organizar documentos e arquivos', 8, 24, 900.00, 6, 64),
(65, 'Cadeira de Ferro', 'Cadeira resistente para área externa', 14, 10, 760.00, 7, 65),
(66, 'Mesa Lateral Industrial', 'Mesa pequena com acabamento em ferro', 10, 39, 450.00, 8, 66),
(67, 'Puff Quadrado', 'Puff estofado para apoio dos pés', 13, 7, 770.00, 9, 67),
(68, 'Conjunto de Sofás', 'Conjunto com sofá de 2 e 3 lugares', 9, 33, 560.00, 10, 68),
(69, 'Rack Suspenso', 'Rack compacto para TV e eletrônicos', 11, 21, 345.00, 11, 69),
(70, 'Mesa de Bar', 'Mesa alta para área gourmet', 7, 58, 890.00, 12, 70),
(71, 'Cadeira com Rodízios', 'Cadeira de escritório ajustável', 10, 46, 345.66, 13, 71),
(72, 'Puff Baú', 'Puff que serve como baú para armazenamento', 6, 52, 211.00, 14, 72),
(73, 'Painel Ripado', 'Painel de madeira ripado para TV', 20, 29, 900.00, 15, 73),
(74, 'Cristaleira Clássica', 'Cristaleira elegante para louças e taças', 8, 9, 999.00, 16, 74),
(75, 'Estante para Vinil', 'Estante especializada para colecionadores de vinil', 9, 55, 800.99, 17, 75),
(76, 'Mesa Dobrável de Parede', 'Mesa que pode ser recolhida quando não usada', 6, 30, 500.99, 18, 76),
(77, 'Mesa Escritório Gamer', 'Mesa ideal para gamers com espaço para monitores', 15, 44, 670.00, 19, 77),
(78, 'Sofá Retrátil 4 Lugares', 'Sofá grande com assentos retráteis', 8, 22, 345.00, 20, 78),
(79, 'Guarda-Roupa Planejado', 'Guarda-roupa moderno com portas de correr', 7, 47, 245.00, 21, 79),
(80, 'Aparador Industrial', 'Aparador em ferro e madeira', 9, 17, 987.00, 21, 80),
(81, 'Balcão Multiuso', 'Balcão versátil para sala ou cozinha', 12, 1, 890.00, 22, 81),
(82, 'Mesa Retrô', 'Mesa pequena com design vintage', 5, 34, 567.00, 22, 82),
(83, 'Estante Minimalista', 'Estante com design moderno e clean', 8, 16, 890.00, 22, 83),
(84, 'Poltrona de Madeira', 'Poltrona confortável com estrutura de madeira', 11, 60, 345.99, 22, 84),
(85, 'Banco com Estofado', 'Banco longo com estofado confortável', 7, 26, 567.99, 23, 85),
(86, 'Guarda-Roupa Infantil', 'Guarda-roupa pequeno para crianças', 14, 11, 890.00, 24, 86),
(87, 'Estante Geométrica', 'Estante diferenciada com nichos assimétricos', 10, 37, 230.00, 25, 87),
(88, 'Rack de Madeira Maciça', 'Rack grande e resistente', 6, 63, 300.00, 27, 88),
(89, 'Mesa com Bancos', 'Mesa de madeira com bancos embutidos', 8, 14, 345.00, 30, 89),
(90, 'Conjunto de Puffs', 'Trio de puffs estofados para sala', 13, 6, 999.99, 31, 90);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_cliente_produto`
-- (Veja abaixo para a visão atual)
--
DROP VIEW IF EXISTS `vw_cliente_produto`;
CREATE TABLE `vw_cliente_produto` (
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_funcionario_cliente`
-- (Veja abaixo para a visão atual)
--
DROP VIEW IF EXISTS `vw_funcionario_cliente`;
CREATE TABLE `vw_funcionario_cliente` (
`cargo_funcionario` varchar(50)
,`cpf_funcionario` varchar(18)
,`data_contratacao_funcionario` date
,`email_funcionario` varchar(45)
,`id_funcionario_funcionario` int(11)
,`nome_funcionario` varchar(45)
,`salario_funcionario` decimal(10,2)
,`telefone_funcionario` varchar(15)
,`cpf_cliente` varchar(18)
,`email_cliente` varchar(45)
,`endereco_cliente` varchar(60)
,`funcionario_id_funcionario_cliente` int(11)
,`id_cliente` int(11)
,`nome_cliente` varchar(45)
,`telefone_cliente` varchar(15)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_produto_distribuidora`
-- (Veja abaixo para a visão atual)
--
DROP VIEW IF EXISTS `vw_produto_distribuidora`;
CREATE TABLE `vw_produto_distribuidora` (
);

-- --------------------------------------------------------

--
-- Estrutura para view `vw_cliente_produto`
--
DROP TABLE IF EXISTS `vw_cliente_produto`;

DROP VIEW IF EXISTS `vw_cliente_produto`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_cliente_produto`  AS SELECT `c`.`cpf` AS `cpf_cliente`, `c`.`email` AS `email_cliente`, `c`.`endereco` AS `endereco_cliente`, `c`.`funcionario_id_funcionario` AS `funcionario_id_funcionario_cliente`, `c`.`id_cliente` AS `id_cliente`, `c`.`nome` AS `nome_cliente`, `c`.`telefone` AS `telefone_cliente`, `p`.`cliente_id_cliente` AS `cliente_id_cliente_produto`, `p`.`descricao` AS `descricao_produto`, `p`.`estoque` AS `estoque_produto`, `p`.`funcionario_id_funcionario` AS `funcionario_id_funcionario_produto`, `p`.`id_produto` AS `id_produto`, `p`.`nome` AS `nome_produto` FROM (`cliente` `c` join `produto` `p` on(`c`.`id_cliente` = `p`.`cliente_id_cliente`)) ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_funcionario_cliente`
--
DROP TABLE IF EXISTS `vw_funcionario_cliente`;

DROP VIEW IF EXISTS `vw_funcionario_cliente`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_funcionario_cliente`  AS SELECT `f`.`cargo` AS `cargo_funcionario`, `f`.`cpf` AS `cpf_funcionario`, `f`.`data_contratacao` AS `data_contratacao_funcionario`, `f`.`email` AS `email_funcionario`, `f`.`id_funcionario` AS `id_funcionario_funcionario`, `f`.`nome` AS `nome_funcionario`, `f`.`salario` AS `salario_funcionario`, `f`.`telefone` AS `telefone_funcionario`, `c`.`cpf` AS `cpf_cliente`, `c`.`email` AS `email_cliente`, `c`.`endereco` AS `endereco_cliente`, `c`.`funcionario_id_funcionario` AS `funcionario_id_funcionario_cliente`, `c`.`id_cliente` AS `id_cliente`, `c`.`nome` AS `nome_cliente`, `c`.`telefone` AS `telefone_cliente` FROM (`cliente` `c` join `funcionario` `f` on(`c`.`funcionario_id_funcionario` = `f`.`id_funcionario`)) ;

-- --------------------------------------------------------

--
-- Estrutura para view `vw_produto_distribuidora`
--
DROP TABLE IF EXISTS `vw_produto_distribuidora`;

DROP VIEW IF EXISTS `vw_produto_distribuidora`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_produto_distribuidora`  AS SELECT `p`.`cliente_id_cliente` AS `cliente_id_cliente_produto`, `p`.`descricao` AS `descricao_produto`, `p`.`estoque` AS `estoque_produto`, `p`.`funcionario_id_funcionario` AS `funcionario_id_funcionario_produto`, `p`.`id_produto` AS `id_produto`, `p`.`nome` AS `nome_produto`, `d`.`cnpj` AS `cnpj_distribuidora`, `d`.`email` AS `email_distribuidora`, `d`.`endereco` AS `endereco_distribuidora`, `d`.`id_distribuidora` AS `id_distribuidora`, `d`.`nome` AS `nome_distribuidora`, `d`.`produto_id_produto` AS `produto_id_produto_distribuidora`, `d`.`telefone` AS `telefone_distribuidora` FROM (`produto` `p` join `distribuidora` `d` on(`p`.`id_produto` = `d`.`produto_id_produto`)) ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD KEY `fk_funcionario` (`funcionario_id_funcionario`);

--
-- Índices de tabela `distribuidora`
--
ALTER TABLE `distribuidora`
  ADD PRIMARY KEY (`id_distribuidora`),
  ADD KEY `fk_produto_id_produto` (`produto_id_produto`);

--
-- Índices de tabela `fornecedor`
--
ALTER TABLE `fornecedor`
  ADD PRIMARY KEY (`id_fornecedor`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id_funcionario`);

--
-- Índices de tabela `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedido_cliente` (`cliente_id`),
  ADD KEY `fk_pedido_produto` (`produto_id`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `fk_cliente_id_cliente` (`cliente_id_cliente`),
  ADD KEY `fk_produto_fornecedor` (`Fornecedor_id_fornecedor`),
  ADD KEY `fk_produto_pedido` (`Pedido_id_pedido`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id_produto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `fk_funcionario` FOREIGN KEY (`funcionario_id_funcionario`) REFERENCES `funcionario` (`id_funcionario`);

--
-- Restrições para tabelas `distribuidora`
--
ALTER TABLE `distribuidora`
  ADD CONSTRAINT `fk_produto_id_produto` FOREIGN KEY (`produto_id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pedido_produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id_produto`) ON DELETE CASCADE;

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `fk_cliente_id_cliente` FOREIGN KEY (`cliente_id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `fk_produto_cliente` FOREIGN KEY (`cliente_id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `fk_produto_fornecedor` FOREIGN KEY (`Fornecedor_id_fornecedor`) REFERENCES `fornecedor` (`id_fornecedor`),
  ADD CONSTRAINT `fk_produto_pedido` FOREIGN KEY (`Pedido_id_pedido`) REFERENCES `pedido` (`id_pedido`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
