// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract FaucetPushvsPull {
  
  // Let the contract store its creator address
  address payable owner;

  // This function terminates the contract and should be invoked only by the owner
  function terminate() public {
    // Requirement: who calls this function has to be the owner of the contract
    require(msg.sender == owner);

    // Avoids funds to be locked forever. Sends all of the contract balance to specified address.
    selfdestruct(owner);
  }

  // A key-value array of (address, amount) pairs
  mapping (address => uint) pendingWithdrawals;

  constructor() {
    owner = payable(msg.sender);
  }

  // Accept any incoming amount of ether
  receive() external payable {}

  // The withdrawal logic is splitted into two functions:
  // request() and withdraw()
  function request (uint withdraw_amount) public {
    require(withdraw_amount <= 0.1 ether);
    pendingWithdrawals[msg.sender] = withdraw_amount;
  }

  // Now the user can initiate the withdrawal
  function withdraw () public {
    uint amount = pendingWithdrawals[msg.sender];

    // Remembering to zero-out the balance BEFORE
    // transferring the amount, in order to prevent
    // a re-entrancy attack
    pendingWithdrawals[msg.sender] = 0;

    // The current reccomended method to use when sending Ether
    (bool sent, bytes memory data) = payable(msg.sender).call{value: amount}("");
    
    // Check that the transfer has succeeded
    require(sent, "Failed to sent Ether");
  }
}