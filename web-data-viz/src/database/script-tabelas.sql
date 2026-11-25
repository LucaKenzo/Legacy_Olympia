CREATE DATABASE legacyOlympia;
USE legacyOlympia;
drop database legacyolympia;

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
    fkUsuario INT NOT NULL,
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




--       INSERT INTO ficha (objetivo, fkUsuario, titulo, descricao, status)
-- VALUES
-- ('Peito', 1, 'Hipertrofia A', 'Bloco de peito e braço', 1),
-- ('Costas', 2, 'Hipertrofia B', 'Treino de costas e bíceps', 1),
-- ('Quadriceps', 3, 'Hipertrofia C', 'Treino de perna completo', 1);

	
      

-- -- Ficha 1
-- INSERT INTO treino (titulo, observacao, fkFicha) VALUES
-- ('Peito e Tríceps', 'Carga moderada', 1),
-- ('Costas e Bíceps', 'Foco em execução', 1),
-- ('Perna', 'Intenso', 1);

-- -- Ficha 2
-- INSERT INTO treino (titulo, observacao, fkFicha) VALUES
-- ('Costas e Bíceps', 'Volume alto', 2),
-- ('Peito e Ombro', 'Alongamento antes', 2),
-- ('Perna', 'Desafio', 2);

-- -- Ficha 3
-- INSERT INTO treino (titulo, observacao, fkFicha) VALUES
-- ('Perna Completa', 'Foco em quadríceps', 3),
-- ('Posterior e Glúteo', 'Amplitude total', 3),
-- ('Panturrilha + Abdômen', 'Alta repetição', 3);




-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Supino Reto', 'Peito', 1, 'Barra'),
-- ('Crucifixo', 'Peito', 1, 'Halteres'),
-- ('Tríceps Corda', 'Triceps', 1, 'Maquina'),
-- ('Tríceps Testa', 'Triceps', 1, 'Barra');

-- -- Treino 2
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Puxada Aberta', 'Costas', 2, 'Maquina'),
-- ('Remada Baixa', 'Costas', 2, 'Maquina'),
-- ('Rosca Direta', 'Biceps', 2, 'Barra'),
-- ('Rosca Alternada', 'Biceps', 2, 'Halteres');

-- -- Treino 3
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Agachamento Livre', 'Quadriceps', 3, 'Barra'),
-- ('Leg Press', 'Quadriceps', 3, 'Maquina'),
-- ('Mesa Flexora', 'Posterior', 3, 'Maquina'),
-- ('Panturrilha Sentado', 'Panturrilha', 3, 'Maquina');

-- -- Treino 4
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Barra Fixa', 'Costas', 4, 'Barra'),
-- ('Serrote', 'Costas', 4, 'Halteres'),
-- ('Rosca Martelo', 'Biceps', 4, 'Halteres'),
-- ('Rosca Scott', 'Biceps', 4, 'Maquina');

-- -- Treino 5
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Supino Inclinado', 'Peito', 5, 'Barra'),
-- ('Voador', 'Peito', 5, 'Maquina'),
-- ('Elevação Lateral', 'Ombro', 5, 'Halteres'),
-- ('Desenvolvimento', 'Ombro', 5, 'Barra');

-- -- Treino 6
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Agachamento Hack', 'Quadriceps', 6, 'Maquina'),
-- ('Cadeira Extensora', 'Quadriceps', 6, 'Maquina'),
-- ('Stiff', 'Posterior', 6, 'Barra'),
-- ('Panturrilha em Pé', 'Panturrilha', 6, 'Maquina');

-- -- Treino 7
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Agachamento Livre', 'Quadriceps', 7, 'Barra'),
-- ('Avanço', 'Quadriceps', 7, 'Halteres'),
-- ('Mesa Flexora', 'Posterior', 7, 'Maquina'),
-- ('Extensora', 'Quadriceps', 7, 'Maquina');

-- -- Treino 8
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Stiff', 'Posterior', 8, 'Barra'),
-- ('Glúteo Máquina', 'Gluteo', 8, 'Maquina'),
-- ('Abdutora', 'Abdutor', 8, 'Maquina'),
-- ('Abdutora Invertida', 'Adutor', 8, 'Maquina');

-- -- Treino 9
-- INSERT INTO exercicio (nome, musculo, fkTreino, equipamento)
-- VALUES
-- ('Panturrilha Sentado', 'Panturrilha', 9, 'Maquina'),
-- ('Panturrilha em Pé', 'Panturrilha', 9, 'Maquina'),
-- ('Abdominal Infra', 'Abdominal', 9, 'Colchonete'),
-- ('Prancha', 'Abdominal', 9, 'Colchonete');

	
  
--       INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada)
-- SELECT id, '00:01:00', 12, 40.0 FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada)
-- SELECT id, '00:01:20', 10, 45.0 FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada)
-- SELECT id, '00:01:30', 8, 50.0 FROM exercicio;





-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:00', 12, 30.0, '2025-01-05 10:00:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:00', 10, 35.0, '2025-01-05 10:05:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:00', 8, 40.0, '2025-01-05 10:10:00'
-- FROM exercicio;



-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:10', 12, 32.5, '2025-01-12 10:00:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:10', 10, 37.5, '2025-01-12 10:05:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:10', 8, 42.5, '2025-01-12 10:10:00'
-- FROM exercicio;




-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:20', 12, 35.0, '2025-01-19 10:00:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:20', 10, 40.0, '2025-01-19 10:05:00'
-- FROM exercicio;

-- INSERT INTO serie (fkExercicio, tempoDescanso, repeticoes, cargaRealizada, serieRealizada)
-- SELECT id, '00:01:20', 8, 45.0, '2025-01-19 10:10:00';


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
