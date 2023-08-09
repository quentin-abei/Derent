// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Derent is AccessControl, Ownable{
    
    using SafeMath for uint256;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    struct Car {
        string category;
        uint256 tarif;
        bool occupied;
        uint256 review;
        uint256 reviewNo;
        address customerAddress;
        bool booked;
    }

    uint256 private custCount;
    uint256 private noOfCars;
    error ValueIsNullOrNegative();
    error ValueDoesNotMatch();

    mapping (uint256 => Car) public cars;
    mapping(address => Customer) public customers;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMIN_ROLE, _msgSender());

    }

    function setCars(uint256 _carNo, string memory _category, uint _tarif) external {
        require(hasRole(ADMIN_ROLE, _msgSender()), "Not Allowed");
        cars[_carNo].category = _category;
        cars[_carNo].tarif = _tarif;
        cars[_carNo].review = 0;
        cars[_carNo].reviewNo = 0;
        noOfCars++;

    }

    function payToRent(uint256 id_) external payable {
        if(msg.value <=0) {
            revert ValueIsNullOrNegative();
        }
        if(msg.value == 20) {
            bookCarPremium(id_);
        }
        if(msg.value == 10) {
            bookCarStandard(id_);
        }
        if(msg.value == 5) {
            bookCarBasic(id_);
        }
        else {
            revert ValueDoesNotMatch();
        }
    }
    
    function bookCarPremium(uint256 id_ ) internal {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Premium")), "Car does not exist");
        require(cars[id_].booked = false, "Already booked");
        cars[id_].booked = true;
        cars[id_].customerAddress = msg.sender;
    }

    function bookCarStandard(uint256 id_) internal {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Standard")), "Car does not exist");
        require(cars[id_].booked = false, "Already booked");
        cars[id_].booked = true;
        cars[id_].customerAddress = msg.sender;
    }

    function bookCarBasic(uint256 id_) internal {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Basic")), "Car does not exist");
        require(cars[id_].booked = false, "Already booked");
        cars[id_].booked = true;
        cars[id_].customerAddress = msg.sender;
    }

    function  occupyCarPremium(uint256 id_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Premium")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = true;
    }

    function occupyCarStandard(uint id_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Standard")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = true;
    }

    function occupyCarBasic(uint id_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Basic")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = true;
    }

    function returnCarPremium(uint256 id_, uint256 rating_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Premium")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = false;
        cars[id_].booked = false;
        cars[id_].review = ( rating_.add(cars[id_].review.mul(cars[id_].reviewNo)).div(cars[id_].reviewNo+1) );
        cars[id_].reviewNo++;
    }

    function returnCarStandard(uint256 id_, uint256 rating_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Standard")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = false;
        cars[id_].booked = false;
        cars[id_].review = ( rating_.add(cars[id_].review.mul(cars[id_].reviewNo)).div(cars[id_].reviewNo+1) );
        cars[id_].reviewNo++;
    }

    function returnCarBasic(uint256 id_, uint256 rating_) external {
        require(keccak256(bytes(cars[id_].category)) == keccak256(bytes("Basic")), "Car does not exist or is not Premium");
        require(cars[id_].customerAddress == msg.sender, "This car have not be booked by you");
        cars[id_].occupied = false;
        cars[id_].booked = false;
        cars[id_].review = ( rating_.add(cars[id_].review.mul(cars[id_].reviewNo)).div(cars[id_].reviewNo+1) );
        cars[id_].reviewNo++;
    }
}