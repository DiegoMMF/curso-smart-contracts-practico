// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ViewsCounter {

    uint public views;
    address implementer;

    constructor(uint initialValue) {
        views = initialValue;
        implementer = msg.sender;
    }

    function incrementarVisitas() onlyImplementer public /* accesible from outside the contract */ {
        views++;
    }

    modifier onlyImplementer() { // Access restriction modifier (like a middleware)
        require(msg.sender == implementer, "Account didn't implemented the contract"); // If the condition is not met, the function will not be executed
        _;
    }

}