var database = require("../database/config");

function buscarKpis(idUsuario) {
    var instrucaoSql = `
        SELECT 
            (SELECT COUNT(*) FROM ficha WHERE fkUsuario = ${idUsuario}) AS totalFichas,
            (SELECT titulo FROM ficha WHERE fkUsuario = ${idUsuario} AND status = 1 LIMIT 1) AS fichaAtiva,
            COUNT(s.id) AS totalSeries,
            IFNULL(ROUND(SUM(s.cargaRealizada * s.repeticoes), 1), 0) AS volumeTotal,
            IFNULL(ROUND(MAX(s.cargaRealizada), 1), 0) AS maiorCarga
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        JOIN serie s ON s.fkExercicio = e.id
        WHERE f.fkUsuario = ${idUsuario};
    `;
    return database.executar(instrucaoSql);
}

function buscarSeriesPorSemana(idUsuario) {
    var instrucaoSql = `
        SELECT 
            CONCAT('Semana ', WEEK(s.serieRealizada, 1)) AS semana,
            YEARWEEK(s.serieRealizada, 1) AS anoSemana,
            COUNT(s.id) AS totalSeries
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        JOIN serie s ON s.fkExercicio = e.id
        WHERE f.fkUsuario = ${idUsuario}
        GROUP BY anoSemana, semana
        ORDER BY anoSemana ASC
        LIMIT 8;
    `;
    return database.executar(instrucaoSql);
}

function buscarDistribuicaoMuscular(idUsuario) {
    var instrucaoSql = `
        SELECT 
            e.musculo AS musculo,
            COUNT(s.id) AS totalSeries,
            IFNULL(ROUND(AVG(s.cargaRealizada), 1), 0) AS mediaCarga
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        JOIN serie s ON s.fkExercicio = e.id
        WHERE f.fkUsuario = ${idUsuario}
        GROUP BY e.musculo
        ORDER BY totalSeries DESC;
    `;
    return database.executar(instrucaoSql);
}

function buscarEvolucaoCarga(idUsuario) {
    var instrucaoSql = `
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
            WHERE f.fkUsuario = ${idUsuario}
            ORDER BY s.id DESC
            LIMIT 15
        ) AS ultimas
        ORDER BY idSerie ASC;
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarKpis,
    buscarSeriesPorSemana,
    buscarDistribuicaoMuscular,
    buscarEvolucaoCarga
};