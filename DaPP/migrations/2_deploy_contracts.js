const Funding = artifacts.require("./Funding.sol");
const InsuredFunding = artifacts.require("./InsuredFunding.sol");
const TradableFunding = artifacts.require("./TradableFunding.sol");

module.exports = function(deployer) {
  deployer.deploy(Funding, "Funding", 1, 100000);
  deployer.deploy(InsuredFunding, "InsuredFunding", 1, 100000);
  deployer.deploy(TradableFunding, "TradableFunding",1, 20);
};


