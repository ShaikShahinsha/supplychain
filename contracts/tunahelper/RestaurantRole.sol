//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "./RoleHelper.sol";
contract RestaurantRole{

    using RoleHelper for RoleHelper.Role;

    RoleHelper.Role private Restaurant;

    event RestaurantAdded(address account);
    event RestaurantRemvoed(address account);

    constructor() {
        _addRestaurantRole(msg.sender);
    }

    modifier onlyRestaurant(){
        require(isRestaurant(msg.sender),"Not a Restaurant");
        _;
    }

    function isRestaurant(address account) public view returns(bool){
        return Restaurant.has(account);
    }


    function addRestaurant(address account) public {
        _addRestaurantRole(account);
    }

    function removeRestaurant(address account) public {
        _removeRestaurant(account);
    }
     
    function _addRestaurantRole(address account) internal {
            Restaurant.add(account);
            emit RestaurantAdded(account);

    }

    function _removeRestaurant(address account) internal {
        Restaurant.remove(account);
        emit RestaurantRemvoed(account);
    }
}