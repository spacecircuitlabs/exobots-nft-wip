// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";

/**
 * @title Robot
 * Robot - a contract for my non-fungible robots.
 */
contract Exobot is ERC721Tradable {
    using SafeMath for uint256;
    
    uint public constant MAX_PURCHASE = 20;
    uint public constant SEASON1_TOTAL = 4663;
    uint public constant SEASON2_TOTAL = 3344;
    uint public constant SEASON3_TOTAL = 999;
    uint public constant SEASON4_TOTAL = 999;
    uint public constant SEASON1_GIVEAWAY = 342;
    uint public constant SEASON2_GIVEAWAY = 22;
    uint public constant SEASON3_DISCOUNTED_PRICE = 0; // if user is holding
    uint256 public exobotPrice = 50000000000000000; // 0.050 ETH
    
    bool public isActiveSale = false;
    
    modifier onlyValidOrder (uint numOfTokens) {
        require(isActiveSale, "Sale must be active to mint Exobot");
        require(numOfTokens > 0 && numOfTokens <= MAX_PURCHASE, "Can only mint 20 tokens at a time");
        _;
    }

    constructor(address _proxyRegistryAddress)
        ERC721Tradable("Robots-Test", "RBT", _proxyRegistryAddress)
    {}

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function mintSeason1(uint numOfTokens) external payable onlyValidOrder(numOfTokens) {
        require(msg.value >= exobotPrice.mul(numOfTokens), "Ether value sent is not correct"); 
        require(totalSupply().add(numOfTokens) <= SEASON1_TOTAL, "Purchase would exceed max supply of Exobots");
   
        mintExobot(numOfTokens);
        
        if (totalSupply() == SEASON1_TOTAL - 1) {
            endSale();
        }
    }
    
    function mintSeason2(uint numOfTokens) external payable onlyValidOrder(numOfTokens) {
        require(msg.value >= exobotPrice.mul(numOfTokens), "Ether value sent is not correct"); 
        require(totalSupply().add(numOfTokens) <= SEASON1_TOTAL + SEASON2_TOTAL, "Purchase would exceed max supply of Exobots");
        require(totalSupply() >= SEASON1_TOTAL + SEASON2_GIVEAWAY, "Sale only starts after pre-mint for giveaway");

        mintExobot(numOfTokens);

        if (totalSupply() == SEASON2_TOTAL - 1) {
            endSale();
        }
    }

    function mintSeason3(uint numOfTokens, uint [] calldata season1TokenIds, uint [] calldata season2TokenIds) external payable onlyValidOrder(numOfTokens) {
        require(totalSupply().add(numOfTokens) <= SEASON1_TOTAL + SEASON2_TOTAL + SEASON3_TOTAL, "Purchase would exceed max supply of Exobots");
        
        bool eligbleForDiscount = false;
        
        if (season1TokenIds.length >= 4) {
            
            uint count = 0;
            for (uint i = 0; i < season1TokenIds.length; i++) {
                if (ownerOf(season1TokenIds[i]) == msg.sender && season1TokenIds[i] <= SEASON1_TOTAL) {
                    count = count++;
                }
            }

            if (count >= 4) {
                eligbleForDiscount = true;
            }

        }

        // if they are holding at least 2 nfts from every season (1 and two) or if they are holding 4 nft from A season = they get x% discount

        // check if msg.sender has 4 nfts

        // if yes, check if two comes from each season or all from one season

        if (totalSupply() == SEASON3_TOTAL - 1) {
            endSale();
        }
    }

    function mintSeason4(uint numOfTokens) external payable onlyValidOrder(numOfTokens) {
        require(totalSupply().add(numOfTokens) <= SEASON1_TOTAL + SEASON2_TOTAL + SEASON3_TOTAL + SEASON4_TOTAL, "Purchase would exceed max supply of Exobots");
        // only starts after season 1 + pre mint
        // check if order will reach max season total
        // toggle sale as end after reaching season total.

        // if they are holding at least 2 nfts from all prev season = they get free

    }

    function preMint(uint season, address recepient) external onlyOwner {
        uint startIndex;
        uint endIndex;

        if (season == 1) {
            startIndex = 0;
            endIndex = SEASON1_GIVEAWAY;

        } else if (season == 2) {
            startIndex = SEASON1_TOTAL;
            endIndex = SEASON1_TOTAL + SEASON2_GIVEAWAY;

        } 

        for (uint256 i = startIndex; i < endIndex; i++) {
            uint256 mintIndex = totalSupply() + i;
            _safeMint(recepient, mintIndex);
        }
    }

    function mintExobot(uint numOfTokens) internal {
        for (uint256 i = 0; i < numOfTokens; i++) {
            uint256 mintIndex = totalSupply();
            _safeMint(msg.sender, mintIndex);
        }
    }

    function endSale() internal {
        isActiveSale = false;
    }

    function setExobotPrice(uint256 newPrice) external onlyOwner {
        exobotPrice = newPrice;
    }

    function toggleSaleStatus() external onlyOwner {
        isActiveSale = isActiveSale ? false : true;
    }



    function baseTokenURI() override public pure returns (string memory) {
        return "https://test-robotv1.herokuapp.com/api/token/";
    }

    function contractURI() public pure returns (string memory) {
        return "";
    }
}