// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { SoneMerkle } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/src/SoneMerkle.sol"; // MerkleClaimERC20
import { DaiMock } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/src/test/utils/DaiMockERC20.sol";


/// @title MerkleClaimERC20User
/// @notice Mock MerkleClaimERC20 user
/// @author Anish Agnihotri <contact@anishagnihotri.com>
contract MerkleClaimERC20User {

  /// ============ Immutable storage ============

  /// @dev MerkleClaimERC20 contract
  DaiMock immutable internal TOKEN;
  SoneMerkle internal SONE;

  /// ============ Constructor ============

  /// @notice Creates a new MerkleClaimERC20User
  /// @param _TOKEN MerkleClaimERC20 contract
  // constructor(SoneMerkle _SONE, DaiMock _TOKEN) {
  //   SONE = _SONE;
  //   TOKEN = _TOKEN;
  // }
  // constructor(DaiMock _TOKEN, SoneMerkle _SONE) {
  //   TOKEN = _TOKEN;
  //   SONE = _SONE;
  // }
  constructor(DaiMock _TOKEN) {
    TOKEN = _TOKEN;
  }

  /// ============ Helper functions ============

  /// @notice Returns users' token balance
  function tokenBalance() public view returns (uint256) {
    return TOKEN.balanceOf(address(this));
  }

  /// ============ Inherited functionality ============

  /// @notice Allows user to claim tokens from contract
  /// @param to address of claimee
  /// @param amount of tokens owed to claimee
  /// @param proof merkle proof to prove address and amount are in tree
  function claim(address to, uint256 amount, bytes32[] calldata proof) public {
    SONE.claim(to, amount, proof);
  }

  function setSoneTokenAddress(address _SONE) external {
    SONE = SoneMerkle(_SONE);
  }

  function ownerSweepTokens() external {
    SONE.ownerSweepTokens();
  }
}

