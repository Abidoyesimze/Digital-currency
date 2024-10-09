import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployVendor: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy YourToken if it hasn't been deployed yet
  const yourTokenDeployment = await deploy("YourToken", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const yourToken = await hre.ethers.getContractAt("YourToken", yourTokenDeployment.address);

  // Deploy Vendor
  const vendorDeployment = await deploy("Vendor", {
    from: deployer,
    args: [yourTokenDeployment.address], // Assuming 0.1 ETH per token
    log: true,
    autoMine: true,
  });

  const vendor = await hre.ethers.getContractAt("Vendor", vendorDeployment.address);
 
  // Transfer tokens to Vendor
  await yourToken.transfer(vendorDeployment.address, hre.ethers.parseEther("1000"));

  // Transfer Vendor ownership to frontend address
  await vendor.transferOwnership("0xF7c74858f17A0a880F3AA1D44FA2Cb85165f6944");

  console.log("YourToken deployed to:", yourTokenDeployment.address);
  console.log("Vendor deployed to:", vendorDeployment.address);
  console.log("1000 tokens transferred to Vendor");
  console.log("Vendor ownership transferred to: 0xF7c74858f17A0a880F3AA1D44FA2Cb85165f6944");
};

export default deployVendor;

deployVendor.tags = ["Vendor"];