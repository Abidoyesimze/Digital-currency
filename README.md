# Decentralized Vending Machine and Token Project

This project implements a decentralized vending machine for a custom ERC20 token called YourToken. It consists of two main smart contracts: YourToken and Vendor.

## Smart Contracts

### YourToken Contract

YourToken is an ERC20 token implemented using the OpenZeppelin library.

Key features:
- Standard ERC20 functionality (transfer, approve, transferFrom, etc.)
- Initial supply of 1000 tokens minted to the contract deployer

### Vendor Contract

The Vendor contract acts as a decentralized vending machine for YourToken.

Key features:
- Buy tokens with ETH
- Sell tokens back to the contract for ETH
- Withdraw accumulated ETH (owner only)
- Set token price (owner only)

## Setup and Deployment

1. Install dependencies:
   ```
   yarn install
   ```

2. Compile contracts:
   ```
   yarn hardhat compile
   ```

3. Deploy contracts:
   ```
   yarn hardhat deploy --network <your-network>
   ```
   Replace `<your-network>` with your desired network (e.g., localhost, sepolia, mainnet)

## Usage

### Buying Tokens

Users can buy tokens by calling the `buyTokens()` function on the Vendor contract and sending ETH.

Example:
```javascript
await vendor.buyTokens({ value: ethers.utils.parseEther("1") });
```

### Selling Tokens

To sell tokens back to the contract:

1. Approve the Vendor contract to spend your tokens:
   ```javascript
   await yourToken.approve(vendorAddress, amountToSell);
   ```

2. Call the `sellTokens()` function:
   ```javascript
   await vendor.sellTokens(amountToSell);
   ```

### Withdrawing ETH (Owner Only)

The contract owner can withdraw accumulated ETH:

```javascript
await vendor.withdraw();
```

### Setting Token Price (Owner Only)

The owner can set a new token price:

```javascript
await vendor.setTokensPerEth(newPrice);
```

## Testing

Run the test suite:

```
yarn hardhat test
```


