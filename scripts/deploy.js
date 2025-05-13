const { ethers } = require("hardhat");

async function main() {
    //const [deployer] = await ethers.getSigners();
    //console.log("Deploying contracts with:", deployer.address);
    //const NewToken = await ethers.getContractFactory("NewToken");
    //const newToken = await NewToken.deploy();
    //const newTokenAddress = await newToken.getAddress();
    //console.log("Token deployed to:", newTokenAddress);

    const rate = 1000;
    const tokenAddress = "0x4Ee0d30752829DD207E4EfFe6116DDda75EE40A5";
    const USDTtokenAddress = "0x4D630A55BbC0c2a923FD85782e709e4d3C4E3e70";
    const Crowdsale = await ethers.getContractFactory("newCrowdSale");
    const crowdsale = await Crowdsale.deploy(rate, tokenAddress, USDTtokenAddress);
    const crowdsaleAddress = await crowdsale.getAddress();
    console.log("CrowdsaleAddress deployed to:", crowdsaleAddress);

    //const [deployer] = await ethers.getSigners();
    //console.log("Deploying USDT tokens with:", deployer.address);
    //const USDTStablecoin = await ethers.getContractFactory("USDTStablecoin");
    //const USDTstablecoin = await USDTStablecoin.deploy();
    //const USDTtokenAddress = await USDTstablecoin.getAddress();
    //console.log("USDT tokens deployed to:", USDTtokenAddress);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
