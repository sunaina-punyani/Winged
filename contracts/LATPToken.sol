pragma solidity ^0.4.17;



contract Token {

    uint256 public totalSupply;
    
    uint256 public totalSupply;

    function balanceOf(address _owner) constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    function approve(address _spender, uint256 _value) returns (bool success);

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);

    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Issuance(address indexed _to, uint256 _value);
    event Burn(address indexed _from, uint256 _value);
}

contract StandardToken is Token {

    address     public nse              =       0xc26505864d1f6cbda2339483119e9321254fc7a9;
    uint        public threshold        =       5;
     
    enum ApprovalStatus { Pending, Approved, Rejected }
    
    
    struct TransferToken{
        address from;
        address to;
        uint256 tokens;
        ApprovalStatus status;
        bool rejected;
        uint expirationDate;
        bool exists;
    }
    
    mapping(address => mapping(address => TransferToken)) public _transfers;
    
     modifier onlyNSE() {
        if (msg.sender != nse) {
            throw;
        }
        _;
    }
    
    function createTransfer(address _from, address _to, uint _tokens) public{
        balances[_from]-=_tokens;
        if(_transfers[_from][_to].exists){
            _transfers[_from][_to].tokens+=_tokens;
        }
        else{
        _transfers[_from][_to] = TransferToken(_from,_to,_tokens,ApprovalStatus.Pending,false,now + 3 days,true);
        }
        //emit TransferCreation(_from,_to,tokens);
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            //if(_value > threshold){
                createTransfer(msg.sender,_to,_value);
            //}
            //else{
                // balances[msg.sender] -= _value;
                // balances[_to] += _value;
                // Transfer(msg.sender, _to, _value);
                return true;
            //}
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {

        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            //if(_value > threshold){
                createTransfer(_from,_to,_value);
            //}
            //else{
                // balances[_to] += _value;
                // balances[_from] -= _value;
                // allowed[_from][msg.sender] -= _value;
                // Transfer(_from, _to, _value);
                return true;
           // }
        } else { return false; }
    }
    
    function nseApproval(address _from, address _to,bool status) onlyNSE {
        require(msg.sender == nse);
        //TransferToken storage transfer = _transfers[_from][_to];
        //transfer.rejected = true;
        if(_transfers[_from][_to].exists){
            if(status == true){
                _transfers[_from][_to].rejected = false;
                _transfers[_from][_to].status = ApprovalStatus.Approved;
                balances[_to] += _transfers[_from][_to].tokens;
                allowed[_from][msg.sender] -= _transfers[_from][_to].tokens;
                
                
            }
            else if(status == false){
                _transfers[_from][_to].rejected = true;
                _transfers[_from][_to].status = ApprovalStatus.Rejected;
                balances[_from] += _transfers[_from][_to].tokens;
            }
        }
        _transfers[_from][_to].exists=false;
    }
    function reject(address _from, address _to) public{
        require(_from == msg.sender);
        //TransferToken storage transfer = _transfers[_from][_to];
        if(_transfers[_from][_to].exists){
            if(_transfers[_from][_to].expirationDate < now){
                balances[_from]+=_transfers[_from][_to].tokens;
                 
            }
            _transfers[_from][_to].exists=false;
        }
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        string memory signature = "receiveApproval(address,uint256,address,bytes)";

        if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {
            throw;
        }

        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
    
    

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract LATPToken is StandardToken {


    address     public founder;
    address     public minter;
    
    string      public name             =       "LATO PreICO";
    uint8       public decimals         =       6;
    string      public symbol           =       "LATP";
    string      public version          =       "0.7.1";
    uint        public maxTotalSupply   =       100000 ;
   

    modifier onlyFounder() {
        if (msg.sender != founder) {
            throw;
        }
        _;
    }

    modifier onlyMinter() {
        if (msg.sender != minter) {
            throw;
        }
        _;
    }
   
   //event Print(string _name, uint _value);
   
   function setBalance(){
        balances[founder] = maxTotalSupply;
    }

   
    function issueTokens(address _for, uint tokenCount)
        external
        payable
    //    onlyMinter
        returns (bool)
    {
       uint tokenSupply1 = 1;
        if (tokenCount == 0) {
            return false;
        }

        if ((totalSupply+tokenCount) > maxTotalSupply) {
            throw;
        }
        

       // Print("totalSupply",totalSupply);

        totalSupply = (totalSupply+ tokenCount);
        balances[_for] = (balances[_for]+ tokenCount);
        balances[founder] = (balances[founder]-tokenCount);
        Issuance(_for, tokenCount);
        return true;
    }

    function burnTokens(address _for, uint tokenCount)
        external
        onlyMinter
        returns (bool)
    {
        if (tokenCount == 0) {
            return false;
        }

        if ((totalSupply-tokenCount) > totalSupply) {
            throw;
        }

        if ((balances[_for]-tokenCount) > balances[_for]) {
            throw;
        }

        totalSupply = (totalSupply-tokenCount);
        balances[_for] = (balances[_for]- tokenCount);
        Burn(_for, tokenCount);
        return true;
    }

    function changeMinter(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        minter = newAddress;
    }

    function changeFounder(address newAddress)
        public
        onlyFounder
        returns (bool)
    {   
        founder = newAddress;
    }

    function () {
        throw;
    }

    constructor () public payable{
        founder = msg.sender;
        totalSupply = 0; // Update total supply
    }
}
