// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint amount) external returns (bool);
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

contract FlashLoanProvider {
    IERC20 public token;

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    // Function to execute a flash loan
    function flashLoan(uint amount, address borrower, bytes calldata data) external {
        uint balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= amount, "Not enough liquidity");

        // Send tokens to borrower
        token.transfer(borrower, amount);

        // Execute borrower’s logic
        (bool success, ) = borrower.call(data);
        require(success, "External call failed");

        // Ensure loan + fee repaid (for simplicity, no fee here)
        uint balanceAfter = token.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "Loan not repaid");

        // Flash loan successful
    }
}

contract FlashLoanReceiver {
    address public owner;
    FlashLoanProvider public provider;
    IERC20 public token;

    constructor(address _provider, address _token) {
        owner = msg.sender;
        provider = FlashLoanProvider(_provider);
        token = IERC20(_token);
    }

    // Called by provider during flash loan
    function executeOperation(uint amount) external {
        require(msg.sender == address(provider), "Only provider can call");

        // Do something with borrowed tokens (e.g., arbitrage)
        // ...

        // Repay the loan
        token.transfer(address(provider), amount);
    }

    // Function to start the flash loan
    function startFlashLoan(uint amount) external {
        require(msg.sender == owner, "Only owner can start");
        bytes memory data = abi.encodeWithSignature("executeOperation(uint256)", amount);
        provider.flashLoan(amount, address(this), data);
    }
}