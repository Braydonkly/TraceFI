// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TraceFI {
    struct Client {
        uint id;
        address addedBy;
        string name;
        string nric;
        string nationality;
        string citizenship;
        string addressLine;
        string postalCode;
        string gender;
        string countryOfBirth;
        string dateOfBirth;
        string homeNumber;
        string phoneNumber;
        string occupation;
        string employerName;
        string employerNumber;
        string riskStatus;
        string image;
        string[] txHistory;
    }

    Client[] private clients;

    // Register a new client
    function registerClient(
        string calldata _name,
        string calldata _nric,
        string calldata _nationality,
        string calldata _citizenship,
        string calldata _addressLine,
        string calldata _postalCode,
        string calldata _gender,
        string calldata _countryOfBirth,
        string calldata _dateOfBirth,
        string calldata _homeNumber,
        string calldata _phoneNumber,
        string calldata _occupation,
        string calldata _employerName,
        string calldata _employerNumber,
        string calldata _riskStatus,
        string calldata _image
    ) external {
        clients.push(Client({
            id: clients.length,
            addedBy: msg.sender,
            name: _name,
            nric: _nric,
            nationality: _nationality,
            citizenship: _citizenship,
            addressLine: _addressLine,
            postalCode: _postalCode,
            gender: _gender,
            countryOfBirth: _countryOfBirth,
            dateOfBirth: _dateOfBirth,
            homeNumber: _homeNumber,
            phoneNumber: _phoneNumber,
            occupation: _occupation,
            employerName: _employerName,
            employerNumber: _employerNumber,
            riskStatus: _riskStatus,
            image: _image,
            txHistory: new string[](0)
        }));
    }

    // Add transaction to a specific client ID
    function addTransaction(uint clientId, string calldata _tx) external {
        require(clientId < clients.length, "Client does not exist");
        require(clients[clientId].addedBy == msg.sender, "Only creator can update");
        clients[clientId].txHistory.push(_tx);
    }

    //NEW: Delete a client permanently by shifting the array
    function deleteClient(uint id) external {
        require(id < clients.length, "Invalid client ID");

        // Shift all clients after the one being deleted
        for (uint i = id; i < clients.length - 1; i++) {
            clients[i] = clients[i + 1];
            clients[i].id = i; // Update shifted client's ID
        }

        // Remove the last client (now duplicated)
        clients.pop();
    }

    // Get a client's details by ID
    function getClientById(uint id) external view returns (
        uint,
        address,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
    ) {
        require(id < clients.length, "Invalid ID");
        Client storage c = clients[id];
        return (
            c.id,
            c.addedBy,
            c.name,
            c.nric,
            c.nationality,
            c.citizenship,
            c.addressLine,
            c.postalCode,
            c.gender,
            c.countryOfBirth,
            c.dateOfBirth,
            c.homeNumber,
            c.phoneNumber,
            c.occupation,
            c.employerName,
            c.employerNumber,
            c.riskStatus,
            c.image
        );
    }

    // Get all transaction strings by client ID
    function getTransactions(uint id) external view returns (string[] memory) {
        require(id < clients.length, "Client not found");
        return clients[id].txHistory;
    }

    // Get number of clients
    function getClientCount() external view returns (uint) {
        return clients.length;
    }

    // Get all clients (frontend expects this)
    function getAllClients() external view returns (Client[] memory) {
        return clients;
    }
}
