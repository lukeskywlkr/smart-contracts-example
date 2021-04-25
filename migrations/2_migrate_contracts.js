let ProofOfExistence1 = artifacts.require("../contracts/ProofOfExistence1.sol")
let AwesomeAward = artifacts.require("../contracts/AwesomeAward.sol")
module.exports = function(deployer) {
  deployer.deploy(ProofOfExistence1)
  deployer.deploy(AwesomeAward)
}