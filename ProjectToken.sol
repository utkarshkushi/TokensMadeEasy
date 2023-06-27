//SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ProjectToken is ERC20 {
    address public owner;
    

    uint public NoofTokensPerETH;
    
    constructor (string memory _name, string memory _symbol, address _contractOwnerAddress, uint _noOfTokens, uint _noOfTokensPerETH) ERC20(_name, _symbol){
        owner = _contractOwnerAddress ;
        NoofTokensPerETH = _noOfTokensPerETH;
        _mint(owner, _noOfTokens * 10**18);
    }  

    function buyTokens(address _buyer) external{
        _mint(_buyer, NoofTokensPerETH * 10**18);
    }
}

interface ProjectTokenInterface{
    function buyTokens(address account) external;
    function totalSupply() external;
    function name() external returns(string memory);
    function symbol() external returns(string memory);
    function balanceOf(address account) external returns(uint256);
    function transfer(address recipient, uint256 amount) external returns(bool);
    function NoofTokensPerETH() external returns(uint);
    }

contract ProjectTokenFactory{
    ProjectToken[] public projectTokenArray;
    mapping(address => uint) public addressIndex;
    mapping(address => bool) public deployedAddress;
    mapping(address => address) public contractOwner;

    event balance(uint bal);
    event tokensPerEth(uint tok);
    event name(string  name);
    event symbol(string  symbol);

    address payable public owner;
    constructor (){
        owner = payable(msg.sender);
    }
   
    function createNewProjectToken(string memory _name, string memory _symbol, uint _noOfTokens, uint _noOfTokensPerETH) 
    external payable {
        require(msg.value == 1 ether, "not enough ether");
        ProjectToken projectToken = new ProjectToken(_name, _symbol,msg.sender, _noOfTokens, _noOfTokensPerETH);
        projectTokenArray.push(projectToken);
        addressIndex[address(projectToken)] = projectTokenArray.length + 1;
        deployedAddress[address(projectToken)] = true;
        contractOwner[msg.sender] = address(projectToken);
        owner.transfer(msg.value);
    }

    function mintYourContractTokens(address _contractOwnerAddress) 
    external 
    payable {
       require(contractOwner[_contractOwnerAddress] != address(0), "this address is not associated with any contract address");
       require(msg.value == 1 ether, "not enough eth");
       address contractAddress = contractOwner[_contractOwnerAddress];
       payable(_contractOwnerAddress).transfer(msg.value);
       ProjectTokenInterface proTok = ProjectTokenInterface(contractAddress);
       proTok.buyTokens(msg.sender);
    } 

    function knowYourContractAddress()
    external 
    view 
    returns(address){
        return (contractOwner[msg.sender]);
    }

    function knowTokenName(address _contractOwnerAddress)
    external 
    returns(string memory){
        emit name(ProjectTokenInterface(contractOwner[_contractOwnerAddress]).name());
        return (ProjectTokenInterface(contractOwner[_contractOwnerAddress]).name());
    }

    function knowTokenSymbol(address _contractOwnerAddress)
    external 
    returns(string memory){
        emit symbol(ProjectTokenInterface(contractOwner[_contractOwnerAddress]).symbol());
        return (ProjectTokenInterface(contractOwner[_contractOwnerAddress]).symbol());
    }                                                                                   

    function knowNoOfTokensPerETH(address _contractOwnerAddress)
    external 
    returns(uint){
        emit tokensPerEth(ProjectTokenInterface(contractOwner[_contractOwnerAddress]).NoofTokensPerETH());
        return (ProjectTokenInterface(contractOwner[_contractOwnerAddress]).NoofTokensPerETH());
    }

    function knowYourBalance(address _contractOwnerAddress) 
    external 
    returns(uint){
        emit balance(ProjectTokenInterface(contractOwner[_contractOwnerAddress]).balanceOf(msg.sender));
        return (ProjectTokenInterface(contractOwner[_contractOwnerAddress]).balanceOf(msg.sender));
    }

}






