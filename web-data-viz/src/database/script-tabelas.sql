CREATE DATABASE legacyOlympia;
USE legacyOlympia;

CREATE TABLE usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    peso DECIMAL(5,2) NULL,
    dataTreino DATE NULL,
    CONSTRAINT chkEmail CHECK (email LIKE '%@%.%')
);
select * from usuario;

CREATE TABLE ficha (
    id INT PRIMARY KEY AUTO_INCREMENT,
    objetivo VARCHAR(45),
    fkUsuario INT NULL,
    titulo VARCHAR(45) NOT NULL,
    descricao VARCHAR(255),
    status TINYINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chkobjetivo CHECK (objetivo IN (
        'Peito','Costas','Pernas','Braços','Ombros','Abdômen','Corpo todo'
    )),
    CONSTRAINT fichaUsuario FOREIGN KEY (fkUsuario) REFERENCES usuario(id)
);

CREATE TABLE treino (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(45) NOT NULL,
    observacao VARCHAR(255),
    fkFicha INT NOT NULL,
    CONSTRAINT treinoFicha FOREIGN KEY (fkFicha) REFERENCES ficha(id)
);

CREATE TABLE exercicio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    descricao VARCHAR(255),
    musculo VARCHAR(45) NOT NULL,
    fkTreino INT NOT NULL,
    equipamento VARCHAR(75),

    CONSTRAINT chkMusculo CHECK (
        musculo IN ('Peito','Costas','Lombar','Trapezio','Biceps','Triceps',
                                'Ombro','Antebraço','Abdominal','Abdutor','Adutor','Quadriceps',
                                'Posterior','Panturrilha','Gluteo','Tibia')
    ),
    CONSTRAINT chkEquipamento CHECK (equipamento IN ('Halteres','Maquina','Barra','Rolinho','Colchonete', 'Elastico', '')),
    CONSTRAINT fkExercicioTreino FOREIGN KEY (fkTreino) REFERENCES treino(id)
);

CREATE TABLE serie (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tempoDescanso TIME NOT NULL,
    repeticoes INT NOT NULL,
    cargaRealizada DECIMAL(4,1) NOT NULL,
    serieRealizada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fkExercicio INT NOT NULL,

    CONSTRAINT fkSerieExercicio FOREIGN KEY (fkExercicio) REFERENCES exercicio(id)
);

-- --------------------------------------------------------------------------------


-- INSERT INTO usuario (nome, email, senha, peso, dataTreino) VALUES
-- ('Guilherme', 'gui@gmail.com', '123', 78.5, '2025-01-10'),
-- ('Ana', 'ana@gmail.com', '123', 62.3, '2025-01-11'),
-- ('Carlos', 'carlos@gmail.com', '123', 85.0, '2025-01-12');

USE legacyOlympia;

-- Permite fichas modelo sem usuário vinculado (fkUsuario = NULL)
ALTER TABLE ficha DROP PRIMARY KEY, ADD PRIMARY KEY (id);
ALTER TABLE ficha MODIFY COLUMN fkUsuario INT NULL;

-- Insere as 3 fichas modelo
INSERT INTO ficha (id, objetivo, fkUsuario, titulo, descricao, status) VALUES
(1, 'Corpo todo', NULL, 'ABC', 'Hipertrofia clássica • 3 dias / semana', 0),
(2, 'Peito', NULL, 'UPPER / LOWER', 'Força e volume • 4 dias / semana', 0),
(3, 'Corpo todo', NULL, 'FULL BODY', 'Base bem construída • 3 dias / semana', 0);

-- Insere os treinos de cada ficha
INSERT INTO treino (id, titulo, observacao, fkFicha) VALUES
(1, 'A · Empurrar', 'Peito, ombros e tríceps • aprox. 60 min', 1),
(2, 'B · Puxar', 'Costas e bíceps • aprox. 55 min', 1),
(3, 'C · Pernas', 'Pernas e abdômen • aprox. 60 min', 1),
(4, 'A · Superiores', 'Superiores — força • aprox. 60 min', 2),
(5, 'B · Inferiores', 'Inferiores — força • aprox. 60 min', 2),
(6, 'A · Corpo inteiro', 'Corpo inteiro — base • aprox. 45 min', 3),
(7, 'B · Corpo inteiro', 'Corpo inteiro — controle • aprox. 45 min', 3);

