var express = require("express");
var router = express.Router();

var fichaController = require("../controllers/fichaController");

router.get("/catalogo", function (req, res) {
    fichaController.listarCatalogo(req, res);
});

router.post("/escolher", function (req, res) {
    fichaController.escolherFicha(req, res);
});

router.get("/ativa/:idUsuario", function (req, res) {
    fichaController.buscarAtiva(req, res);
});

router.post("/registrar-serie", function (req, res) {
    fichaController.registrarSerie(req, res);
});

module.exports = router;