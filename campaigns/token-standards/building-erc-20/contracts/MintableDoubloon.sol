// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Doubloon.sol";

contract MintableDoubloon is Doubloon {
    address public creator;

    constructor(uint256 _supply) Doubloon(_supply) {
        creator = msg.sender;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can mint tokens");
        _; //it means mint will execute after the require from above. 
    }

    function mint(address _to, uint256 _amount) external onlyCreator {
        totalSupply += _amount;
        balanceOf[_to] += _amount;

        emit Transfer(address(0), _to, _amount);
    }
    // external onlyCreator assures mint will only be used by the creator outside the chain 

}
