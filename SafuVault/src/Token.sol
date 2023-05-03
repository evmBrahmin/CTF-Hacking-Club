// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract USDC is ERC20, Ownable {
    constructor() ERC20("Franklin USDC", "FUSDC") {}

    function mint(address receiver, uint256 amount) public  {
        _mint(receiver, amount);
    }

}