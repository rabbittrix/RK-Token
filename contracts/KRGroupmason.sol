// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract KRGroupmason is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    uint8 private _decimals = 18; // Set decimals to 18
    uint256 private _decimalsFactor = 10 ** uint256(_decimals); // Add decimals factor

    constructor(uint256 cap, uint256 reward) ERC20( "name", "symbol") ERC20Capped(cap * _decimalsFactor) {
        owner = payable(msg.sender);
        _mint(owner, 7000000 * _decimalsFactor);
        blockReward = reward * _decimalsFactor;
    }

    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Capped) {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert("Cap reached"); // Fix the revert statement
            }
        }
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual {
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0) && ERC20.totalSupply() + blockReward <= cap()) {
            _mintMinerReward();
        }
        _beforeTokenTransfer(from, to, value); // Call super last
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * _decimalsFactor;
    }

    function destroy() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
