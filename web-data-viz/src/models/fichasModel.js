var database = require("../database/config");

function desativarFichasUsuario(idUsuario) {
    var instrucaoSql = `
        UPDATE ficha SET status = 0 WHERE fkUsuario = ${idUsuario};
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrarFicha(idUsuario, objetivo, titulo, descricao) {
    var instrucaoSql = `
        INSERT INTO ficha (objetivo, fkUsuario, titulo, descricao, status)
        VALUES ('${objetivo}', ${idUsuario}, '${titulo}', '${descricao}', 1);
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrarTreino(titulo, observacao, fkFicha) {
    var instrucaoSql = `
        INSERT INTO treino (titulo, observacao, fkFicha)
        VALUES ('${titulo}', '${observacao}', ${fkFicha});
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrarExerciciosEmLote(valoresSql) {
    var instrucaoSql = `
        INSERT INTO exercicio (nome, descricao, musculo, fkTreino, equipamento)
        VALUES ${valoresSql};
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarFichaAtiva(idUsuario) {
    var instrucaoSql = `
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
            e.musculo AS musculo,
            e.equipamento AS equipamento
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        WHERE f.fkUsuario = ${idUsuario} AND f.status = 1
        ORDER BY t.id ASC, e.id ASC;
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function registrarSerie(fkExercicio, tempoDescanso, repeticoes, cargaRealizada) {
    var instrucaoSql = `
        INSERT INTO serie (tempoDescanso, repeticoes, cargaRealizada, fkExercicio)
        VALUES ('${tempoDescanso}', ${repeticoes}, ${cargaRealizada}, ${fkExercicio});
    `;
    console.log("Executando SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    desativarFichasUsuario,
    cadastrarFicha,
    cadastrarTreino,
    cadastrarExerciciosEmLote,
    buscarFichaAtiva,
    registrarSerie
};