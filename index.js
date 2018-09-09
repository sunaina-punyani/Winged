function first(callback){
 	const fs = require("fs");
	const solc = require('solc')
	let Web3 = require('web3');

	let web3 = new Web3();
	web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));

	var path = require("path");

	const pathMath = path.resolve(__dirname, 'contracts', 'SafeMath.sol');
	//to find the path of A.sol inside the folder 'contract' in your project
	const pathToken = path.resolve(__dirname, 'contracts', 'LATPToken.sol');
	
	const solMath = fs.readFileSync(pathMath, 'utf8');
	const solToken = fs.readFileSync(pathToken, 'utf8');
	
	//console.log("Hi" + typeof solICO);
	const input = {
	  sources: {
	    'SafeMath.sol': solMath,
	    'LATPToken.sol': solToken
	  }
	};


	let compiledContract = solc.compile(input, 1);

	let abi_token = compiledContract.contracts['LATPToken.sol:LATPToken'].interface;
	let bytecode_token = '0x'+compiledContract.contracts['LATPToken.sol:LATPToken'].bytecode;
	let gasEstimate = web3.eth.estimateGas({data: bytecode_token});
	let LATPToken = web3.eth.contract(JSON.parse(abi_token));

	var token_instance = LATPToken.new({
	   from:web3.eth.coinbase,
	   data:bytecode_token,
	   gas: gasEstimate
	 }, function(err, myContract){
	    if(!err) {
	       if(!myContract.address) {
		   console.log(myContract.transactionHash) 
	       } else {
		   console.log(myContract.address) 
	       }
	    }
	});
	token_address = token_instance.address;
	console.log("FFunction"+token_instance.address);
	callback(token_address);
}
function second(token_address){
	const fs = require("fs");
	const solc = require('solc')
	let Web3 = require('web3');

	let web3 = new Web3();
	web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));
	var path = require("path");
	const pathICO = path.resolve(__dirname, 'contracts', 'LATOPreICO.sol');
	const pathToken = path.resolve(__dirname, 'contracts', 'LATPToken.sol');
	const solToken = fs.readFileSync(pathToken, 'utf8');
	const pathMath = path.resolve(__dirname, 'contracts', 'SafeMath.sol');
	var solICO = fs.readFileSync(pathICO).toString();
	const solMath = fs.readFileSync(pathMath, 'utf8');
	//console.log("HELLO" + typeof solICO);
	var t1 = solICO.substring(0,171);
	var t2 = solICO.substring(213);
	solICO = t1+token_address+t2;
	//console.log(solICO);
	const input2 = {
	  sources: {
	'SafeMath.sol': solMath,
	    'LATPToken.sol': solToken,
	    'LATOPreICO.sol': solICO
	  }
	};
	let compiledContract2 = solc.compile(input2, 1);
	//console.log(compiledContract2);
	//console.log(t1);
//console.log();
console.log(token_address);
	
}

first(second);
/*
let abi_ico = compiledContract2.contracts[''].interface;
lefunction some_3secs_function(value, callback){
  //do stuff
  callback();
}t bytecode_token = '0x'+compiledContract.contracts['LATPToken.sol:LATPToken'].bytecode;
let gasEstimate = web3.eth.estimateGas({data: bytecode});
let LATPToken = web3.eth.contract(JSON.parse(abi_token));

var token_instance = LATPToken.new({
   from:web3.eth.coinbase,
   data:bytecode,
   gas: gasEstimate
 }, function(err, myContract){
    if(!err) {
       if(!myContract.address) {
           console.log(myContract.transactionHash) 
       } else {
           console.log(myContract.address) 
       }
    }
});

function some_3secs_function(value, callback){
  //do stuff
  callback();
}
some_3secs_function(some_value, function() {
  some_5secs_function(other_value, function() {
    some_8secs_function(third_value, function() {
      //All three functions have completed, in order.
    });
  });
});






*/

