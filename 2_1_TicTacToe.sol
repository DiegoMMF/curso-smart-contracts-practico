pragma solidity >=0.8.2 <0.9.0;

contract TicTacToe {

    struct Partida {
        uint[4][4] jugada;
        address jugador1;
        address jugador2;
        address ganador;
        address ultimoJugador;
    }

    Partida[] partidas;

    function crearPartida(address jugador1, address jugador2) public returns(uint) {
        require(jugador1 != jugador2);
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
        require(msg.sender != partidas[idPartida].ultimoJugador);

        // Guardar jugada del usuario
        guardarJugada(idPartida,horizontal,vertical);

        // Chequear si termina la partida y guardar ganador
        uint hayGanador = validarGanador(partidas[idPartida].jugada);
        guardarGanador(hayGanador,idPartida);

        partidas[idPartida].ultimoJugador = msg.sender;
    }

    function partidaTerminada(uint idPartida) public view returns (bool) {
        require(partidas.length > idPartida);

        // Chequear casilleros vacios
        for (uint x = 1; x < 4; x++) {
            for (uint y = 1; y < 4; y++) {
                if (partidas[idPartida].jugada[x][y] == 0) {
                    // Hay casilleros vacios entonces me fijo si ya hay ganador
                    return (partidas[idPartida].ganador != address(0));
                }
            }
        }

        // No hay casilleros vacios
        return true;
    }

    function guardarJugada(uint idPartida, uint horizontal, uint vertical) private {
        require(partidas[idPartida].jugada[horizontal][vertical] == 0);
        if (msg.sender == partidas[idPartida].jugador1) partidas[idPartida].jugada[horizontal][vertical] = 1;
        else partidas[idPartida].jugada[horizontal][vertical] = 2;
    }

    function chequearLinea(uint[4][4] memory jugada, uint x1, uint y1, uint x2, uint y2, uint x3, uint y3) private pure returns(uint) {
        if ((jugada[x1][y1] == jugada[x2][y2]) && (jugada[x2][y2] == jugada[x3][y3])) {
            return jugada[x1][y1];
        }
        return 0;
    }

    function validarGanador(uint[4][4] memory jugada) private pure returns(uint) {
        // Check diag \
        uint winner = chequearLinea(jugada, 1,1,2,2,3,3);
        // Check diag /
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 3,1,2,2,1,3);
        // Check cols |
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 1,1,1,2,1,3);
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 2,1,2,2,2,3);
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 3,1,3,2,3,3);
        // Check rows -
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 1,1,2,1,3,1);
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 1,2,2,2,3,2);
        if (ganador != 0) ganador = chequearLinea(partida.jugadas, 1,3,2,3,3,3);
        return ganador;
    }

    function guardarGanador(uint idGanador, uint idPartida) private {
        if (idGanador > 0) {
            if (idGanador == 1) partidas[idPartida].ganador = partidas[idPartida].jugador1;
            else partidas[idPartida].ganador = partidas[idPartida].jugador2;
        }
    }

    function verGanador(uint idPartida) public view returns(address) {
        return partidas[idPartida].ganador;
    }
}


