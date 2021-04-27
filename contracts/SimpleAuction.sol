// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleAuction {
  address payable public beneficiary;
  uint public auctionEndTime;
  address public higerBidder;
  uint public higerBid;
  mapping(address => uint) pendingReturns;
  bool hasEnded;
  
  event HiBidIncreased(address bidder, uint amount);
  event AuctionEnded(address winner, uint amount);


  constructor(uint _biddingTime, address payable _benef) {
    beneficiary = _benef;
    auctionEndTime = block.timestamp + _biddingTime;
  }
  
  function bid() public payable {
    require(block.timestamp <= auctionEndTime, "Auction has ended.");
    require(msg.value > higerBid, "Bid not high enough.");
    if (higerBid != 0) {
      pendingReturns[higerBidder] += higerBid;
    }
    higerBidder = msg.sender;
    higerBid = msg.value;
    emit HiBidIncreased(msg.sender, msg.value);
  }
  
  function withdraw() public returns (bool) {
    uint amount = pendingReturns[msg.sender];
    if (amount > 0) {
      pendingReturns[msg.sender] = 0;
      (bool res, bytes memory data) = payable(msg.sender).call{value: amount}("");
      if(!res) {
        pendingReturns[msg.sender] = amount;
        return false;
      }
    }
    return true;
  }
  
  function auctionEnd() public {
    require(block.timestamp >= auctionEndTime, "Auction active");
    require(!hasEnded, "auctionEnd already called.");
    hasEnded = true;
    emit AuctionEnded(higerBidder, higerBid);
    beneficiary.transfer(higerBid);
    }
  }