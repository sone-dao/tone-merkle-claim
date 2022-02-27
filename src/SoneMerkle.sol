// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { IERC20 } from "@openzeppelin/token/ERC20/ERC20.sol";
import { MerkleProof } from "@openzeppelin/utils/cryptography/MerkleProof.sol"; // OZ: MerkleProof


/// @title SoneMerkle
/// @notice ERC20 claimable by members of a merkle tree
/// @author Anish Agnihotri <contact@anishagnihotri.com> (Original MerkleClaimERC20 contract) / extended by SONE DAO
/// @dev Solmate ERC20 includes unused _burn logic that can be removed to optimize deployment cost
contract SoneMerkle{

  /// ============ Immutable storage ============

  /// @notice ERC20-claimee inclusion root
  //bytes32[] public MERKLEROOT;
  bytes32[] public merkleRoot;
  address immutable OWNER;

  /// ============ Mutable storage ============

  /// @notice Mapping of addresses who have claimed tokens
  mapping(address => bool) public hasClaimed;
  IERC20 public token;

  /// ============ Errors ============

  /// @notice Thrown if address has already claimed
  error AlreadyClaimed();
  /// @notice Thrown if address/amount are not part of Merkle tree
  error NotInMerkle();

  /// ============ Constructor ============

  /// @notice Creates a new MerkleClaimERC20 contract
  /// @param _token address of token
  /// @param _merkleRoot of claimees
constructor(
    address _token,
    bytes32 _merkleRoot
  ) {
    merkleRoot.push(_merkleRoot); // Update root
    token = IERC20(_token); //Address of claimable token
    OWNER = msg.sender;
  }

  /// ============ Events ============

  /// @notice Emitted after a successful token claim
  /// @param to recipient of claim
  /// @param amount of tokens claimed
  event Claim(address indexed to, uint256 amount);

  /// @notice Emitted after a successful token claim
  /// @param from previous merkleRoot value
  /// @param to new merkleRoot value
  event ChangeMerkelRoot(bytes32 from, bytes32 to);

  /// ============ Modifiers ============
  modifier onlyOwner(){
    require(msg.sender == OWNER,"OnlyOwner");
    _;
  }

  /// ============ Functions ============

  /// onlyowner * GAS CHECK THIS FUNCTION TO SEE IF DECLARING A
  /// UINT FOR merkleroot.length is more efficent in EMIT
  /// @notice Sets new MerkleRoot
  function setNewMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
    merkleRoot.push(_merkleRoot);
    emit ChangeMerkelRoot(merkleRoot[merkleRoot.length - 2], merkleRoot[merkleRoot.length - 1]);
  }

  /// @notice Allows owner to sweep tokens after withdraw window closes
  function ownerSweepTokens() external onlyOwner {
    /// maybe add TIMELOCK here? Think this through
    token.transfer(OWNER,token.balanceOf(address(this)));
  }

  /// @notice Allows claiming tokens if address is part of merkle tree
  /// @param to address of claimee
  /// @param amount of tokens owed to claimee
  /// @param proof merkle proof to prove address and amount are in tree
  function claim(address to, uint256 amount, bytes32[] calldata proof) external {
    // emit Debug(msg.sender,to, amount);
    // emit Debug5(address(token));

    // Throw if address has already claimed tokens
    if (hasClaimed[to]) revert AlreadyClaimed();
    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot[merkleRoot.length - 1], leaf);
    // emit Debug2(leaf, isValidLeaf);
    if (!isValidLeaf) revert NotInMerkle();

    // Set address to claimed
    hasClaimed[to] = true;
    // emit Debug3(hasClaimed[to]);

    // Send tokens to address
    bool sent = token.transfer(to, amount);
        require(sent, "Token transfer failed");

    // Emit claim event
    emit Claim(to, amount);

  }
}
