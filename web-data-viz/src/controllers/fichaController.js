var fichaModel = require("../models/fichasModel");

function listarCatalogo(req, res) {
    fichaModel.listarFichasModelo()
        .then(function (resultado) {
            res.status(200).json(resultado);
        })
        .catch(function (erro) {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}

function montarValoresExercicios(listaExercicios, idTreino) {
    var partes = [];
    for (var i = 0; i < listaExercicios.length; i++) {
        var ex = listaExercicios[i];
        partes.push(`('${ex.nome}', '${ex.descricao}', '${ex.musculo}', ${idTreino}, '${ex.equipamento}')`);
    }
    return partes.join(", ");
}

function salvarTreinosEmSequencia(treinos, indice, idFicha) {
    if (indice >= treinos.length) {
        return Promise.resolve();
    }

    var treinoAtual = treinos[indice];
    return fichaModel.cadastrarTreino(treinoAtual.titulo, treinoAtual.observacao, idFicha)
        .then(function (resultadoTreino) {
            var valores = montarValoresExercicios(treinoAtual.exercicios, resultadoTreino.insertId);
            return fichaModel.cadastrarExerciciosEmLote(valores);
        })
        .then(function () {
            return salvarTreinosEmSequencia(treinos, indice + 1, idFicha);
        });
}

function escolherFicha(req, res) {
    var idUsuario = req.body.idUsuarioServer;
    var idFichaModelo = req.body.idFichaModeloServer;

    if (idUsuario == undefined || idFichaModelo == undefined) {
        res.status(400).send("Dados incompletos para ativar a ficha!");
        return;
    }

    fichaModel.buscarFichaModeloPorId(idFichaModelo)
        .then(function (linhas) {
            if (linhas.length === 0) {
                res.status(404).send("Ficha modelo não encontrada no banco.");
                return;
            }

            var titulo = linhas[0].tituloFicha;
            var objetivo = linhas[0].objetivoFicha;
            var descricao = linhas[0].descricaoFicha;
            var treinos = [];

            for (var i = 0; i < linhas.length; i++) {
                var item = linhas[i];
                var treinoEncontrado = null;

                for (var t = 0; t < treinos.length; t++) {
                    if (treinos[t].idOriginal === item.idTreino) {
                        treinoEncontrado = treinos[t];
                        break;
                    }
                }

                if (!treinoEncontrado) {
                    treinoEncontrado = {
                        idOriginal: item.idTreino,
                        titulo: item.tituloTreino,
                        observacao: item.observacaoTreino,
                        exercicios: []
                    };
                    treinos.push(treinoEncontrado);
                }

                treinoEncontrado.exercicios.push({
                    nome: item.nomeExercicio,
                    descricao: item.descricaoExercicio,
                    musculo: item.musculo,
                    equipamento: item.equipamento
                });
            }

            return fichaModel.desativarFichasUsuario(idUsuario)
                .then(function () {
                    return fichaModel.cadastrarFicha(idUsuario, objetivo, titulo, descricao);
                })
                .then(function (resultadoFicha) {
                    return salvarTreinosEmSequencia(treinos, 0, resultadoFicha.insertId);
                })
                .then(function () {
                    res.status(201).json({ mensagem: "Ficha ativada com sucesso!" });
                });
        })
        .catch(function (erro) {
            console.log(erro);
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
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    listarCatalogo,
    escolherFicha,
    buscarAtiva,
    registrarSerie
};