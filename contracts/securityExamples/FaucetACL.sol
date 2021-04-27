// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract FaucetACL {
  
  // Let the contract store its creator address
  address payable owner;

  // This function terminates the contract and should be invoked only by the owner
  function terminate() public {
    // Requirement: who calls this function has to be the owner of the contract
    require(msg.sender == owner);

    // Avoids funds to be locked forever. Sends all of the contract balance to specified address.
    selfdestruct(owner);
  }

  constructor() {
    owner = payable(msg.sender);
  }

  // Accept any incoming amount of ether
  receive() external payable {}

  // Anyone can ask this contract to give out
  // "withdraw_amount" to the specified "_to" address
  function withdraw (address payable _to, uint withdraw_amount) public {
    // Limit withdrawal amount (in ether)
    require(withdraw_amount <= 0.1 ether);

    // Send the amount to the specified address
    _to.transfer(withdraw_amount);
  }
}