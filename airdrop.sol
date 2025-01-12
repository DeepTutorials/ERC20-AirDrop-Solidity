// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Airdrop is IERC20 {  
    address public owner;
    IERC20 public tokenContract;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(_allowances[sender][msg.sender] >= amount, "Allowance exceeded");
        _allowances[sender][msg.sender] -= amount;
        _transfer(sender, recipient, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender] >= amount, "Balance too low");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function airdrop(address[] calldata recipients, uint256 amount) external onlyOwner {
        uint256 totalAmount = amount * recipients.length;
        require(_balances[owner] >= totalAmount, "Not enough tokens for airdrop");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(tokenContract.transfer(recipients[i], amount), "Token transfer failed");
        }
    }

    receive() external payable {}

    // Neue Funktion zum Ändern der Token-Daten
    function updateTokenDetails(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _tokenContract,
        uint256 _newTotalSupply
    ) external onlyOwner {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        tokenContract = IERC20(_tokenContract);
        _totalSupply = _newTotalSupply * 10 ** uint256(_decimals);
        _balances[owner] = _totalSupply;
    }
}
/*
                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)
*/
