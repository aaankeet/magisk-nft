// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.15;

import "./MagicNft.sol";

contract EnterMagisk {
    MagiskNft public magiskNft;

    constructor(address _masgiskNft) {
        magiskNft = MagiskNft(_masgiskNft);
    }

    uint32 public coolDown = 24 hours;
    mapping(address => uint32) public lastInteraction;

    modifier coolDownEnabled() {
        require(
            block.timestamp >= lastInteraction[msg.sender] + coolDown,
            "Available after 24 Hours"
        );
        _;
        lastInteraction[msg.sender] = uint32(block.timestamp);
    }

    function enterLounge(uint8 tokenId) public coolDownEnabled {
        magiskNft.useNFT(tokenId);
    }

    function claimFreeGifts() public coolDownEnabled {}
}
