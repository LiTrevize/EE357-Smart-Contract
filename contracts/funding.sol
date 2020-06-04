pragma solidity >=0.5.0;

contract Funding {
    address manager;
    uint256 public fundingGoal;
    string public projectName;
    string public description;
    uint256 public startTime;
    uint256 public endTime;

    mapping(address => uint256) public backers;
    uint256 public raisedMoney = 0;

    constructor(
        string memory _name,
        uint256 _goal,
        uint256 _duration
    ) public {
        manager = msg.sender;
        projectName = _name;
        fundingGoal = _goal;
        startTime = now;
        endTime = startTime + _duration;
    }

    modifier onlyManager {
        require(msg.sender == manager, "Only the manager can do this");
        _;
    }

    modifier onGoing {
        require(now <= endTime, "Funding is currently closed");
        _;
    }

    modifier closed {
        require(now > endTime, "Funding is currently closed");
        _;
    }

    function setDesc(string memory _desc) public onlyManager {
        description = _desc;
    }

    function support() public payable onGoing {
        backers[msg.sender] += msg.value;
        raisedMoney += msg.value;
    }

    function getMySupport() public view returns (uint256 amount) {
        return backers[msg.sender];
    }

    function retract(uint256 amount) public onGoing {
        if (amount > 0 && amount <= backers[msg.sender]) {
            msg.sender.transfer(amount);
            raisedMoney -= amount;
            if (backers[msg.sender] > amount) {
                backers[msg.sender] -= amount;
            } else {
                delete backers[msg.sender];
            }
        }
    }

    // function claimFund() public onlyManager closed {
    //     address payable addr = address(uint160(manager));
    //     addr.transfer(raisedMoney);
    // }
}
