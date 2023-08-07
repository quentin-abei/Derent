// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Derent is AccessControl, Ownable{

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

    struct Customer {
        string name;
        string address_;
        uint256 customerIdNo;
    }

    uint256 private custCount;
    uint256 private noOfCars;

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

    function setCustomer(address _addr, string memory _name, string memory _address) external {
        customers[_addr].name = _name;
        customers[_addr].address_ = _address;
        customers[_addr].customerIdNo = custCount;
        custCount++;

    }

    function payToRent(uint256 id_) external payable {
        if(msg.value <=0) {
            revert();
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
}