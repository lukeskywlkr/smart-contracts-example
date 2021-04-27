// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Mortal {
  address payable owner;
  constructor() {
    owner = payable(msg.sender);
  }

  function die() public {
    if (msg.sender == owner) selfdestruct(owner);
  }
}

contract Greeter is Mortal {
  string greeting_msg;

  constructor(string memory greeting) {
    greeting_msg = greeting;
  }

  function greet() public view returns (string memory) {
    return greeting_msg;
  }
}