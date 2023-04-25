pragma solidity ^0.8.0;

/***
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Magisk is ERC1155, ERC1155Burnable {
    string public constant NAME = "Magisk";
    string public constant SYMBOL = "MAGISK";

    uint8 public constant SILVER_NFT = 0;
    uint8 public constant GOLD_NFT = 1;

    uint256 public constant SILVER_PRICE = 1 ether;
    uint256 public constant GOLD_PRICE = 1 ether;
    uint8 public constant SILVER_USE_LIMIT = 5;
    uint8 public constant GOLD_USE_LIMIT = 10;

    string public constant IMAGE_URL =
        "https://ipfs.io/ipfs/Qmb7g6EjjTJSHG2gy5DxLxvu7t27oatgC1vMGwfEirYEF2/";

    mapping(address => mapping(uint8 => uint8)) private userNftUseLimit;

    mapping(address => bool) public hasSilverNft;
    mapping(address => bool) public hasGoldNft;

    event NFTUsed(address indexed user, uint256 id, uint limitAvailable);

    constructor() ERC1155("") {}

    function buySilverNFT() public payable {
        require(msg.value >= SILVER_PRICE, "Incorrect payment amount");
        require(!hasSilverNft[msg.sender], "Already Owns a Silver Nft");

        _mint(msg.sender, SILVER_NFT, 1, "");

        userNftUseLimit[msg.sender][SILVER_NFT] = SILVER_USE_LIMIT;
        hasSilverNft[msg.sender] = true;
    }

    function buyGoldNFT() public payable {
        require(msg.value == GOLD_PRICE, "Incorrect payment amount");
        require(!hasGoldNft[msg.sender], "Already Owns a Gold Nft");
        _mint(msg.sender, GOLD_NFT, 1, "");
        userNftUseLimit[msg.sender][GOLD_NFT] = GOLD_USE_LIMIT;
        hasGoldNft[msg.sender] = true;
    }

    function useNFT(uint8 tokenId) public {
        require(tokenId >= 0 && tokenId <= 1, "Invalid Token id");
        require(
            userNftUseLimit[msg.sender][tokenId] > 0,
            "You don't own this NFT"
        );

        uint currentUseLimit = userNftUseLimit[msg.sender][tokenId];

        if (currentUseLimit > 0) {
            --currentUseLimit;
            emit NFTUsed(msg.sender, tokenId, currentUseLimit);

            if (tokenId == 0 && currentUseLimit == 0) {
                hasSilverNft[msg.sender] = false;
            }
            if (tokenId == 1 && currentUseLimit == 0) {
                hasGoldNft[msg.sender] = false;
            }
        } else {
            revert("You dont own an nft");
        }
    }

    function uri(uint tokenId) public pure override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://ipfs.io/ipfs/QmWRE6mBfG8nUUuEXck2MnNoR6pzCzZqGEueH741zKLL8b/",
                    Strings.toString(tokenId),
                    ".json"
                )
            );
    }

    function getUserNFTLimit(
        address user,
        uint8 tokenId
    ) public view returns (uint8) {
        return userNftUseLimit[user][tokenId];
    }

    function burnNft(uint account, uint tokenId) internal {}
}
