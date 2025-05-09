const hre = require("hardhat");
const { ethers } = require("ethers");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with:", deployer.address);

    const initialSupply = ethers.parseUnits("1000000", 18); // 1 million tokens

    const Token = await hre.ethers.getContractFactory("NewToken");
    const token = await Token.deploy(initialSupply);
    await token.waitForDeployment();
    const tokenAddress = await token.getAddress();

    console.log("Token deployed to:", tokenAddress);

    const rate = 1000;
    constructorArguments: [1000, "0xEeC9656Ad56C0337A72bCA5E64b968fcf37a4c1"]

    const Crowdsale = await hre.ethers.getContractFactory("newCrowdSale");
    const crowdsale = await Crowdsale.deploy(rate, tokenAddress);
    await crowdsale.waitForDeployment();
    console.log("Crowdsale deployed to:", crowdsale.target);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
