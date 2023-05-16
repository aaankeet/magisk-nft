// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*

    This is a Erc1155 nft contract, users can buy 2 types of nfts Silver and Gold.
    Silver nft has 5 use limit and Gold has 10 use limit 
    User's can use these nft in bunch of ways for example to get access to some sepcial event,
    claim items, celebrity interactions and what not.
    User's can only own 1 of each nft no duplicates(1 silver, 1 gold).
    When Holder Completely Exhausts their Nfts they can refill their nfts
    In order to continue enjoying perks associated with the nft.

    This creates far more utility and keeps holders engaging in buying and refilling their nfts

    & also there are endless uses cases.
    
*/
/**
 * @title MagiskNft
 * @author aaankeet
 */
contract MagiskNft is ERC1155, Ownable {
    string public constant NAME = "Magisk Nft";
    string public constant SYMBOL = "MAGISK";

    // NFT ids
    uint8 public constant SILVER_NFT_ID = 0;
    uint8 public constant GOLD_NFT_ID = 1;

    // Price for both silver and gold nft
    uint256 public constant SILVER_NFT_PRICE = 0.5 ether;
    uint256 public constant GOLD_NFT_PRICE = 0.8 ether;

    // Use Limit for Silver and Gold Nft
    uint8 public constant SILVER_USE_LIMIT = 5;
    uint8 public constant GOLD_USE_LIMIT = 10;

    // Cooldown can utilized after every nft use
    uint32 public constant cooldown = 24 hours;
    bool public isCooldown;

    // address --> tokenId --> NFT Limit
    // to track user's token use limit
    mapping(address => mapping(uint8 => uint8)) private userNftUseLimit;

    mapping(address => bool) public hasSilverNft;
    mapping(address => bool) public hasGoldNft;
    mapping(address => uint32) public lastInteraction;

    // Events
    event NFTMinted(address account, uint tokenId, uint limitAvailable);
    event NFTUsed(address indexed user, uint256 id, uint limitAvailable);

    constructor() ERC1155("") {}

    // Cooldown modifier
    // to make sure user can only use nft once in 24 hours
    modifier cooldownEnabled() {
        if (isCooldown) {
            require(
                block.timestamp >= lastInteraction[msg.sender] + cooldown,
                "Available after 24 Hours"
            );
        }
        _;
        lastInteraction[msg.sender] = uint32(block.timestamp);
    }

    /**
     * @param tokenId - 0 is Silver 1 is Gold
     */
    function mintNft(uint8 tokenId) public payable {
        require(tokenId == 0 || tokenId == 1, "Invalid Token Id");

        if (tokenId == 0) {
            require(!hasSilverNft[msg.sender], "Already owns a silver nft");
            require(msg.value >= SILVER_NFT_PRICE, "Incorrect payment amount");

            hasSilverNft[msg.sender] = true;
            userNftUseLimit[msg.sender][SILVER_NFT_ID] = SILVER_USE_LIMIT;
            _mint(msg.sender, SILVER_NFT_ID, 1, "");

            emit NFTMinted(msg.sender, tokenId, SILVER_USE_LIMIT);
        }
        if (tokenId == 1) {
            require(!hasGoldNft[msg.sender], "Already owns a silver nft");
            require(msg.value >= GOLD_NFT_PRICE, "Incorrect payment amount");

            hasGoldNft[msg.sender] = true;
            userNftUseLimit[msg.sender][GOLD_NFT_ID] = GOLD_USE_LIMIT;
            _mint(msg.sender, GOLD_NFT_ID, 1, "");

            emit NFTMinted(msg.sender, tokenId, GOLD_USE_LIMIT);
        }
    }

    /**
     * @param tokenId - 0 is Silver 1 is Gold
     */

    function useNFT(uint8 tokenId) public cooldownEnabled {
        require(tokenId == 0 || tokenId == 1, "Invalid Token id");
        require(
            userNftUseLimit[msg.sender][tokenId] > 0,
            "Nft not found or Exhausted"
        );

        // Get current tokenId
        uint8 currentTokenId = tokenId;
        // Get Current Token Limit

        // If its Silver Nft
        if (currentTokenId == 0) {
            uint256 currentUseLimit = userNftUseLimit[msg.sender][
                currentTokenId
            ]--;
            emit NFTUsed(msg.sender, currentTokenId, currentUseLimit);
        } else {
            uint256 currentUseLimit = userNftUseLimit[msg.sender][
                currentTokenId
            ]--;
            emit NFTUsed(msg.sender, currentTokenId, currentUseLimit);
        }
    }

    /**
     * @notice refill nft when use limit is exhausted
     * @param tokenId - 0 is Silver 1 is Gold
     */
    function refill(uint8 tokenId) external payable {
        require(tokenId == 0 || tokenId == 1, "Invalid Token Id");

        if (tokenId == 0) {
            require(hasSilverNft[msg.sender], "Nft Not Found");
            require(
                userNftUseLimit[msg.sender][tokenId] == 0,
                "Refill Not Needed"
            );
            require(msg.value == SILVER_NFT_PRICE, "Insufficient Amount");

            // Update silver nft use limit
            userNftUseLimit[msg.sender][tokenId] = SILVER_USE_LIMIT;
        } else {
            require(hasGoldNft[msg.sender], "Nft Not Found");
            require(
                userNftUseLimit[msg.sender][tokenId] == 0,
                "Refill Not Needed"
            );
            require(msg.value == GOLD_NFT_PRICE, "Insufficient Amount");

            // Update gold nft use limit
            userNftUseLimit[msg.sender][tokenId] = GOLD_USE_LIMIT;
        }
    }

    // Only owner can drop nfts to addresses
    function dropTo(address account, uint8 tokenId) external onlyOwner {
        require(tokenId == 0 || tokenId == 1, "Invalid token Id");

        if (tokenId == 0) {
            require(!hasSilverNft[account], "User already holds Silver Nft");
            hasSilverNft[account] = true;
            userNftUseLimit[account][tokenId] = SILVER_USE_LIMIT;
            _mint(account, tokenId, 1, "");
            emit NFTMinted(account, tokenId, SILVER_USE_LIMIT);
        } else {
            require(!hasGoldNft[account], "User already holds Gold Nft");
            hasGoldNft[account] = true;
            userNftUseLimit[account][tokenId] = GOLD_USE_LIMIT;
            _mint(account, tokenId, 1, "");
            emit NFTMinted(account, tokenId, GOLD_USE_LIMIT);
        }
    }

    function uri(uint tokenId) public pure override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://ipfs.io/ipfs/QmYt6iu4RoDVci5GuGdJTurPB9UcWHwJ72agQaxzTumCgB/",
                    Strings.toString(tokenId),
                    ".json"
                )
            );
    }

    /**
     * @param user - address to query for
     * @param tokenId - nft id, 0 for silver 1 for gold
     */
    function getUserNFTLimit(
        address user,
        uint8 tokenId
    ) public view returns (uint8) {
        return userNftUseLimit[user][tokenId];
    }

    function withdraw() external onlyOwner {
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Tx Failed");
    }

    // toggle cooldown
    function toggleCooldown(bool _value) external onlyOwner {
        isCooldown = _value;
    }
}
