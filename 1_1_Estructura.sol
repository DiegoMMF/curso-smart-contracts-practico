// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ContadorVisitas {

    uint public visitas;
    address implementador;

    constructor(uint valorInicial) {
        visitas = valorInicial;
        implementador = msg.sender;
    }

    function incrementarVisitas() soloImplementador public {
        visitas++;
    }

    modifier soloImplementador() {
        require(msg.sender == implementador, "La cuenta no implemento el contrato.");
        _;
    }

}