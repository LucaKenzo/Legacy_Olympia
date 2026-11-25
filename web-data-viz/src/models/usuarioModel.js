var database = require("../database/config");

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL - function autenticar(): ", email, senha);
    var instrucaoSql = `
        SELECT id, nome, email FROM usuario WHERE email = '${email}' AND senha = '${senha}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrar(nome, email, senha, peso) {
    console.log("ACESSEI O USUARIO MODEL - function cadastrar():", nome, email, senha, peso);

    var instrucaoSql = `
        INSERT INTO usuario (nome, email, senha, peso, dataTreino)
        VALUES ('${nome}', '${email}', '${senha}', ${peso}, CURDATE());
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    autenticar,
    cadastrar
};