# ⚡ Flash Loan System (Solidity Example)

A simple **Flash Loan** implementation in Solidity that demonstrates how a user can **borrow funds without collateral**, provided the borrowed amount is **repaid within the same transaction block**.

> ⚠️ **Disclaimer:**  
> This project is for **educational purposes only**.  
> Do **NOT** deploy it to the Ethereum mainnet — it lacks critical features like **security checks, reentrancy protection, and flash loan fees**.

---

## 🧩 Overview

A **flash loan** allows a borrower to take a large loan with **no collateral**, as long as the funds are returned within the same transaction.  
If repayment fails, the entire transaction **reverts**, ensuring the lender’s funds are never at risk.

This project demonstrates:
- How a **flash loan provider** can lend ETH.
- How a **borrower contract** interacts with the provider.
- The concept of **atomicity in blockchain transactions**.

---

## 🧠 How It Works

1. **Deposit ETH** into the `FlashLoanProvider` contract — this creates a liquidity pool.  
2. The borrower calls `startFlashLoan(amount)` from `FlashLoanBorrower`.  
3. The provider sends the ETH to the borrower and calls its `execute()` function.  
4. The borrower performs some logic (like arbitrage, liquidation, etc.).  
5. The borrower must **repay** the loan within the same transaction.  
6. If the loan is not repaid, the **entire transaction reverts**.

---

## 🧱 Smart Contracts

### 1. `FlashLoanProvider.sol`
Handles:
- Receiving ETH deposits  
- Issuing flash loans  
- Verifying repayment within the same transaction  

### 2. `FlashLoanBorrower.sol`
Implements:
- The `IFlashLoanBorrower` interface  
- The loan request and repayment logic  
- Custom on-loan logic in the `execute()` function (e.g., arbitrage or swap)

---

## 💻 Example Code

```solidity
provider.flashLoan(5 ether);
