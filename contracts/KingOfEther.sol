// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract TheKingOfEther {

  struct Monarch {
    address etherAddress;
    string name;
    uint claimPrice;
    uint coronationTimestamp;
  }

  address public wizard;
  uint constant startingClaimPrice = 0.1 ether;
  uint public currentClaimPrice;
  Monarch public currentKing;
  Monarch[] public pastKings;
  mapping (address => uint) refunds;
  
  event ThroneClaimed(string usurperName,uint newClaimPrice);
  
  constructor() {
    wizard = msg.sender;
    currentClaimPrice = startingClaimPrice;
    currentKing = Monarch(wizard,"[Vacant]",0,block.timestamp);
  }

  function claimThrone(string memory _name) public payable {
    require(msg.value >= currentClaimPrice);
    uint payment = msg.value;
    if(msg.value > currentClaimPrice) {
      uint excess = payment - currentClaimPrice;
      refunds[msg.sender] += excess;
      payment = payment - excess;
      //This is cleanup
    }
    uint wizardCompensation = payment / 50;
    refunds[wizard] += wizardCompensation;
    uint diff = payment - wizardCompensation;
    refunds[currentKing.etherAddress] += diff;
    
    pastKings.push(currentKing);
    currentKing = Monarch(msg.sender, _name, payment, block.timestamp);
    currentClaimPrice *= 150;
    currentClaimPrice /= 100;
    emit ThroneClaimed(currentKing.name, currentClaimPrice);
    }
}