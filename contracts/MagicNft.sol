// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*

    This is a Erc1155 nft contract, users can buy 2 types of nfts Silver and Gold.
    Silver nft has 5 use limit and Gold has 10 use limit 
    User's can use these nft in bunch of ways for example to get access to some sepcial event,
    claim items, free rides, celebrity interactions and what not.
    User's can only own 1 of each nft no duplicates(1 silver, 1 gold).
    Once they exhaust their nfts it will be burned.
    In order to enjoy perks associated with the nft they have to buy again.
    

    Additional Features :
    1. Cooldown can be added after each use.
    2. Nft forging may be added Silver + Gold = Platinum ( with more perks).
    3. Can be used to sponser transcation fee(paymasters) for smart contract wallets (Account abstraction).
    
*/

contract MagiskNft is ERC1155, Ownable {
    string public constant NAME = "Magisk Nft";
    string public constant SYMBOL = "MAGISK";

    // NFT ids
    uint8 public constant SILVER_NFT_ID = 0;
    uint8 public constant GOLD_NFT_ID = 1;

    // Price for both silver and gold nft
    uint256 public constant SILVER_NFT_PRICE = 0.003 ether;
    uint256 public constant GOLD_NFT_PRICE = 0.005 ether;

    // Use Limit for Silver and Gold Nft
    uint8 public constant SILVER_USE_LIMIT = 5;
    uint8 public constant GOLD_USE_LIMIT = 8;

    // address --> tokenId --> use limit
    // to track user's token use limit
    mapping(address => mapping(uint8 => uint8)) private userNftUseLimit;

    mapping(address => bool) public hasSilverNft;
    mapping(address => bool) public hasGoldNft;

    // Events
    event NFTMinted(address indexed account, uint tokenId, uint limitAvailable);
    event NFTUsed(address indexed account, uint tokenId, uint limitAvailable);

    constructor() ERC1155("") {}

    // Buy Silver Nft
    function buySilverNft() public payable {
        require(!hasSilverNft[msg.sender], "Already owns a silver nft");
        require(msg.value >= SILVER_NFT_PRICE, "Incorrect payment amount");

        hasSilverNft[msg.sender] = true;
        userNftUseLimit[msg.sender][SILVER_NFT_ID] = SILVER_USE_LIMIT;

        _mint(msg.sender, SILVER_NFT_ID, 1, "");
        emit NFTMinted(msg.sender, SILVER_NFT_ID, SILVER_USE_LIMIT);
    }

    // Buy Gold Nft
    function buyGoldNft() public payable {
        require(!hasGoldNft[msg.sender], "Already Owns a Gold Nft");
        require(msg.value >= GOLD_NFT_PRICE, "Incorrect payment amount");

        hasGoldNft[msg.sender] = true;
        userNftUseLimit[msg.sender][GOLD_NFT_ID] = GOLD_USE_LIMIT;

        _mint(msg.sender, GOLD_NFT_ID, 1, "");
        emit NFTMinted(msg.sender, GOLD_NFT_ID, GOLD_USE_LIMIT);
    }

    function useNFT(uint8 tokenId) public {
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
            if (userNftUseLimit[msg.sender][currentTokenId] == 0) {
                // Nft use limit exhausted
                hasSilverNft[msg.sender] = false;
                // burn user's nft after exhausting use limit
                _burn(msg.sender, currentTokenId, 1);
            }
            // Else its Gold nft
        } else {
            uint256 currentUseLimit = userNftUseLimit[msg.sender][
                currentTokenId
            ]--;
            emit NFTUsed(msg.sender, currentTokenId, currentUseLimit);
            if (userNftUseLimit[msg.sender][currentTokenId] == 0) {
                // Nft use limit exhausted
                hasGoldNft[msg.sender] = false;
                // burn user's nft after exhausting use limit
                _burn(msg.sender, currentTokenId, 1);
            }
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

    // Get User's Nft Limit
    function getUserNFTLimit(
        address user,
        uint8 tokenId
    ) public view returns (uint8) {
        return userNftUseLimit[user][tokenId];
    }
}
