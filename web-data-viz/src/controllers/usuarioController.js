var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está indefinida!");
    } else {
        usuarioModel.autenticar(email, senha)
            .then(function (resultadoAutenticar) {
                console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);

                if (resultadoAutenticar.length == 1) {
                    res.json({
                        id: resultadoAutenticar[0].id,
                        email: resultadoAutenticar[0].email,
                        nome: resultadoAutenticar[0].nome
                    });
                } else if (resultadoAutenticar.length == 0) {
                    res.status(403).send("Email e/ou senha inválido(s)");
                } else {
                    res.status(403).send("Mais de um usuário com o mesmo login e senha!");
                }
            })
            .catch(function (erro) {
                console.log(erro);
                console.log("\nHouve um erro ao realizar o login! Erro: ", erro.sqlMessage);
                res.status(500).json(erro.sqlMessage);
            });
    }
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var email = req.body.emailServer;
    var peso = req.body.pesoServer;
    var senha = req.body.senhaServer;

    if (nome == undefined || nome.trim() === "") {
        res.status(400).send("Seu nome está undefined!");
    } else if (email == undefined || email.trim() === "") {
        res.status(400).send("Seu email está undefined!");
    } else if (peso == undefined || peso <= 0) {
        res.status(400).send("Seu peso está inválido!");
    } else if (senha == undefined || senha.trim() === "") {
        res.status(400).send("Sua senha está undefined!");
    } else {
        usuarioModel.cadastrar(nome.trim(), email.trim(), senha, peso)
            .then(function (resultado) {
                res.status(201).json(resultado);
            })
            .catch(function (erro) {
                console.log(erro);
                console.log("\nHouve um erro ao realizar o cadastro! Erro: ", erro.sqlMessage);

                if (erro.code === "ER_DUP_ENTRY") {
                    res.status(409).send("Este e-mail já está cadastrado!");
                } else {
                    res.status(500).json(erro.sqlMessage);
                }
            });
    }
}

module.exports = {
    autenticar,
    cadastrar
};