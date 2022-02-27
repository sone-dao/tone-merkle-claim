// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { DSTest } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/lib/ds-test/src/test.sol"; // DSTest
import { MerkleClaimERC20User } from "./MerkleClaimERC20User.sol"; // MerkleClaimERC20 user
import { DaiMock } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/src/test/utils/DaiMockERC20.sol";
import { SoneMerkle } from "/Users/chadmcdonald/Documents/sone-merkle/merkle-airdrop-starter/contracts/src/SoneMerkle.sol"; // MerkleClaimERC20


/// @title MerkleClaimERC20Test
/// @notice Scaffolding for MerkleClaimERC20 tests
/// @author Anish Agnihotri <contact@anishagnihotri.com>
contract MerkleClaimERC20Test is DSTest {

  /// ============ Storage ============

  /// @dev ERC20 token contract - this token is claimed by users
  DaiMock internal TOKEN;
  /// @dev User: Alice (in merkle tree)
  MerkleClaimERC20User internal ALICE;
  /// @dev User: Bob (not in merkle tree)
  MerkleClaimERC20User internal BOB;
  /// @dev User: Carrie (in merkle tree)
  MerkleClaimERC20User internal CARRIE;
  /// @dev User: Dave (not in merkle tree)
  MerkleClaimERC20User internal DAVE;
  /// @dev Sone Merkle contract
  SoneMerkle internal SONE;

  /// ============ Setup test suite ============

  function setUp() public virtual {
    // Create airdrop token
    TOKEN = new DaiMock(
      "Dai Stablecoin", 
      "DAI", 
      18
    );

    // Setup airdrop users
    ALICE = new MerkleClaimERC20User(TOKEN); // 0x185a4dc360ce69bdccee33b3784b0282f7961aea
    BOB = new MerkleClaimERC20User(TOKEN); // 0xefc56627233b02ea95bae7e19f648d7dcd5bb132
    DAVE = new MerkleClaimERC20User(TOKEN); // 0x42997ac9251e5bb0a61f4ff790e5b991ea07fd9b
    CARRIE = new MerkleClaimERC20User(TOKEN); // 0xf5a2fe45f4f1308502b1c136b9ef8af136141382

    // Setup SONE contract
    // Merkle root containing ALICE with 100e18 tokens but no BOB
    // 0xd0aa6a4e5b4e13462921d7518eebdb7b297a7877d6cfe078b0c318827392fb55


    // Merkle root containing CARRIE with 100e18 tokens but no DAVE
    // 0xf8d87054639001eaa030e01f4c7e5f30c23b149d0843614e8b643363f6d5caa5
    
    SONE = new SoneMerkle(address(TOKEN),0xd0aa6a4e5b4e13462921d7518eebdb7b297a7877d6cfe078b0c318827392fb55);

    // Send balance to SONE 
    TOKEN.mint(address(SONE), 100e18);

    //Set SONE address for bob and alice
    ALICE.setSoneTokenAddress(address(SONE));
    BOB.setSoneTokenAddress(address(SONE));
    CARRIE.setSoneTokenAddress(address(SONE));
    DAVE.setSoneTokenAddress(address(SONE));
  }
}
