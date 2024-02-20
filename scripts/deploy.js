const hre = require("hardhat");
const { ethers } = require("ethers");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const gasLimit = 30000; 
  const gasPrice = ethers.parseUnits('20', 'gwei');

  // Deploying KRToken contract
  const KRTokenFactory = await hre.ethers.getContractFactory("KRGroupmason");
  const KrToken = await KRTokenFactory.deploy(1000000, 50, {
    gasLimit: gasLimit,
    gasPrice: gasPrice  
  });

  //await KrToken.deployed();

  //console.log("KrToken deployed to:", KrToken.address);

  if (KrToken.deployTransaction) {
    await KrToken.deployTransaction.wait(); // Espera pela transação de implantação ser confirmada
    console.log("KrToken deployed to:", KrToken.address);
  } else {
    console.log("Deployment failed.");
  }

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
