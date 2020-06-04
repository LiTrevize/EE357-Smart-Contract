pragma solidity >=0.5.0 <=0.7.0;

import "funding.sol";


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

    modifier pendingOp {
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

    function processRequest() public onlyManager closed pendingOp {
        Request storage r = requests[requests.length - 1];
        // more vote than veto
        if (r.numVeto <= backers.length - r.numVeto) {
            address payable addr = address(uint160(manager));
            addr.transfer(r.amount);
            usedMoney += r.amount;
        } else {
            // funded project rejected
            // return remaining money
            uint256 remain = raisedMoney - usedMoney;
            for (uint256 i = 0; i < backers.length; i++) {
                address payable backer = address(uint160(backers[i]));
                backer.transfer((remain * accounts[backer]) / raisedMoney);
            }
        }
        r.processed = true;
    }

    // function claimRequest() public onlyManager closed {
    //
    // }
}
