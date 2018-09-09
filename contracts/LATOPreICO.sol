pragma solidity ^0.4.17;

import "./LATPToken.sol";


contract LATOPreICO {

    /*
     * External contracts
     */
    LATPToken public latpToken = LATPToken(0x853656f3bb388a4ac07a8155e7d0fef69b349077);

    address public founder;

    uint256 public baseTokenPrice = 3000000000000000000 wei;

    // participant address => value in Wei
    mapping (address => uint) public investments;

    event LATPTransaction(uint256 indexed transactionId, uint256 transactionValue, uint256 indexed timestamp);

    /*
     *  Modifiers
     */
    modifier onlyFounder() {
        // Only founder is allowed to do this action.
        if (msg.sender != founder) {
            throw;
        }
        _;
    }
    
    modifier notFounder(){
        if(msg.sender == founder){
            throw;
        }
        _;
    }

    // modifier minInvestment() {
    //     // User has to send at least the ether value of one token.
    //     if (msg.value < baseTokenPrice) {
    //         throw;
    //     }
    //     _;
    // }

    function fund(uint256 valueInWei)
        public
        notFounder
        returns (uint256)
    {
        if (valueInWei < baseTokenPrice) {
            throw;
        }
      //  return baseTokenPrice;
        uint tokenCount = valueInWei / (baseTokenPrice);
        uint investment = tokenCount * (baseTokenPrice);

        // if ((valueInWei > investment) && !msg.sender.transfer(valueInWei - investment)) {
        //     throw;
        // }

        investments[msg.sender] += investment;
        uint256 investment_eth = investment/(10**18);
        //latpToken.balances[msg.sender] += tokenCount;
        
        if (!latpToken.issueTokens(msg.sender, tokenCount)) {
            throw;
        }
        
        //founder.transfer(investment_eth);

        // uint transactionId = 0;
        // for (uint i = 0; i < 32; i++) {
        //     uint b = uint(msg.data[35 - i]);
        //     transactionId += b * 256**i;
        // }
        // LATPTransaction(transactionId, investment, now);
        
        
        return tokenCount;
       // return 0;
    }

    function fundManually(address beneficiary, uint _tokenCount)
        external
        onlyFounder
        returns (uint)
    {
        uint investment = _tokenCount * baseTokenPrice;

        investments[beneficiary] += investment;
        
        if (!latpToken.issueTokens(beneficiary, _tokenCount)) {
            throw;
        }

        return _tokenCount;
    }

    function setTokenAddress(address _newTokenAddress)
        external
        onlyFounder
        returns (bool)
    {
        latpToken = LATPToken(_newTokenAddress);
        return true;
    }

    function changeBaseTokenPrice(uint valueInWei)
        external
        onlyFounder
        returns (bool)
    {
        baseTokenPrice = valueInWei;
        return true;
    }

    constructor () public payable{
        founder = msg.sender;
        latpToken.setBalance();
    }

    function () payable {
    //     fund();
     }
}
