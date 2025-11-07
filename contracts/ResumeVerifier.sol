//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ResumeVerifier {
    struct Resume {
        string name;
        string ipfsCid;
        uint uploadedAt;
        bool isVerified;
    }

    mapping(address => Resume[]) private userResumes;
    address public admin;

    event ResumeUploaded(address indexed owner, string ipfsCid, uint timestamp);
    event ResumeVerified(address indexed owner, uint resumeIndex, address indexed verifier, uint timestamp);
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
    event ResumeRejected(address indexed owner, uint resumeIndex, address indexed verifier, uint timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "ONLY ADMIN CAN CALL THIS");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function uploadResume(string calldata _name, string calldata _ipfsCid) external {
        userResumes[msg.sender].push(Resume({
            name: _name,
            ipfsCid: _ipfsCid,
            uploadedAt: block.timestamp,
            isVerified: false
        }));
        emit ResumeUploaded(msg.sender, _ipfsCid, block.timestamp);
    }

    function verifyResume(address _candidate, uint _resumeIndex, bool _shouldVerify) external onlyAdmin {
        require(_resumeIndex < userResumes[_candidate].length, "INVALID RESUME INDEX");
        
        Resume storage resume = userResumes[_candidate][_resumeIndex];
        require(bytes(resume.name).length > 0, "Missing name");
        
        if (_shouldVerify) {
            require(resume.isVerified == false, "RESUME ALREADY VERIFIED");
            resume.isVerified = true;
            emit ResumeVerified(_candidate, _resumeIndex, msg.sender, block.timestamp);
        } else {
            resume.isVerified = false;
            emit ResumeRejected(_candidate, _resumeIndex, msg.sender, block.timestamp);
        }
    }

    function getResume(address _candidate, uint _resumeIndex) external view
    returns (
        string memory name,
        string memory ipfsCid,
        uint uploadedAt,
        bool isVerified
    ) {
        require(_resumeIndex < userResumes[_candidate].length, "INVALID RESUME INDEX");
        Resume storage r = userResumes[_candidate][_resumeIndex];
        return (r.name, r.ipfsCid, r.uploadedAt, r.isVerified);
    }

    function getAllResumes(address _candidate) external view
    returns (Resume[] memory) {
        return userResumes[_candidate];
    }

    function transferAdmin(address _newAdmin) external onlyAdmin{
        require(_newAdmin != address(0), "NEW ADMIN IS ZERO ADDRESS");
        emit AdminTransferred(admin, _newAdmin);
        admin = _newAdmin;
    }
}