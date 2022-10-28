//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "./RoleHelper.sol";
contract RegulatorRole{

    using RoleHelper for RoleHelper.Role;

    RoleHelper.Role private Regulator;

    event RegulatorAdded(address account);
    event RegulatorRemvoed(address account);

    constructor() {
        _addRegulatorRole(msg.sender);
    }

    modifier onlyRegulator(){
        require(isRegulator(msg.sender),"Not a Regulator");
        _;
    }

    function isRegulator(address account) public view returns(bool){
        return Regulator.has(account);
    }


    function addRegulator(address account) public {
        _addRegulatorRole(account);
    }

    function removeRegulator(address account) public {
        _removeRegulator(account);
    }
     
    function _addRegulatorRole(address account) internal {
            Regulator.add(account);
            emit RegulatorAdded(account);

    }

    function _removeRegulator(address account) internal {
        Regulator.remove(account);
        emit RegulatorRemvoed(account);
    }
}