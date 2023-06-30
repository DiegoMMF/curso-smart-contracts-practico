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
    }

    Partida[] partidas; 

    // Constructor

    // Funciones
    function crearPartida(address jug1, address jug2) public returns(uint) {

    }

    function jugar(uint idPartida, uint horizontal, uint vertical) public {
        // Validaciones

        // Guardar la jugada 

        // Chequear si hay un ganador o si la grilla esta llena
    }

    // Modificadores

}