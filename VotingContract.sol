// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

import "./IVotingContract.sol";
contract VotingContract is IVotingContract{

uint deployTime;
event Progress(address indexed sender, string indexed level );

    address  public chairperson;

    struct Candidate{
        uint Id;
        bytes32 name;
        uint voteCount;
    }

    mapping(address => bool) public voted;
    Candidate[] candidateList;
    mapping(bytes32 => Candidate) candidates;

    modifier onlyChairperson() {
        require(chairperson == msg.sender, "only Chairperson can add candidate");
        _;
    }

    modifier hasVoted() {
        require(!voted[msg.sender], "You already casted your vote");
        _;
    }


    constructor(address _chairperson){
         deployTime = block.timestamp;
        chairperson = _chairperson;

        emit Progress(_chairperson, "Nomination of candidate has started");
    }

    function  addCandidate(bytes32 name)  external onlyChairperson override returns (bool){
        if(block.timestamp > deployTime + 180)
        {
             emit Progress(msg.sender, "Nomination of candidate has ended");
          return false;
        }
        bytes32 previousCandidate = candidates[name].name;
        require(previousCandidate != name,"Candidate Already Exist");
        Candidate newCandidate = Candidate({
            Id : candidateList.length,
            name : name,
            voteCount: 0
            });

           candidateList.push(newCandidate);  
           candidates[name] = newCandidate;
        return true;
    }

    function voteCandidate(uint candidateId) external hasVoted override returns(bool){
        require(candidateId < candidateList.length,"Invalid candidate");
        if(block.timestamp > deployTime + 360 || block.timestamp < deployTime + 180){
            return false;
        }
        candidateList[candidateId].voteCount += 1;
        voted[msg.sender] = true;
        return true;
    }

    function getWinner() external  view returns(Candidate memory){
         if(block.timestamp < deployTime + 360){
            revert("voting still ongoing");
        }
        require(candidateList.length > 0,"No candidate");
        uint maxVote = 0;
        Candidate memory winner;
        for(uint i = 0; i < candidateList.length; i++)
        {
            Candidate memory candidate = candidateList[i];
            if(candidate.voteCount > maxVote)
            {
                maxVote = candidate.voteCount;
                winner = candidate;
            }

        }
        return winner;
    }

}