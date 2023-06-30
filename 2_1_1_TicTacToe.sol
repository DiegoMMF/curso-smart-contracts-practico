// SPDX-License-Identifier: GPL-3.0

// Version
pragma solidity >=0.7.0 <0.9.0;

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

    // Constructor



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
        require(! partidaTerminada(partida));

        // Guardar la jugada 

        // Chequear si hay un ganador o si la grilla esta llena

        partidas[idPartida].ultimoTurno = msg.sender;
    }

    function partidaTerminada(Partida memory partida) private returns(bool) {
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
