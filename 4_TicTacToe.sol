// SPDX-License-Identifier: GPL-3.0

// Version
pragma solidity >=0.7.0 <0.9.0;

import "./3_1_Achievement.sol";
import "./4_Moneda.sol";

// Contrato
contract TicTacToe {

    struct Partida {
        address jugador1;
        address jugador2;
        address ganador;
        uint[4][4] jugadas;
        address ultimoTurno;
    }

    Partida[] partidas; 
    mapping(address => uint) partidasGanadas;
    Achievement achievement;
    Moneda moneda;

    // Constructor
    constructor(address contratoAchievement, address contratoMoneda) {
        achievement = Achievement(contratoAchievement);
        moneda = Moneda(contratoMoneda);
    }


    // Funciones
    function crearPartida(address jug1, address jug2) public returns(uint) {
        require(jug1 != jug2);
        uint idPartida = partidas.length;
        Partida memory partida;
        partida.jugador1 = jug1;
        partida.jugador2 = jug2;
        partidas.push(partida);
        return idPartida;
    }

    function jugar(uint idPartida, uint horizontal, uint vertical) public {
        // Validaciones
        Partida memory partida = partidas[idPartida];
        require(msg.sender == partida.jugador1 || msg.sender == partida.jugador2);
        require(horizontal > 0 && horizontal < 4);
        require(vertical > 0 && vertical < 4);
        require(msg.sender != partida.ultimoTurno);
        require(partida.jugadas[horizontal][vertical] == 0);
        require(! partidaTerminada(partida));

        // Guardar la jugada 
        guardarMovimiento(idPartida, horizontal, vertical);
        partida = partidas[idPartida];

        // Chequear si hay un ganador o si la grilla esta llena
        uint ganador = obtenerGanador(partida);
        guardarGanador(ganador, idPartida);

        partidas[idPartida].ultimoTurno = msg.sender;
    }

    function guardarGanador(uint ganador, uint idPartida) private {
        if (ganador != 0) {
            if (ganador == 1) partidas[idPartida].ganador = partidas[idPartida].jugador1;
            else partidas[idPartida].ganador = partidas[idPartida].jugador2;

            partidasGanadas[partidas[idPartida].ganador]++;
            if (partidasGanadas[partidas[idPartida].ganador] == 5) {
                achievement.emitir(partidas[idPartida].ganador);
            }

            if (achievement.balanceOf(partidas[idPartida].ganador) > 0) {
                moneda.emitir(2, partidas[idPartida].ganador);
            }
            else {
                moneda.emitir(1, partidas[idPartida].ganador);
            }
        }
    }

    function chequearLinea(uint[4][4] memory jugadas, uint x1,uint y1,uint x2,uint y2,uint x3,uint y3) private pure returns(uint) {
        if ((jugadas[x1][y1] == jugadas[x2][y2]) && (jugadas[x2][y2] == jugadas[x3][y3]))
            return jugadas[x1][y1];
        return 0;
    }

    function obtenerGanador(Partida memory partida) private pure returns(uint) {
        // Check diag \
        uint ganador = chequearLinea(partida.jugadas,1,1,2,2,3,3);
        // Check diag /
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 3,1,2,2,1,3);
        // Check cols |
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 1,1,1,2,1,3);
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 2,1,2,2,2,3);
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 3,1,3,2,3,3);
        // Check rows -
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 1,1,2,1,3,1);
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 1,2,2,2,3,2);
        if (ganador == 0) ganador = chequearLinea(partida.jugadas, 1,3,2,3,3,3);

        return ganador;
    }

    function guardarMovimiento(uint idPartida, uint h, uint v) private {
        if (msg.sender == partidas[idPartida].jugador1) partidas[idPartida].jugadas[h][v] = 1;
        else partidas[idPartida].jugadas[h][v] = 2;
    }

    function partidaTerminada(Partida memory partida) private pure returns(bool) {
        if (partida.ganador != address(0)) return true;

        for(uint x=1; x<4; x++) {
            for(uint y=1; y < 4; y++) {
                if (partida.jugadas[x][y] == 0) return false;
            }
        }

        return true;
    }

    // Modificadores

}
