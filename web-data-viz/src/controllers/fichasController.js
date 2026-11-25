var fichaModel = require("../models/fichasModel");

function montarValoresExercicios(listaExercicios, idTreino) {
    var partes = [];
    for (var i = 0; i < listaExercicios.length; i++) {
        var ex = listaExercicios[i];
        partes.push(`('${ex.nome}', '${ex.descricao}', '${ex.musculo}', ${idTreino}, '${ex.equipamento}')`);
    }
    return partes.join(", ");
}

function escolherFicha(req, res) {
    var idUsuario = req.body.idUsuarioServer;
    var titulo = req.body.tituloServer;
    var objetivo = req.body.objetivoServer;
    var descricao = req.body.descricaoServer;
    var treinos = req.body.treinosServer;

    if (idUsuario == undefined || titulo == undefined || treinos == undefined || treinos.length == 0) {
        res.status(400).send("Dados incompletos para ativar a ficha!");
        return;
    }

    // 1. Desativa fichas antigas do usuário
    fichaModel.desativarFichasUsuario(idUsuario)
        .then(function () {
            // 2. Cria a nova ficha como ativa (status = 1)
            return fichaModel.cadastrarFicha(idUsuario, objetivo, titulo, descricao);
        })
        .then(function (resultadoFicha) {
            var idFichaCriada = resultadoFicha.insertId;
            var treinoA = treinos[0];

            // 3. Cria o Treino A e seus exercícios
            return fichaModel.cadastrarTreino(treinoA.titulo, treinoA.observacao, idFichaCriada)
                .then(function (resultadoTreinoA) {
                    var valoresA = montarValoresExercicios(treinoA.exercicios, resultadoTreinoA.insertId);
                    return fichaModel.cadastrarExerciciosEmLote(valoresA);
                })
                .then(function () {
                    // 4. Se houver Treino B, cria o Treino B e seus exercícios
                    if (treinos.length > 1) {
                        var treinoB = treinos[1];
                        return fichaModel.cadastrarTreino(treinoB.titulo, treinoB.observacao, idFichaCriada)
                            .then(function (resultadoTreinoB) {
                                var valoresB = montarValoresExercicios(treinoB.exercicios, resultadoTreinoB.insertId);
                                return fichaModel.cadastrarExerciciosEmLote(valoresB);
                            });
                    }
                });
        })
        .then(function () {
            res.status(201).json({ mensagem: "Ficha ativada com sucesso!" });
        })
        .catch(function (erro) {
            console.log(erro);
            console.log("\nErro ao ativar ficha: ", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

function buscarAtiva(req, res) {
    var idUsuario = req.params.idUsuario;

    if (idUsuario == undefined) {
        res.status(400).send("idUsuario está undefined!");
        return;
    }

    fichaModel.buscarFichaAtiva(idUsuario)
        .then(function (resultado) {
            res.status(200).json(resultado);
        })
        .catch(function (erro) {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}

function registrarSerie(req, res) {
    var fkExercicio = req.body.fkExercicioServer;
    var tempoDescanso = req.body.tempoDescansoServer;
    var repeticoes = req.body.repeticoesServer;
    var cargaRealizada = req.body.cargaRealizadaServer;

    if (fkExercicio == undefined || repeticoes == undefined || cargaRealizada == undefined) {
        res.status(400).send("Preencha todos os dados da série!");
        return;
    }

    fichaModel.registrarSerie(fkExercicio, tempoDescanso, repeticoes, cargaRealizada)
        .then(function (resultado) {
            res.status(201).json(resultado);
        })
        .catch(function (erro) {
            console.log(erro);
            console.log("\nErro ao registrar série: ", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    escolherFicha,
    buscarAtiva,
    registrarSerie
};