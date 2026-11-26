var database = require("../database/config");

function listarFichasModelo() {
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
            e.descricao AS descricaoExercicio,
            e.musculo AS musculo,
            e.equipamento AS equipamento
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        WHERE f.fkUsuario IS NULL
        ORDER BY f.id ASC, t.id ASC, e.id ASC;
    `;
    return database.executar(instrucaoSql);
}

function buscarFichaModeloPorId(idFichaModelo) {
    var instrucaoSql = `
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
        WHERE f.id = ${idFichaModelo}
        ORDER BY t.id ASC, e.id ASC;
    `;
    return database.executar(instrucaoSql);
}

function desativarFichasUsuario(idUsuario) {
    var instrucaoSql = `
        UPDATE ficha SET status = 0 WHERE fkUsuario = ${idUsuario};
    `;
    return database.executar(instrucaoSql);
}

function cadastrarFicha(idUsuario, objetivo, titulo, descricao) {
    var instrucaoSql = `
        INSERT INTO ficha (objetivo, fkUsuario, titulo, descricao, status)
        VALUES ('${objetivo}', ${idUsuario}, '${titulo}', '${descricao}', 1);
    `;
    return database.executar(instrucaoSql);
}

function cadastrarTreino(titulo, observacao, fkFicha) {
    var instrucaoSql = `
        INSERT INTO treino (titulo, observacao, fkFicha)
        VALUES ('${titulo}', '${observacao}', ${fkFicha});
    `;
    return database.executar(instrucaoSql);
}

function cadastrarExerciciosEmLote(valoresSql) {
    var instrucaoSql = `
        INSERT INTO exercicio (nome, descricao, musculo, fkTreino, equipamento)
        VALUES ${valoresSql};
    `;
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
            e.descricao AS descricaoExercicio,
            e.musculo AS musculo,
            e.equipamento AS equipamento
        FROM ficha f
        JOIN treino t ON t.fkFicha = f.id
        JOIN exercicio e ON e.fkTreino = t.id
        WHERE f.fkUsuario = ${idUsuario} AND f.status = 1
        ORDER BY t.id ASC, e.id ASC;
    `;
    return database.executar(instrucaoSql);
}

function registrarSerie(fkExercicio, tempoDescanso, repeticoes, cargaRealizada) {
    var instrucaoSql = `
        INSERT INTO serie (tempoDescanso, repeticoes, cargaRealizada, fkExercicio)
        VALUES ('${tempoDescanso}', ${repeticoes}, ${cargaRealizada}, ${fkExercicio});
    `;
    return database.executar(instrucaoSql);
}

function buscarFichaUsuarioPorTitulo(idUsuario, titulo) {
    var instrucaoSql = `
        SELECT id FROM ficha 
        WHERE fkUsuario = ${idUsuario} AND titulo = '${titulo}' 
        LIMIT 1;
    `;
    return database.executar(instrucaoSql);
}

function ativarFichaExistente(idFicha) {
    var instrucaoSql = `
        UPDATE ficha SET status = 1 WHERE id = ${idFicha};
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    listarFichasModelo,
    buscarFichaModeloPorId,
    desativarFichasUsuario,
    cadastrarFicha,
    cadastrarTreino,
    cadastrarExerciciosEmLote,
    buscarFichaAtiva,
    registrarSerie,
    buscarFichaUsuarioPorTitulo,
    ativarFichaExistente
};