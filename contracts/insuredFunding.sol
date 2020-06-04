pragma solidity >=0.5.0;

import "funding.sol";


contract InsuredFunding is Funding {
    struct Request {
        uint256 startTime;
        uint256 endTime;
        uint8 percent;
        bool processed;
        mapping(address => bool) votes;
        mapping(address => bool) vetos;
    }
    Request[] public requests;
    uint8 public usedPercent = 0;
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

    modifier requested {
        require(
            requests.length > 0 && requests[requests.length - 1].endTime >= now,
            "No claim request"
        );
        _;
    }

    modifier notProcessed {
        require(
            !requests[requests.length - 1].processed,
            "Request has been processed"
        );
        _;
    }

    function postRequest(uint8 percent, uint256 duration)
        public
        onlyManager
        noRequest
    {
        require(percent + usedPercent <= 100, "Invalid percentage request");
        uint256 cur = now;
        Request memory r = Request(cur, cur + duration, percent, false);
        requests.push(r);
    }

    function vote(bool agree) public requested {
        require(backers[msg.sender] > 0, "Only backers can vote.");
        Request storage r = requests[requests.length - 1];
        require(
            !r.votes[msg.sender] && !r.vetos[msg.sender],
            "You have voted."
        );
        if (agree) r.votes[msg.sender] = true;
        else r.vetos[msg.sender] = true;
    }

    function processRequest() public onlyManager requested notProcessed {}

    // function claimRequest() public onlyManager closed {
    //     address payable addr = address(uint160(manager));
    //     addr.transfer(raisedMoney * depositRate);
    // }
}
