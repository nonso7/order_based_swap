// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "@openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts@4.8.2/utils/math/Math.sol";


contract swapBased {

    struct TokenDetails{
        IERC20 token;
        uint rate;
    }

    mapping (string => TokenDetails ) tokenMapping;
    mapping(address => uint) balances;

    function addTokens(string memory _tokenSymbol, address _tokenAddress, uint _rate) public {
        IERC20 newToken = IERC20(_tokenAddress);
        tokenMapping[_tokenSymbol] = TokenDetails(newToken, _rate);
    }

    function swapToken(string memory _fromSymbol, string memory _toSymbol, uint _amount) public {
        require(tokenMapping[_fromSymbol].token.balanceOf(msg.sender) >= _amount, "Insufficient funds");
        //require(tokenMapping[_toSymbol].token != address(0), "Address zero detected");
        require(address(tokenMapping[_toSymbol].token) != address(0), "Address zero detected");
        require(_amount > 0, "can't deposit no token");

        //calculate amount to get after swap
                uint256 amountToGet = (_amount * tokenMapping[_toSymbol].rate) / tokenMapping[_fromSymbol].rate;

        tokenMapping[_fromSymbol].token.transferFrom(msg.sender, address(this), _amount);
        tokenMapping[_toSymbol].token.transfer(msg.sender, amountToGet);

    }

    function TokenBalance() external view returns(uint256) { 
        
        return balances[msg.sender];
    } 
}