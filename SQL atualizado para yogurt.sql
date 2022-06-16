/*
 Descrição previa: Conjunto de comandos SQL para o projeto de encerramento de curso do programa jovem programador.
*/

--/** DROP **\--

SET foreign_key_checks=off;
DROP TABLE clowto23_Jovem_Programador.Usuario;
DROP TABLE clowto23_Jovem_Programador.Perfil;
DROP TABLE clowto23_Jovem_Programador.Resposta;
DROP TABLE clowto23_Jovem_Programador.Arquivo;
DROP TABLE clowto23_Jovem_Programador.Publicacao;
DROP TABLE clowto23_Jovem_Programador.Estado;
DROP TABLE clowto23_Jovem_Programador.Cidade;
DROP TABLE clowto23_Jovem_Programador.Amizade;
DROP TABLE clowto23_Jovem_Programador.Categoria;
DROP TABLE clowto23_Jovem_Programador.Comentarios;
DROP TABLE clowto23_Jovem_Programador.Compartilhamento;
DROP TABLE clowto23_Jovem_Programador.Conectividade;
DROP TABLE clowto23_Jovem_Programador.Comunidade;
DROP TABLE clowto23_Jovem_Programador.Conectar;
SET foreign_key_checks=on;

--<-------------------->--

--/** CREATE **\--

CREATE TABLE Usuario (
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
Username VARCHAR(50) NOT NULL UNIQUE,
Email  VARCHAR(255) NOT NULL UNIQUE,
Password  VARCHAR(4000) NOT NULL,
Telefone VARCHAR(20) NULL,
Token VARCHAR(400) NULL
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_usuario
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
END
;;


CREATE TABLE Estado (
Id INT PRIMARY KEY AUTO_INCREMENT,
Nome VARCHAR(750) NOT NULL,
Sigla CHAR(2) NOT NULL UNIQUE
);

CREATE TABLE Cidade (
Id INT PRIMARY KEY AUTO_INCREMENT,
Nome VARCHAR(750) NOT NULL,
IdEstado INT  NOT NULL,

FOREIGN KEY (IdEstado) REFERENCES Estado (Id)
);

CREATE TABLE Perfil (
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdUsuario CHAR(36) NOT NULL,
IdCidade INT NULL,
Nome VARCHAR(500) NOT NULL,
DataNascimento DATE NULL,
FotoPerfil BLOB NULL,
Biografia VARCHAR(4000) NULL,
Genero ENUM('H','M') NULL,
DataCriacao DATETIME NULL, 


FOREIGN KEY (IdUsuario) REFERENCES Usuario (Id) ON DELETE CASCADE,
FOREIGN KEY (IdCidade) REFERENCES Cidade (Id)
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_perfil
BEFORE INSERT ON Perfil
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Categoria (
Id INT PRIMARY KEY AUTO_INCREMENT,
Nome VARCHAR(200) NOT NULL,
Descricao VARCHAR(4000) NOT NULL
);

CREATE TABLE Comunidade (
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdCriador CHAR(36) NOT NULL,
IdCategoriaComunidade INT NULL,
Nome VARCHAR(300) NOT NULL,
Legenda varchar(500) NULL,
FotoComunidade BLOB NULL,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdCriador) REFERENCES Perfil (Id) ON DELETE CASCADE,
FOREIGN KEY (IdCategoriaComunidade) REFERENCES Categoria (Id) ON DELETE SET NULL
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_comunidade
BEFORE INSERT ON Comunidade
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Conectividade (
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPerfil CHAR(36) NOT NULL,
IdComunidade CHAR(36) NOT NULL,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdPerfil) REFERENCES Perfil (Id) ON DELETE CASCADE,
FOREIGN KEY (IdComunidade) REFERENCES Comunidade (Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_conectividade
BEFORE INSERT ON Conectividade
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Amizade (
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPerfil CHAR(36) NOT NULL,

FOREIGN KEY (IdPerfil) REFERENCES Perfil(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_amizade
BEFORE INSERT ON Amizade
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
END
;;

CREATE TABLE Conectar(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPerfil CHAR(36) NOT NULL,
IdAmizade CHAR(36) NOT NULL,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdPerfil) REFERENCES Perfil(Id) ON DELETE CASCADE,
FOREIGN KEY (IdAmizade) REFERENCES Amizade(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_conectar
BEFORE INSERT ON Conectar
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Publicacao(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPerfil CHAR(36) NOT NULL,
IdComunidade CHAR(36) NULL,
Legenda VARCHAR(255) NULL,
Curtidas int NOT NULL DEFAULT 0,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdPerfil) REFERENCES Perfil(Id) ON DELETE CASCADE,
FOREIGN KEY (IdComunidade) REFERENCES Comunidade(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_publicacao
BEFORE INSERT ON Publicacao
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Arquivo(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPublicacao CHAR(36) NOT NULL,
Conteudo BLOB NOT NULL,
MimeType VARCHAR(400) NULL,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdPublicacao) REFERENCES Publicacao(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_Arquivo
BEFORE INSERT ON Arquivo
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Compartilhamento(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPublicacao CHAR(36) NOT NULL,
IdPerfil CHAR(36) NOT NULL,
DataCompartilhamento DATETIME NULL, 

FOREIGN KEY (IdPerfil) REFERENCES Perfil(Id) ON DELETE CASCADE,
FOREIGN KEY (IdPublicacao) REFERENCES Publicacao(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_compartilhamento
BEFORE INSERT ON Compartilhamento
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCompartilhamento = sysdate();
END
;;

CREATE TABLE Comentarios(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdPublicacao CHAR(36) NULL,
IdCompartilhamento CHAR(36) NULL,
Legenda VARCHAR(255) NOT NULL,
Curtidas int NOT NULL DEFAULT 0,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdPublicacao) REFERENCES Publicacao(Id) ON DELETE CASCADE,
FOREIGN KEY (IdCompartilhamento) REFERENCES Compartilhamento(Id) ON DELETE CASCADE
);


DELIMITER ;;
CREATE TRIGGER antes_inserir_comentarios
BEFORE INSERT ON Comentarios
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

CREATE TABLE Resposta(
Id CHAR(36) PRIMARY KEY DEFAULT '00000000-0000-0000-0000-000000000000',
IdComentario CHAR(36) NOT NULL,
Legenda VARCHAR(200) NOT NULL,
DataCriacao DATETIME NULL, 

FOREIGN KEY (IdComentario) REFERENCES Comentarios(Id) ON DELETE CASCADE
);

DELIMITER ;;
CREATE TRIGGER antes_inserir_resposta
BEFORE INSERT ON Resposta
FOR EACH ROW
BEGIN
    SET new.Id = uuid();
    SET new.DataCriacao = sysdate();
END
;;

