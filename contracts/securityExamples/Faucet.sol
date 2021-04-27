// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
  // Accept any incoming amount of ether
  receive() external payable {}

  // Anyone can ask this contract to give out
  // "withdraw_amount" to the specified "_to" address
  function withdraw (address payable _to, uint withdraw_amount) public {
    // Limit withdrawal amount (in wei)
    require(withdraw_amount <= 100000000000000000);

    // Send the amount to the specified address
    _to.transfer(withdraw_amount);
  }
}