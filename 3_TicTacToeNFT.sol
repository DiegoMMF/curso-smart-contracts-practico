// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./3_Achievement.sol";

contract TicTacToe {

    struct Partida {
        uint[][] jugada;
        address jugador1;
        address jugador2;
        address ganador;
    }

    Partida[] partidas;
    mapping(address => uint) cantidadGanadas;
    Achievement achievements;

    constructor(address contratoAchievements) {
        achievements = Achievement(contratoAchievements);
    }

    function crearPartida(address jugador1, address jugador2) public returns(uint) {
        uint idPartida = partidas.length;
        Partida memory partida;
        partida.jugador1 = jugador1;
        partida.jugador2 = jugador2;
        partidas.push(partida);
        return idPartida;
    }

    function jugar(uint idPartida, uint horizontal, uint vertical) public {
        require(! partidaTerminada(idPartida));
        require(horizontal > 0 && horizontal < 4);
        require(vertical > 0 && vertical < 4);
        require(msg.sender == partidas[idPartida].jugador1 || msg.sender == partidas[idPartida].jugador2);

        // Guardar jugada del usuario
        guardarJugada(idPartida,horizontal,vertical);

        // Chequear si termina la partida y guardar ganador
        uint hayGanador = validarGanador(idPartida);
        guardarGanador(hayGanador,idPartida);
    }

    function partidaTerminada(uint idPartida) public view returns (bool) {
        require(partidas.length > idPartida);

        // Hay algun casillero libre ?
        bool emptySlot = false;
        for (uint x = 1; x < 4; x++) {
            for (uint y = 1; y < 4; y++) {
                if (partidas[idPartida].jugada[x][y] == 0) {
                    emptySlot = true;
                }
            }
        }
        require(emptySlot);

        return (partidas[idPartida].ganador != address(0));
    }

    function guardarJugada(uint idPartida, uint horizontal, uint vertical) private {
        require(partidas[idPartida].jugada[horizontal][vertical] != 0);
        if (msg.sender == partidas[idPartida].jugador1) partidas[idPartida].jugada[horizontal][vertical] = 1;
        else partidas[idPartida].jugada[horizontal][vertical] = 2;
    }

    function validarGanador(uint idPartida) private view returns(uint) {
        // Check diag \
        if ((partidas[idPartida].jugada[1][1] == partidas[idPartida].jugada[2][2]) && (partidas[idPartida].jugada[2][2] == partidas[idPartida].jugada[3][3])) {
            return partidas[idPartida].jugada[1][1];
        }
        // Check diag /
        if ((partidas[idPartida].jugada[3][1] == partidas[idPartida].jugada[2][2]) && (partidas[idPartida].jugada[2][2] == partidas[idPartida].jugada[1][3])) {
            return partidas[idPartida].jugada[3][1];
        }
        // Check cols |
        if ((partidas[idPartida].jugada[1][1] == partidas[idPartida].jugada[1][2]) && (partidas[idPartida].jugada[1][2] == partidas[idPartida].jugada[1][3])) {
            return partidas[idPartida].jugada[1][1];
        }
        if ((partidas[idPartida].jugada[2][1] == partidas[idPartida].jugada[2][2]) && (partidas[idPartida].jugada[2][2] == partidas[idPartida].jugada[2][3])) {
            return partidas[idPartida].jugada[2][1];
        }
        if ((partidas[idPartida].jugada[3][1] == partidas[idPartida].jugada[3][2]) && (partidas[idPartida].jugada[3][2] == partidas[idPartida].jugada[3][3])) {
            return partidas[idPartida].jugada[3][1];
        }
        // Check rows -
        if ((partidas[idPartida].jugada[1][1] == partidas[idPartida].jugada[2][1]) && (partidas[idPartida].jugada[2][1] == partidas[idPartida].jugada[3][1])) {
            return partidas[idPartida].jugada[1][1];
        }
        if ((partidas[idPartida].jugada[1][2] == partidas[idPartida].jugada[2][2]) && (partidas[idPartida].jugada[2][2] == partidas[idPartida].jugada[3][2])) {
            return partidas[idPartida].jugada[1][2];
        }
        if ((partidas[idPartida].jugada[1][3] == partidas[idPartida].jugada[2][3]) && (partidas[idPartida].jugada[2][3] == partidas[idPartida].jugada[3][3])) {
            return partidas[idPartida].jugada[1][3];
        }
        return 0;
    }

    function guardarGanador(uint idGanador, uint idPartida) private {
        require(idGanador > 0);
        if (idGanador == 1) partidas[idPartida].ganador = partidas[idPartida].jugador1;
        else partidas[idPartida].ganador = partidas[idPartida].jugador2;
        cantidadGanadas[partidas[idPartida].ganador]++;
        if (cantidadGanadas[partidas[idPartida].ganador] == 5) {
            achievements.emitir(partidas[idPartida].ganador);
        }
    }
}