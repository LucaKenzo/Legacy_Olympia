var dashboardModel = require("../models/dashboardModel");

function obterDadosDashboard(req, res) {
    var idUsuario = req.params.idUsuario;

    if (idUsuario == undefined) {
        res.status(400).send("O idUsuario está undefined!");
        return;
    }

    Promise.all([
        dashboardModel.buscarKpis(idUsuario),
        dashboardModel.buscarSeriesPorSemana(idUsuario),
        dashboardModel.buscarDistribuicaoMuscular(idUsuario),
        dashboardModel.buscarEvolucaoCarga(idUsuario)
    ])
        .then(function ([kpis, seriesSemana, distribuicaoMuscular, evolucaoCarga]) {
            res.status(200).json({
                kpis: kpis[0] || {
                    totalFichas: 0,
                    fichaAtiva: "Nenhuma",
                    totalSeries: 0,
                    volumeTotal: 0,
                    maiorCarga: 0
                },
                seriesSemana: seriesSemana,
                distribuicaoMuscular: distribuicaoMuscular,
                evolucaoCarga: evolucaoCarga
            });
        })
        .catch(function (erro) {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    obterDadosDashboard
};