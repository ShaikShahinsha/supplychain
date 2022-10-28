//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "./RoleHelper.sol";
contract FishermanRole{
    using RoleHelper for RoleHelper.Role;

    event FishermanAdded(address indexed account);
    event FishermanRemoved(address indexed account);

    RoleHelper.Role private Fishermen;

    constructor(){
        _addFisherman(msg.sender);
    }

    modifier onlyFisherman(){
        require(isFisherman(msg.sender),"Not a fisher man");
        _;
    }

    function isFisherman(address account) public view returns(bool){
        return Fishermen.has(account);
    }

    function addFisherman(address account) public {
        _addFisherman(account);
    }

    function renounceFisherman() public{
        _removeFisherman(msg.sender);
    }
    function _addFisherman(address account) internal {
        Fishermen.add(account);
        emit FishermanAdded(account);
    }

    function _removeFisherman(address account) internal{
        Fishermen.remove(account);
        emit FishermanRemoved(account);
    }

}