//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "../tunasupplychain/Tracking.sol";
import "./Admin.sol";
contract Gateway is Tracking,Admin{
    constructor() payable{

    }

    // function kill() public onlyOwner(){
    //     selfdestruct(payable(msg.sender));
    // }

    function transferOwner(address newOwner) public onlyOwner(){
        transferOwnership(newOwner);
    }
}