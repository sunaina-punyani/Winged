
var contractInstance,ICOInstance;


function zero(){

	let Web3 = require('web3');
	let web3 = new Web3();
	web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
	const fs = require("fs");
	token = fs.readFileSync('contracts/LATPToken.sol').toString();
	const solc = require('solc')
	compiledToken = solc.compile(token);
	abiDefinition = JSON.parse(compiledToken.contracts[':LATPToken'].interface);
	TokenContract = web3.eth.contract(abiDefinition);
	byteCode = compiledToken.contracts[':LATPToken'].bytecode;
	deployedContract = TokenContract.new({data: byteCode, from: web3.eth.accounts[0], gas: 4700000});

	setTimeout(first,1000,TokenContract,deployedContract);
}	
function tp()
{
	console.log("Done");
}
function first(TokenContract,deployedContract){
	contractInstance = TokenContract.at(deployedContract.address)
	console.log(deployedContract.address);
	const fs = require("fs");
	const solc = require('solc')
	let Web3 = require('web3');

	let web3 = new Web3();
	web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

	var path = require("path");
	const pathICO = path.resolve(__dirname, 'contracts', 'LATOPreICO.sol');

	const pathToken = path.resolve(__dirname, 'contracts', 'LATPToken.sol');
	
	solICO = fs.readFileSync(pathICO, 'utf8');

	var t1 = solICO.substring(0,171);
	var t2 = solICO.substring(213);
	solICO = t1+deployedContract.address+t2;
	console.log(solICO);
	const solToken = fs.readFileSync(pathToken, 'utf8');
	

	const input = {
	  sources: {
	    'LATPToken.sol': solToken,
	    'LATOPreICO.sol': solICO,
	  }
	};


	let compiledContract = solc.compile(input, 1);
	//console.log(compiledContract);

	let abi_token = compiledContract.contracts['LATOPreICO.sol:LATOPreICO'].interface;
	let bytecode_token = '0x'+compiledContract.contracts['LATOPreICO.sol:LATOPreICO'].bytecode;
	let gasEstimate = web3.eth.estimateGas({data: bytecode_token});
	let LATPToken = web3.eth.contract(JSON.parse(abi_token));

	var token_instance = LATPToken.new({
	   from:web3.eth.coinbase,
	   data:bytecode_token,
	   gas: gasEstimate
	 }, function(err, myContract){
	    if(!err) {
	       if(!myContract.address) {
		   //console.log(myContract.transactionHash) 
	       } else {
		   console.log(myContract.address) 
	       }
	    }
	});

	ICOInstance = LATPToken.at(token_instance.address);
	console.log(token_instance.address);
	setTimeout(tp,1000);
}
zero();




	