-- Insere os exercícios de cada treino
INSERT INTO exercicio (nome, descricao, musculo, fkTreino, equipamento) VALUES
('Supino reto com barra', '4 séries · 8-10 reps', 'Peito', 1, 'Barra'),
('Supino inclinado com halteres', '3 séries · 10-12 reps', 'Peito', 1, 'Halteres'),
('Crucifixo com halteres', '3 séries · 12-15 reps', 'Peito', 1, 'Halteres'),
('Desenvolvimento com halteres', '3 séries · 10-12 reps', 'Ombro', 1, 'Halteres'),
('Elevação lateral', '3 séries · 12-15 reps', 'Ombro', 1, 'Halteres'),
('Tríceps na corda', '3 séries · 12-15 reps', 'Triceps', 1, 'Maquina'),

('Puxada aberta na polia', '4 séries · 10-12 reps', 'Costas', 2, 'Maquina'),
('Remada curvada com barra', '4 séries · 8-10 reps', 'Costas', 2, 'Barra'),
('Rosca direta com barra', '3 séries · 10-12 reps', 'Biceps', 2, 'Barra'),
('Rosca alternada', '3 séries · 12 reps', 'Biceps', 2, 'Halteres'),

('Agachamento livre', '4 séries · 8-10 reps', 'Quadriceps', 3, 'Barra'),
('Cadeira extensora', '4 séries · 12-15 reps', 'Quadriceps', 3, 'Maquina'),
('Mesa flexora', '4 séries · 12 reps', 'Posterior', 3, 'Maquina'),
('Abdominal supra', '3 séries · 15 reps', 'Abdominal', 3, 'Colchonete'),

('Supino reto com barra', '4 séries · 6-8 reps', 'Peito', 4, 'Barra'),
('Remada baixa', '4 séries · 8-10 reps', 'Costas', 4, 'Maquina'),
('Desenvolvimento com barra', '4 séries · 8-10 reps', 'Ombro', 4, 'Barra'),
('Tríceps testa', '4 séries · 10 reps', 'Triceps', 4, 'Barra'),

('Agachamento livre', '4 séries · 6-8 reps', 'Quadriceps', 5, 'Barra'),
('Stiff com barra', '4 séries · 8-10 reps', 'Posterior', 5, 'Barra'),
('Leg Press 45', '4 séries · 10-12 reps', 'Quadriceps', 5, 'Maquina'),
('Panturrilha em pé', '4 séries · 15 reps', 'Panturrilha', 5, 'Maquina'),

('Supino reto', '3 séries · 12 reps', 'Peito', 6, 'Barra'),
('Puxada aberta', '3 séries · 12 reps', 'Costas', 6, 'Maquina'),
('Leg Press 45', '3 séries · 12 reps', 'Quadriceps', 6, 'Maquina'),
('Prancha abdominal', '3 séries · 30s', 'Abdominal', 6, 'Colchonete'),

('Desenvolvimento com halteres', '3 séries · 12 reps', 'Ombro', 7, 'Halteres'),
('Mesa flexora', '3 séries · 12 reps', 'Posterior', 7, 'Maquina'),
('Rosca direta', '3 séries · 12 reps', 'Biceps', 7, 'Barra'),
('Tríceps corda', '3 séries · 12 reps', 'Triceps', 7, 'Maquina');

-- Conferência: precisa retornar 30 linhas no terminal do MySQL
SELECT f.id, f.titulo, t.titulo AS treino, e.nome AS exercicio
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.fkUsuario IS NULL;
-- -----------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------- INSERTS , SELECTS , UPDATES , DELETES ----------------------------------------------------------------------------

