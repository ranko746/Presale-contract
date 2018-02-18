pragma solidity ^0.5.0;

import "./GetoToken.sol";

contract GetoTokenSale {
    address payable admin;
    GetoToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(GetoToken _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        require(
            msg.value == _numberOfTokens * tokenPrice,
            "Number of tokens does not match with the value"
        );
        require(
            tokenContract.balanceOf(address(this)) >= _numberOfTokens,
            "Contract does not have enough tokens"
        );
        require(
            tokenContract.transfer(msg.sender, _numberOfTokens),
            "Some problem with token transfer"
        );
        tokensSold += _numberOfTokens;
        emit Sell(msg.sender, _numberOfTokens);
    }
        function _forwardFunds() internal {
    admin.transfer(msg.value);
  }
    function endSale() public {
        require(msg.sender == admin, "Only the admin can call this function");
        require(
            tokenContract.transfer(
                msg.sender,
                tokenContract.balanceOf(address(this))
            ),
            "Unable to transfer tokens to admin"
        );
        // destroy contract
        selfdestruct(admin);
    }
}
