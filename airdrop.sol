// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Airdrop {
    address public owner;
    IERC20 public token;
    uint256 public totalSupply;
    string public tokenName;
    string public tokenSymbol;
    uint8 public tokenDecimals;
    
    mapping(address => uint256) public airdropAmounts;

    event AirdropInitiated(address indexed recipient, uint256 amount);
    event AirdropCompleted(address indexed recipient, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor(address _tokenAddress, string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
        owner = msg.sender;
        token = IERC20(_tokenAddress);
        tokenName = _name;
        tokenSymbol = _symbol;
        tokenDecimals = _decimals;
        totalSupply = _totalSupply;
    }

    // Set Airdrop Amount for Address
    function setAirdropAmount(address _recipient, uint256 _amount) external onlyOwner {
        airdropAmounts[_recipient] = _amount;
    }

    // Execute Airdrop for a list of addresses
    function executeAirdrop(address[] calldata _recipients) external onlyOwner {
        for (uint256 i = 0; i < _recipients.length; i++) {
            address recipient = _recipients[i];
            uint256 amount = airdropAmounts[recipient];
            require(amount > 0, "No airdrop amount set for this address");

            bool success = token.transfer(recipient, amount);
            require(success, "Transfer failed");
            
            emit AirdropCompleted(recipient, amount);
        }
    }

    // Helper function to withdraw tokens in case of emergency
    function withdrawTokens(address _to, uint256 _amount) external onlyOwner {
        bool success = token.transfer(_to, _amount);
        require(success, "Withdraw failed");
    }

    // Fallback function to accept ETH in case the contract needs it
    receive() external payable {}
}
/*
                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
