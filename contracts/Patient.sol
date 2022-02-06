// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/// @title Patient contract
/// @author Maruf Ahmed Robin
contract Patient {
    address public owner;
    PatientInfo private patientInfo;
    mapping(address => bool) doctors;
    mapping(address => MedicalRecord) medical_records;
    uint256 nonce = 0;

    enum GENDER {
        MALE,
        FEMALE,
        OTHER
    }

    enum RECORD_STATUS {
        CREATED,
        DELETED,
        CHANGED,
        QURIED,
        PRINTED,
        COPIED
    }

    struct MedicalRecord {
        PatientInfo patient;
        RECORD_STATUS status;
        address doctor;
        string data; // data of the medical record with text and images data
        uint256 timestamp; // timestampt of the medical record creation
    }

    struct InsuranceInfo {
        string insurance;
        string insuranceID;
        string insurancePhone;
        string insuranceAddress;
        string insuranceEmail;
    }

    // birthday
    struct Birthday {
        uint256 year;
        uint256 month;
        uint256 day;
    }

    //contract
    struct Address {
        string lat;
        string lng;
        string street;
        string city;
        string zip;
    }

    struct ContractInfo {
        string phone;
        string email;
    }

    struct PatientInfo {
        string name;
        GENDER gender;
        ContractInfo contactInfo;
        Birthday birthday;
        InsuranceInfo insurance;
    }

    // constructor
    constructor(
        string memory _name,
        GENDER _gender,
        string memory _phone,
        string memory _email
    ) {
        owner = msg.sender;
        patientInfo = PatientInfo({
            name: _name,
            gender: _gender,
            contactInfo: ContractInfo({phone: _phone, email: _email}),
            birthday: Birthday({year: 0, month: 0, day: 0}),
            insurance: InsuranceInfo({
                insurance: "",
                insuranceID: "",
                insurancePhone: "",
                insuranceAddress: "",
                insuranceEmail: ""
            })
        });
    }

    // update insurance info
    function updateInsuranceInfo(
        string memory _insurance,
        string memory _insuranceID,
        string memory _insurancePhone,
        string memory _insuranceAddress,
        string memory _insuranceEmail
    ) public onlyOwner {
        patientInfo.insurance = InsuranceInfo({
            insurance: _insurance,
            insuranceID: _insuranceID,
            insurancePhone: _insurancePhone,
            insuranceAddress: _insuranceAddress,
            insuranceEmail: _insuranceEmail
        });
    }

    // @title update patient info
    // @param _name patient name
    // @param _gender patient gender
    function updateProfile(
        string memory _name,
        GENDER _gender,
        string memory _phone,
        string memory _email,
        uint256 _year,
        uint256 _month,
        uint256 _day
    ) public onlyOwner {
        // Update basic info
        if (bytes(_name).length > 0) {
            patientInfo.name = _name;
        }

        patientInfo.gender = _gender;

        // Update contact info
        patientInfo.contactInfo.phone = _phone;
        patientInfo.contactInfo.email = _email;

        // Update birthday
        patientInfo.birthday.year = _year;
        patientInfo.birthday.month = _month;
        patientInfo.birthday.day = _day;
    }

    function getPatientInfo()
        public
        view
        onlyOwner
        returns (PatientInfo memory)
    {
        return patientInfo;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function requestForAppointment() public view onlyOwner returns (bytes32) {
        // unit id
        return keccak256(abi.encodePacked(patientInfo.name, block.timestamp));
    }

    function generateUniqueHash() public onlyOwner returns (bytes32) {
        return keccak256(abi.encodePacked("secret", nonce++));
    }
}
