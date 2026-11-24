
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentAttendance {

    address public teacher;
    uint256 public studentCount;

    struct Student {
        uint256 id;
        string name;
        uint256 totalPresent;
        bool registered;
    }

    mapping(uint256 => Student) public students;

    mapping(uint256 => mapping(uint256 => bool))
        public attendance;

    event StudentRegistered(uint256 studentId, string name);
    event AttendanceMarked(uint256 studentId, uint256 date);

    constructor() {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only teacher can perform this action");
        _;
    }

    function registerStudent(string memory name)
        public onlyTeacher
    {
        require(bytes(name).length > 0, "Name cannot be empty");

        studentCount++;

        students[studentCount] = Student(
            studentCount,
            name,
            0,
            true
        );

        emit StudentRegistered(studentCount, name);
    }

    function markAttendance(uint256 studentId, uint256 date)
        public onlyTeacher
    {
        require(students[studentId].registered, "Student does not exist");
        require(!attendance[studentId][date], "Attendance already marked");

        attendance[studentId][date] = true;
        students[studentId].totalPresent++;

        emit AttendanceMarked(studentId, date);
    }

    function checkAttendance(uint256 studentId, uint256 date)
        public view returns (bool)
    {
        require(students[studentId].registered, "Student does not exist");
        return attendance[studentId][date];
    }

    function getStudent(uint256 studentId)
        public view returns (uint256, string memory, uint256)
    {
        require(students[studentId].registered, "Student does not exist");

        Student memory s = students[studentId];

        return (s.id, s.name, s.totalPresent);
    }

    function getTotalStudents()
        public view returns (uint256)
    {
        return studentCount;
    }
}
