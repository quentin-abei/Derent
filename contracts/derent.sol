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

    function setCars(uint _carNo, string memory _category, uint _tarif) external {
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

    function payToRent() external payable {
        
    }

}