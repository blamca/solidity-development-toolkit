// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 price,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

/**
 * @title GasChecker
 * @notice Real-time gas cost analyzer with USD conversion
 * @dev Fetches current gas prices and ETH price to calculate transaction costs
 */
contract GasChecker is Script {
    
    struct NetworkConfig {
        address ethUsdPriceFeed;
        string networkName;
    }
    
    mapping(uint256 => NetworkConfig) private networkConfigs;
    
    uint256 private constant TRANSFER_GAS = 21000;
    uint256 private constant PRICE_FEED_DECIMALS = 1e8;
    uint256 private constant ETH_DECIMALS = 1e18;
    uint256 private constant MICRO_USD_MULTIPLIER = 1000000;
    uint256 private constant CENTS_DIVISOR = 10000;
    
    constructor() {
        _initializeNetworks();
    }
    
    function run() external view {
        uint256 chainId = block.chainid;
        NetworkConfig memory config = networkConfigs[chainId];
        
        require(config.ethUsdPriceFeed != address(0), "Unsupported network");
        
        uint256 gasPrice = tx.gasprice;
        int256 ethPrice = _getETHPrice(config.ethUsdPriceFeed);
        
        uint256 costInWei = gasPrice * TRANSFER_GAS;
        uint256 costInUSDScaled = (costInWei * uint256(ethPrice)) / PRICE_FEED_DECIMALS;
        uint256 costInMicroUSD = (costInUSDScaled * MICRO_USD_MULTIPLIER) / ETH_DECIMALS;
        
        _displayResults(config.networkName, gasPrice, ethPrice, costInMicroUSD);
    }
    
    function _getETHPrice(address priceFeedAddress) private view returns (int256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeedAddress);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price data");
        return price;
    }
    
    function _displayResults(
        string memory networkName,
        uint256 gasPrice,
        int256 ethPrice,
        uint256 costInMicroUSD
    ) private pure {
        console.log("Network:", networkName);
        console.log("Gas Price:", gasPrice / 1e6, "milli-gwei");
        console.log("ETH Price: $", uint256(ethPrice) / PRICE_FEED_DECIMALS);
        console.log("Transfer Cost: $", costInMicroUSD, "micro-USD");
        console.log("Transfer Cost in USD: ~$0.00", costInMicroUSD / 100);
    }
    
    function _initializeNetworks() private {
        networkConfigs[1] = NetworkConfig({
            ethUsdPriceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419,
            networkName: "Ethereum Mainnet"
        });
        
        networkConfigs[8453] = NetworkConfig({
            ethUsdPriceFeed: 0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70,
            networkName: "Base"
        });
        
        networkConfigs[137] = NetworkConfig({
            ethUsdPriceFeed: 0xF9680D99D6C9589e2a93a78A04A279e509205945,
            networkName: "Polygon"
        });
        
        networkConfigs[42161] = NetworkConfig({
            ethUsdPriceFeed: 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612,
            networkName: "Arbitrum"
        });
        
        networkConfigs[10] = NetworkConfig({
            ethUsdPriceFeed: 0x13e3Ee699D1909E989722E753853AE30b17e08c5,
            networkName: "Optimism"
        });
    }
}