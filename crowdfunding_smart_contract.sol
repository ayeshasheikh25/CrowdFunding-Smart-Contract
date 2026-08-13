// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;

contract crowdfunding_smart_contract{
    address public owner;
    uint public targetAmount;
    uint public deadline;
    uint public minimumContribution;
    uint public totalRaised;
    mapping(address=>uint) public contributions;
    mapping(address=>bool) public refunds;
    bool public withdrawn;
    constructor(){
        owner = msg.sender;
        targetAmount = 5 ether;
        deadline = block.timestamp +1 minutes;
        minimumContribution = 0.01 ether;
    }

    function contribute() public payable {
        require(msg.value>=minimumContribution,"Minimum Contribution is 0.01 ether");
        require(block.timestamp < deadline,"Deadline has passed");
        contributions[msg.sender] += msg.value;
        totalRaised+=msg.value;
       
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
       require(deadline < block.timestamp,"Deadline has not reached yet");
       require(totalRaised >= targetAmount, "target is not completed yet");
       require(!withdrawn, "Already withdrawn");
       (bool success, ) = owner.call{value: address(this).balance}("");
       require(success, "Transaction failed");
       withdrawn = true;
    }
    function refund() public{
        require(deadline < block.timestamp, "Deadline has not finished yet");
        require(targetAmount > totalRaised, "Target already achieved");
        require(refunds[msg.sender] != true, "Refund already claimed");
        require(contributions[msg.sender] != 0, "No contribution found");
        refunds[msg.sender] = true;
        address user = msg.sender;
        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        (bool success,) = user.call{value: amount}("");
        require(success, "Transaction failed");
    }

    function checkGoalReached() public view returns(bool){
         if(totalRaised >= targetAmount){
            return true;
         }
         return false;
    }
}
