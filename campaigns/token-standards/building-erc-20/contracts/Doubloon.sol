// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC20.sol";

/**
 * @dev ERC-20 token contract.
 */
contract Doubloon is IERC20  {
    string public constant name = "Doubloon";
    string public constant symbol = "DBL";
    uint256 public totalSupply;
    // adding a mapping (a python dictionary) with every address and the current balance of tokens
    mapping(address => uint256) public balanceOf;
    // nested mapping to keeping track of approvals
    mapping(address => mapping(address => uint256)) public allowance; // Amount of doubloons _spender can transfer on behalf of _owner.

    constructor(uint256 _supply) {
        totalSupply = _supply;
        balanceOf[msg.sender] = _supply; // assigning the initial total supply to the contract creator
    }

    //getters are implicit declared since the "atributtes" are public
    //the totalSupply getter is implicitly declared as well receiving the key in the parameter:  
    /* 
        function balanceOf(address _account) external view returns (uint256) {
            return balanceOf[_account];
        }   
    */ 

    //the allowance getter is implicitly declared as well receiving the key address of the owner and the address of the spender:  
    /* 

        function allowance(address _owner, address _spender) external view returns (uint256) {
            return allowance[_owner][_spender];
        }
    */ 

    // DIRECT TOKEN TRANSFERS
    function transfer(address _to, uint256 _amount) external returns (bool) {
        require(balanceOf[msg.sender] >= _amount, "Insufficient funds");

        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);

        return true;
    }

    //APPROVED TOKEN TRANSFERS (Approve from the sender to the spender)
    function approve(address _spender, uint256 _amount) external returns (bool) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    // function transferFrom with approval from the sender
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool) {
        require(balanceOf[_from] >= _amount, "Insufficient funds"); // same in transfer
        // if the amount of doubloons msg.sender can transfer on behalf of _from is <= _amount then "Insufficient allowance".
        require(allowance[_from][msg.sender] >= _amount, "Insufficient allowance");
        
        allowance[_from][msg.sender] -= _amount; // decrease the amount of doubloons msg.sender can transfer on behalf of _from

        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }

}