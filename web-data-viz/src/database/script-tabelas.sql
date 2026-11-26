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

-- Conferência (precisa retornar exatamente 30 linhas)
SELECT f.id, f.titulo, t.titulo AS treino, e.nome AS exercicio
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.fkUsuario IS NULL;

USE legacyOlympia;

-- ============================================================================
-- 1. FICHAS, TREINOS E EXERCÍCIOS (fichasModel.js)
-- ============================================================================

-- Conferência resumida do catálogo de fichas modelo (deve retornar 30 linhas)
SELECT 
    f.id, 
    f.titulo, 
    t.titulo AS treino, 
    e.nome AS exercicio
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.fkUsuario IS NULL;

-- Lista todas as fichas modelo disponíveis no catálogo (fkUsuario IS NULL)
SELECT 
    f.id AS idFicha,
    f.titulo AS tituloFicha,
    f.objetivo AS objetivoFicha,
    f.descricao AS descricaoFicha,
    t.id AS idTreino,
    t.titulo AS tituloTreino,
    t.observacao AS observacaoTreino,
    e.id AS idExercicio,
    e.nome AS nomeExercicio,
    e.descricao AS descricaoExercicio,
    e.musculo AS musculo,
    e.equipamento AS equipamento
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.fkUsuario IS NULL
ORDER BY f.id ASC, t.id ASC, e.id ASC;

-- Busca uma ficha modelo específica pelo ID para clonar para o usuário
SELECT 
    f.id AS idFicha,
    f.titulo AS tituloFicha,
    f.objetivo AS objetivoFicha,
    f.descricao AS descricaoFicha,
    t.id AS idTreino,
    t.titulo AS tituloTreino,
    t.observacao AS observacaoTreino,
    e.nome AS nomeExercicio,
    e.descricao AS descricaoExercicio,
    e.musculo AS musculo,
    e.equipamento AS equipamento
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.id = 1
ORDER BY t.id ASC, e.id ASC;

-- Busca a ficha ativa (status = 1) com todos os treinos e exercícios do usuário
SELECT 
    f.id AS idFicha,
    f.titulo AS tituloFicha,
    f.objetivo AS objetivoFicha,
    f.descricao AS descricaoFicha,
    t.id AS idTreino,
    t.titulo AS tituloTreino,
    t.observacao AS observacaoTreino,
    e.id AS idExercicio,
    e.nome AS nomeExercicio,
    e.descricao AS descricaoExercicio,
    e.musculo AS musculo,
    e.equipamento AS equipamento
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
WHERE f.fkUsuario = 1 AND f.status = 1
ORDER BY t.id ASC, e.id ASC;

-- ============================================================================
-- 2. DASHBOARD E MÉTRICAS DE DESEMPENHO (dashboardModel.js)
-- ============================================================================

-- KPIs principais: total de fichas, ficha ativa, séries, volume total e maior carga
SELECT 
    (SELECT COUNT(*) FROM ficha WHERE fkUsuario = 1) AS totalFichas,
    (SELECT titulo FROM ficha WHERE fkUsuario = 1 AND status = 1 LIMIT 1) AS fichaAtiva,
    COUNT(s.id) AS totalSeries,
    IFNULL(ROUND(SUM(s.cargaRealizada * s.repeticoes), 1), 0) AS volumeTotal,
    IFNULL(ROUND(MAX(s.cargaRealizada), 1), 0) AS maiorCarga
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
JOIN serie s ON s.fkExercicio = e.id
WHERE f.fkUsuario = 1;

-- Gráfico de linha: progressão das últimas 15 séries registradas em ordem cronológica
SELECT * FROM (
    SELECT 
        s.id AS idSerie,
        e.nome AS exercicio,
        DATE_FORMAT(s.serieRealizada, '%d/%m %H:%i') AS momento,
        s.cargaRealizada AS carga,
        s.repeticoes AS repeticoes
    FROM ficha f
    JOIN treino t ON t.fkFicha = f.id
    JOIN exercicio e ON e.fkTreino = t.id
    JOIN serie s ON s.fkExercicio = e.id
    WHERE f.fkUsuario = 1
    ORDER BY s.id DESC
    LIMIT 15
) AS ultimas
ORDER BY idSerie ASC;

-- Gráfico de rosca: distribuição de séries e média de carga por grupo muscular
SELECT 
    e.musculo AS musculo,
    COUNT(s.id) AS totalSeries,
    IFNULL(ROUND(AVG(s.cargaRealizada), 1), 0) AS mediaCarga
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
JOIN serie s ON s.fkExercicio = e.id
WHERE f.fkUsuario = 1
GROUP BY e.musculo
ORDER BY totalSeries DESC;

-- Gráfico de barras (opcional): total de séries realizadas por semana
SELECT 
    CONCAT('Semana ', WEEK(s.serieRealizada, 1)) AS semana,
    YEARWEEK(s.serieRealizada, 1) AS anoSemana,
    COUNT(s.id) AS totalSeries
FROM ficha f
JOIN treino t ON t.fkFicha = f.id
JOIN exercicio e ON e.fkTreino = t.id
JOIN serie s ON s.fkExercicio = e.id
WHERE f.fkUsuario = 1
GROUP BY anoSemana, semana
ORDER BY anoSemana ASC
LIMIT 8;