// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BaseLaunchpegNFT.sol";
import "../src/FlatLaunchpeg.sol";
import "../src/LaunchpegErrors.sol";

contract CounterTest is Test {
    Counter public counter;
    FlatLaunchpeg public flatLaunchpeg;



    // required for testing, run once before each test 
    function setUp() public {
        FlatLaunchpeg = new FlatLaunchpeg(69, 5, 5);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
