// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Attack.sol";

interface TargetContract{
    // add interface for the target contract here
}

contract TestAttack is Test {
    // declare attack contract
    Attack public attack;

    // declare target contract

    // create necessary accounts


    function setUp() public {
        // deploy target contract 
        // target = new Target(); 
        
        // deploy attack contract (unless attack includes using the attack contract's constructor)
        attack = new Attack();
    }

    function testAttack() public {
       
    }


}