-- Observação : selects serão feitos em blocos por tabela seguindo a seguinte estrutura
-- usuario -> ficha -> treino -> exercicio -> serie
-- Ordem de comandos DML : INSERT , SELECT , UPDATE , DELETES 
-- --------------------------------------------------------------------------------	usuario ------------------------------------------------------------------------------------------

        SELECT id, nome, email FROM usuario WHERE email = email AND senha = senha;



        SELECT DISTINCT
         u.id AS idUsuario,
         u.email AS email,
         u.senha AS senha,
		 f.id AS idFicha,
         t.id AS idTreino
      FROM usuario AS u
       JOIN ficha AS f
	  ON f.fkUsuario = u.id
       JOIN treino AS t
      ON t.fkFicha = f.id
	  WHERE email = 'gui@gmail.com' AND senha = '123';
      
      SELECT id AS idUsuario, nome, email FROM usuario WHERE email = 'gui@gmail.com' AND senha = '123';


SELECT * FROM usuario;

SELECT * FROM usuario WHERE email = 'ju@gmail.com' AND senha ='123';








SELECT * FROM usuario WHERE email = 'gui@gmail.com' AND senha = '123';

-- ------------------------------------------------ FICHAS ---------------------------------------------------------------------------------------------------------------





-- Conta quantas fichas o usuario tem no total
SELECT u.nome AS 'Nome do usuario',
         COUNT(f.titulo)  AS 'Quantidade de fichas'
        FROM usuario AS u
        JOIN ficha AS f
        ON f.fkUsuario = u.id
        WHERE u.id = 1
        GROUP BY u.nome; -- Apenas nos campos que não tem operação matematica
        
   -- lista todas as fichas que o usuario tem     
  SELECT u.nome AS 'Nome do usuario',
        f.objetivo AS objetivo,
        f.titulo AS titufloFicha,
        f.status AS status,
        f.created_at AS dataCriacao
        FROM usuario AS u
        JOIN ficha AS f
        ON f.fkUsuario = u.id
        WHERE u.id = 1;
        

        
        SELECT f.*,
			  u.id AS idUsuariio
        FROM usuario AS u
        JOIN ficha AS f
        ON u.id = f.fkUsuario
        WHERE u.id = 1;
        
        
        
        UPDATE ficha SET status = 1
			WHERE id = 4;
            
		UPDATE ficha AS f SET status = 0
		WHERE id <> 1 AND (SELECT id FROM usuario WHERE id = 1);
	

        SELECT 
         u.nome AS nome,
         t.titulo AS tituloTreino
      FROM usuario AS u
      JOIN ficha AS f
	  ON f.fkUsuario = u.id
      JOIN treino AS t
      ON t.fkFicha = f.id
        WHERE f.id = 1 AND f.status  = 1;
        
        -- ELECIONA A FICHA EM ESPECIFICO
  SELECT * FROM ficha WHERE id = 1;
  
  
  
   UPDATE ficha SET status = 1 WHERE id =  1;

-- -------------------------------------------------------------------------------------TREINOS ------------------------------------------------------------------------------------------------
  SELECT COUNT(f.id) AS temFicha
        FROM usuario AS u
		JOIN ficha AS f
        ON f.fkUsuario = u.id
      WHERE u.id =6;


-- Treino 1 

  SELECT 
	    t.*
        FROM ficha AS f
        JOIN treino AS t
        ON t.fkFicha = f.id
        JOIN usuario AS u
        ON f.fkUsuario = u.id
        WHERE u.id = 1 AND f.status = 1
        GROUP BY t.id, t.titulo;

        
	SELECT
    t.titulo AS treino,
		e.*
		FROM ficha AS f
        JOIN treino AS t
        ON t.fkFicha = f.id
        JOIN usuario AS u
        ON f.fkUsuario = u.id
        JOIN exercicio AS e
        ON e.fkTreino = t.id
        WHERE f.status = 1 AND u.id = 1;
        
