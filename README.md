# tone-merkle-claim

A claiming contract for the [SoneDAO](https://sone.works/) using merkle tree proofs.  

## Getting Started

```
mkdir tone-merkle-claim
cd tone-merkle-claim
forge init --template https://github.com/FrankieIsLost/forge-template
git submodule update --init --recursive  ## initialize submodule dependencies
npm install ## install development dependencies
forge build
forge test
```

:exclamation: Not for use in production :exclamation:
## tone-merkle-claim.sol 

Tone's Merkle Claim contract is an extension of [Merkle-airdrop-starter](https://github.com/Anish-Agnihotri/merkle-airdrop-starter).  Our contract enables the owner to update the merkle root to allow for new token distributions using the same contract address.

## Acknowledgement

Using the great Forge Template by Frankieislost https://github.com/FrankieIsLost/forge-template
