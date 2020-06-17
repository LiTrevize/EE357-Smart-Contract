pragma solidity ^0.4.0;

import "Funding.sol";


contract InsuredFunding is Funding {
    struct Request {
        uint256 startTime;
        uint256 endTime;
        uint256 amount;
        bool processed;
        uint256 numVote;
        uint256 numVeto;
        mapping(address => bool) votes;
        mapping(address => bool) vetos;
    }
    Request[] public requests;
    uint256 public usedMoney = 0;

    constructor(
        string memory _name,
        uint256 _goal,
        uint256 _duration
    ) public Funding(_name, _goal, _duration) {}

    modifier noRequest {
        require(
            requests.length == 0 || requests[requests.length - 1].processed,
            "There is already an open claim request"
        );
        _;
    }

    modifier openReq {
        require(
            requests.length > 0 && requests[requests.length - 1].endTime >= now,
            "No open request"
        );
        _;
    }

    modifier pendingResult {
        require(
            requests.length > 0 && requests[requests.length - 1].endTime < now,
            "Vote has not finished."
        );
        require(
            !requests[requests.length - 1].processed,
            "Request has been processed"
        );
        _;
    }

    /**
     * post a request to use a portion of the raised money
     */
    function postRequest(uint256 amount, uint256 duration)
        public
        onlyManager
        noRequest
    {
        require(amount + usedMoney <= raisedMoney, "Invalid request money");
        uint256 cur = now;
        Request memory r = Request(cur, cur + duration, amount, false, 0, 0);
        requests.push(r);
    }

    /**
     * backers can vote for the request
     */
    function vote(bool agree) public openReq {
        require(accounts[msg.sender] > 0, "Only backers can vote.");
        Request storage r = requests[requests.length - 1];
        require(
            !r.votes[msg.sender] && !r.vetos[msg.sender],
            "You have voted."
        );
        if (agree) {
            r.votes[msg.sender] = true;
            r.numVote += 1;
        } else {
            r.vetos[msg.sender] = true;
            r.numVeto += 1;
        }
    }

    /**
     * The fund manager call the function to complete the request
     * If successful, the manager gets the desired money
     * Otherwise, the funding ended,
     * all the remaining money is returned to the backers
     */
    function completeReq() public onlyManager closed pendingResult {
        Request storage r = requests[requests.length - 1];
        // more vote than veto
        if (r.numVeto <= backers.length - r.numVeto) {
            // address payable addr = address(uint160(manager));
            manager.transfer(r.amount);
            usedMoney += r.amount;
            r.processed = true;
        } else {
            // funded project rejected
            // return remaining money
            uint256 remain = raisedMoney - usedMoney;
            for (uint256 i = 0; i < backers.length; i++) {
                // address payable backer = address(uint160(backers[i]));
                address backer = backers[i];
                backer.transfer((remain * accounts[backer]) / raisedMoney);
            }
            r.processed = true;
            selfdestruct(manager);
        }
    }
}