// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract IVotingContract {
   
    struct Voter {
        uint weight; 
        bool voted; 
        address delegate; 
        uint vote; 
    }

    struct Candidates {
        bytes32 name;   // short name
        uint voteCount; // number of accumulated votes
    }

    address public chairperson; //person allowed to add candidates

    mapping(address => Voter) public voters;

    Candidates[] public candidates; //array of candidates created by chairperson
    
    
interface IVotingContract{

//only one address should be able to add candidates
    function addCandidate(bytes32 name) external returns(bool);

    
    function voteCandidate(uint candidateId) external returns(bool);

    //getWinner returns the name of the winner
    function getWinner() external returns(bytes32);
}