SELECT
       t.titulo AS treino,
		e.musculo AS musculo,
		e.nome AS nomeExercicio,
        e.equipamento AS equipamento
	FROM ficha AS f
	JOIN treino AS t
	 ON t.fkFicha = f.id
	JOIN usuario AS u
	 ON f.fkUsuario = u.id
	JOIN exercicio AS e
	 ON e.fkTreino = t.id
	    WHERE f.status = 1 AND u.id = 1 AND t.id = 3;
        
        
		
        
        
    SELECT 
    t.id,
    t.titulo,
    COUNT(e.id) AS totalExercicios
	FROM treino t
    LEFT JOIN exercicio e 
    ON t.id = e.fkTreino
    WHERE t.fkFicha = 1
GROUP BY t.id, t.titulo;


       SELECT 
       f.status AS statusFicha,
	   f.id AS idFicha,
       t.id AS idTreino,
       t.titulo AS titulo
        FROM ficha AS f
        JOIN treino AS t ON t.fkFicha = f.id
        JOIN exercicio AS e ON e.fkTreino = t.id
        WHERE f.id = 1 AND f.status  = 1;

   
   
   
   
       
    -- Deleto todas as series relacionadas aos exercicios do treino 1 
  DELETE FROM serie WHERE fkExercicio IN (SELECT id FROM exercicio WHERE fkTreino = 3);
       -- Deleto todas os exercicios relacionadas ao treino  1 
   DELETE FROM exercicio WHERE fkTreino IN (SELECT id FROM treino WHERE fkTreino = 3);
   DELETE FROM treino WHERE id = 3;


   
   -- ---------------------------------------------------------------------------Exercicios -------------------------------------------------------------------------------------------------------
   
   SELECT * FROM  serie WHERE fkExercicio IN (SELECT id FROM exercicio WHERE id = 7);
   SELECT * FROM exercicio WHERE id = 34;
   SELECT * FROM serie WHERE fkExercicio = 34;
   
   
  -- DELETE FROM serie WHERE fkExercicio = 45;
   
   
   
        
-- exercicios do 
  SELECT 
		f.titulo AS 'Nome Fiacha',
        t.titulo,
		e.*
        FROM ficha AS f
        JOIN treino AS t
        ON t.fkFicha = f.id
        JOIN usuario AS u
        ON f.fkUsuario = u.id
        JOIN exercicio AS e
        ON e.fkTreino = t.id
        WHERE t.id = 9;
        
	SELECT 
		e.musculo AS musculo,
		e.nome AS nomeExercicio,
        e.equipamento AS equipamento,
        e.musculo AS musculo
        FROM treino AS t
        JOIN exercicio AS e
        ON e.fkTreino = t.id
        WHERE t.id = 9;
        
        
        
           
   DELETE FROM serie WHERE fkExercicio IN (SELECT id FROM exercicio WHERE id = 40);
   DELETE FROM exercicio WHERE id = 40;
        DELETE FROM exercicio WHERE id = 46;
        
        

        
        
	



  SELECT u.nome AS 'Nome do usuario',
         f.* 
        FROM usuario AS u
        JOIN ficha AS f
        ON f.fkUsuario = u.id
        WHERE u.id = 1 AND MAX(f.id);
        
-- ------------------------------------------------------------------------------------------------------------- SERIES ----------------------------------------------------------------------------------------


SELECT 
	week( serieRealizada , 1) AS Semanas,
    COUNT(id) AS serieRealizada
    FROM serie
		WHERE serieRealizada BETWEEN '2025/01/01' AND '2025/02/01'
   GROUP BY week(serieRealizada , 1)    
   ORDER BY week(serieRealizada , 1);

SELECT * FROM serie WHERE fkExercicio = 4;        
        
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.titulo , COUNT(*) FROM ficha AS f WHERE fkUsuario = 1 GROUP BY f.titulo;
SELECT * FROM treino WHERE id= 3;
SELECT * FROM treino WHERE id= 2;

-- FOCO NO USER 1
SELECT * FROM usuario;
SELECT * FROM ficha;
SELECT * FROM treino;
SELECT * FROM exercicio;
SELECT * FROM serie;
