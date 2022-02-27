// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { ERC20 } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/lib/solmate/src/tokens/ERC20.sol"; // Solmate: ERC20

/// @title MerkleClaimERC20
/// @notice ERC20 claimable by members of a merkle tree
/// @author Anish Agnihotri <contact@anishagnihotri.com>
/// @dev Solmate ERC20 includes unused _burn logic that can be removed to optimize deployment cost
contract DaiMock is ERC20 {

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals
  ) ERC20(_name, _symbol, _decimals) {}

  function mint(address to, uint256 amount) public{
    _mint(to, amount);
  }

  function _mint(address to, uint256 amount) internal override {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

}
