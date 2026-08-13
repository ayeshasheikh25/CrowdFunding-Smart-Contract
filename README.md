# Crowdfunding Smart Contract

A decentralized **Crowdfunding Smart Contract** built with **Solidity** that allows multiple users to contribute Ether toward a predefined funding target.

The contract includes a minimum contribution requirement, a funding deadline, owner withdrawal when the target is successfully reached, and refunds for contributors when the target is not achieved.

## Features

**Ether Contributions**

  * Users can contribute Ether to the crowdfunding campaign.
  * Each contribution is stored against the contributor's address.

**Funding Target**

  * The campaign has a predefined target amount of **5 Ether**.
  * The owner can withdraw funds only when the target is reached.

**Deadline**

  * The campaign has a predefined deadline.
  * Contributions are accepted only before the deadline.

**Minimum Contribution**

  * Users must contribute at least **0.01 Ether**.

**Owner Withdrawal**

  * Only the contract owner can withdraw the collected funds.
  * Withdrawal is allowed only after the deadline.
  * The target amount must be reached before withdrawal.

**Refund System**

  * If the funding target is not achieved before the deadline, contributors can request refunds.
  * Each contributor can claim their refund only once.

**Withdrawal Protection**

  * The owner cannot withdraw the funds more than once.

## Technologies Used

* **Solidity ^0.8.34**
* **Ethereum / EVM**
* **Remix IDE**
* **Ether**
* **Smart Contracts**
* **Mappings**
* **Payable Functions**
* **Blockchain Transactions**

## Contract Variables

The contract maintains the following important variables:

```solidity 
address public owner;
uint public targetAmount;
uint public deadline;
uint public minimumContribution;
uint public totalRaised;
```

| Variable              | Purpose                                       |
| --------------------- | --------------------------------------------- |
| `owner`               | Stores the address that deployed the contract |
| `targetAmount`        | Required funding target                       |
| `deadline`            | Time at which the campaign ends               |
| `minimumContribution` | Minimum amount a user can contribute          |
| `totalRaised`         | Total Ether contributed                       |

The contract also uses two mappings:

```solidity
mapping(address => uint) public contributions;
mapping(address => bool) public refunds;
```

`contributions` stores the amount contributed by each address, while `refunds` keeps track of whether a contributor has already claimed their refund.

## rowdfunding Configuration

The constructor initializes the campaign:

```solidity
constructor() {
    owner = msg.sender;
    targetAmount = 5 ether;
    deadline = block.timestamp + 1 minutes;
    minimumContribution = 0.01 ether;
}
```

### Default Configuration

```text 
Target Amount       -> 5 ETH
Minimum Contribution -> 0.01 ETH
Campaign Duration    -> 1 minute
Owner                -> Contract deployer
```

The **1-minute deadline** is mainly useful for testing the contract in Remix. For a real crowdfunding application, the deadline would normally be much longer.

## contributing

Users can contribute through:

```solidity
function contribute() public payable
```

Before accepting a contribution, the contract checks:

```solidity 
require(
    msg.value >= minimumContribution,
    "Minimum Contribution is 0.01 ether"
);

require(
    block.timestamp < deadline,
    "Deadline has passed"
);
```

If both conditions are satisfied, the contribution is recorded:

```solidity 
contributions[msg.sender] += msg.value;
totalRaised += msg.value;
```

This means a user can make multiple contributions, and their amounts are added together.

## Checking Contract Balance

The current balance of the crowdfunding contract can be checked using:

```solidity
function getBalance() public view returns (uint)
```

It returns:

```solidity
address(this).balance
```

which represents the Ether currently held by the smart contract.

## Owner Withdrawal

After the deadline, the owner can call:

```solidity
function withdraw() public
```

The function checks that:

1. The caller is the owner.
2. The deadline has passed.
3. The funding target has been reached.
4. The owner has not already withdrawn.

The main conditions are:

```solidity
require(msg.sender == owner, "Only owner can withdraw");
require(deadline < block.timestamp, "Deadline has not reached yet");
require(totalRaised >= targetAmount, "target is not completed yet");
require(!withdrawn, "Already withdrawn");
```

If all conditions are satisfied, the contract balance is transferred to the owner.

## Refund Mechanism

If the campaign fails to reach its target, contributors can request their money back using:

```solidity
function refund() public
```

A refund is allowed only when:

```text 
Deadline has passed
        ↓
Target was NOT reached
        ↓
Contributor has contributed
        ↓
Contributor has NOT already claimed refund
```

The contract then transfers the contributor's original contribution back to them.

Before transferring the funds, the contribution is reset:

```solidity 
contributions[msg.sender] = 0;
```

This helps prevent the same contribution from being refunded repeatedly.

## Checking Whether the Goal Was Reached

The contract provides:

```solidity 
function checkGoalReached() public view returns(bool)
```

It returns:

```text 
true  → Target amount has been reached
false → Target amount has not been reached
```

The condition is:

```solidity
totalRaised >= targetAmount
```

## Testing with Remix IDE

### Step 1: Open Remix

Open Remix IDE and create a new Solidity file:

```text
Crowdfunding.sol
```

### Step 2: Add the Contract

Copy the crowdfunding smart contract into the file.

### Step 3: Compile

Select Solidity compiler version:

```text
0.8.34
```

Then compile the contract.

### Step 4: Deploy

Go to **Deploy & Run Transactions** and deploy the contract.

The account that deploys the contract becomes the owner.

### Step 5: Contribute

Use one or more accounts to call:

```text
contribute()
```

and send at least:

```text
0.01 ETH
```

### Step 6: Check Funding

Use:

```text
totalRaised()
```

to see how much has been collected.

You can also use:

```text
getBalance()
```

to check the Ether currently held by the contract.

### Step 7: Wait for the Deadline

The contract uses a **1-minute deadline** for testing.

After the deadline:

#### If target is reached:

The owner can call:

```text
withdraw()
```

#### If target is not reached:

Contributors can call:

```text
refund()
```

to receive their contributions back.

## Project Structure

```text 
Crowdfunding-Smart-Contract/
│
├── crowdfunding.sol
└── README.md
```

## Learning Objectives

This project was created to practice:

* Solidity smart contract development
* Crowdfunding logic
* `payable` functions
* Ether transfers
* `msg.sender`
* `msg.value`
* `block.timestamp`
* Solidity mappings
* Access control
* Withdrawal logic
* Refund mechanisms
* Contract balance management
* Boolean state tracking
* Smart contract testing using Remix IDE

## Note

This project is intended for **learning and educational purposes**. It should be thoroughly tested and professionally audited before being used with real funds or deployed to a production blockchain.

## License

This project is licensed under the **MIT License**.
