# Blockchain Development Toolkit

Collection of useful scripts and tools for blockchain development.

## Scripts

### Gas Cost Analyzer
Real-time gas cost comparison across multiple networks.

**Supported Networks:**
| Network | Chain ID |
|---------|----------|
| Ethereum Mainnet | 1 |
| Base | 8453 |
| Polygon | 137 |
| Arbitrum | 42161 |
| Optimism | 10 |

**Usage:**
```bash
forge script script/GasChecker.s.sol --rpc-url https://mainnet.base.org
```

**Sample Output:**
```
Network: Base
Gas Price: 18 milli-gwei
ETH Price: $ 4168
Transfer Cost: $ 1620 micro-USD
Transfer Cost in USD: ~$0.00 16
```

**What it does:**
- Fetches current gas prices from the network
- Gets real-time ETH/USD price from Chainlink oracles
- Calculates cost of simple transfer (21,000 gas)
- Converts to readable USD format

## Quick Start

### Prerequisites
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation
```bash
git clone <your-repo-url>
cd <repo-name>
```

### Run Gas Analyzer
```bash
# Different networks
forge script script/GasChecker.s.sol --rpc-url https://mainnet.base.org
forge script script/GasChecker.s.sol --rpc-url https://polygon-rpc.com
forge script script/GasChecker.s.sol --rpc-url https://arb1.arbitrum.io/rpc
```

## Use Cases

- **Developers:** Choose optimal deployment network
- **DeFi Users:** Find cheapest transaction costs  
- **Traders:** Calculate real trading costs
- **Researchers:** Track gas price trends

## Technical Details

- Uses Chainlink price feeds for accurate ETH/USD conversion
- Calculates costs for 21,000 gas (standard ETH transfer)
- Supports multiple networks through configurable mapping
- Real-time data fetching with error handling

