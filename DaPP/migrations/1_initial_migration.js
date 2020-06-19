const Migrations = artifacts.require("Migrations");
//const Funding = artifacts.require("./Funding")
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  //deployer.deploy(Funding);
};
