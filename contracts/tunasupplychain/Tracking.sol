//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "../tunahelper/FishermanRole.sol";
import "../tunahelper/RegulatorRole.sol";
import "../tunahelper/RestaurantRole.sol";
contract Tracking is FishermanRole, RegulatorRole,RestaurantRole{
    address public supplyChainOwner;
    uint upc;
    uint sku;
    enum State{
        Caught,
        Recorded,
        Audited,
        Bought

    }

    State constant defaultState = State.Caught;

    struct TunaFish{
        uint upc;
        address payable ownerID;
        address originFishermanID;
        string originCoastLocation;
        string tunaNotes;
        uint tunaPrice;
        State tunaState;
        address regulatorID;
        string auditStatus;
        address payable restaurantID;
    }

    mapping(uint => TunaFish) tunaFish;
    mapping(uint => string[]) tunaHistory;


    event Caught(uint upc);
    event Recorded(uint upc);
    event Audited(uint upc);
    event Bought(uint upc);

    modifier verifyCaller (address _address){
        require(msg.sender == _address, "Caller verification was not successful");
        _;
    }

    modifier paidEnough(uint _price){
        require(msg.value >= _price,"Insufficient amount for the quoted price");
        _;
    }

    modifier checkValue(uint _upc){
        uint _price = tunaFish[_upc].tunaPrice;
        uint amountToReturn = msg.value - _price;
        tunaFish[_upc].restaurantID.transfer(amountToReturn);
        _;
    }

    modifier caught(uint _upc){
        require(tunaFish[_upc].tunaState == State.Caught,"Tuna state is still not caught");
        _;
    }

    modifier recorded(uint _upc){
        require(tunaFish[_upc].tunaState == State.Recorded,"Tuna state is still not recorded");
        _;
    }

    modifier audited(uint _upc){
        require(tunaFish[_upc].tunaState == State.Audited,"Tuna state is still not audited");
        _;
    }

    modifier bought(uint _upc){
        require(tunaFish[_upc].tunaState == State.Bought,"Tuna state is still not bought");
        _;
    }
    

    constructor() payable{
        upc = 1;
    }

    function catchTuna(uint _upc, address _originFishermanID, string memory _originCoastLocation) public onlyFisherman(){

        tunaFish[_upc] = TunaFish({

            upc : _upc,
            ownerID: payable(msg.sender),
            originFishermanID: _originFishermanID,
            originCoastLocation: _originCoastLocation,
            tunaNotes: "",
            tunaPrice: 0,
            tunaState: defaultState,
            regulatorID: address(0),
            auditStatus: "",
            restaurantID: payable(address(0))

        });

        upc = upc+1;

        emit Caught(_upc);
    }

    function recordTuna(uint _upc, uint _price, string memory _tunaNotes) public caught (_upc) onlyFisherman() verifyCaller(tunaFish[_upc].ownerID){
        tunaFish[_upc].tunaNotes = _tunaNotes;
        tunaFish[_upc].tunaPrice = _price;
        tunaFish[_upc].tunaState = State.Recorded;

        emit Recorded(_upc);
    }


    function auditTuna(uint _upc, string memory _auditStatus) public recorded(_upc) onlyRegulator(){
        tunaFish[_upc].regulatorID = msg.sender;
        tunaFish[_upc].auditStatus = _auditStatus;
        tunaFish[_upc].tunaState = State.Audited;

        emit Audited(_upc);

    }


    function queryTuna (uint _upc) public view returns (

        address ownerID,
        string memory originCoastLocation,
        string memory tunaNotes,
        uint tunaPrice,
        State tunaState,
        address regulatorID,
        string memory auditStatus

    ){


        return(
             tunaFish[_upc].ownerID,
             tunaFish[_upc].originCoastLocation,
             tunaFish[_upc].tunaNotes,
             tunaFish[_upc].tunaPrice,
             tunaFish[_upc].tunaState,
             tunaFish[_upc].regulatorID,
             tunaFish[_upc].auditStatus
               
        );
    }

    function buyTuna(uint _upc, uint _price) public payable audited(_upc) onlyRestaurant() paidEnough(tunaFish[_upc].tunaPrice) checkValue(_upc){
        tunaFish[_upc].ownerID.transfer(_price);
        tunaFish[_upc].restaurantID = payable(msg.sender);
        tunaFish[_upc].ownerID = payable(msg.sender);
        tunaFish[_upc].tunaState = State.Bought;

        emit Bought(_upc);
    }
    
}


