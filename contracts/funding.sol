pragma solidity >=0.5.0 <=0.7.0;


contract Funding {
    address manager;
    uint256 public fundingGoal;
    string public projectName;
    string public description;
    uint256 public startTime;
    uint256 public endTime;

    address[] public backers;
    mapping(address => uint256) public accounts;
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
        if (accounts[msg.sender] == 0) backers.push(msg.sender);
        accounts[msg.sender] += msg.value;
        raisedMoney += msg.value;
    }

    function getMySupport() public view returns (uint256 amount) {
        return accounts[msg.sender];
    }

    function removeBacker(address backer) internal {
        for (uint256 i = 0; i < backers.length; i++) {
            if (backers[i] == backer) {
                delete backers[i];
                break;
            }
        }
    }

    function retract(uint256 amount) public onGoing {
        if (amount > 0 && amount <= accounts[msg.sender]) {
            msg.sender.transfer(amount);
            raisedMoney -= amount;
            if (accounts[msg.sender] > amount) {
                accounts[msg.sender] -= amount;
            } else {
                delete accounts[msg.sender];
                removeBacker(msg.sender);
            }
        }
    }

    // function claimFund() public onlyManager closed {
    //     address payable addr = address(uint160(manager));
    //     addr.transfer(raisedMoney);
    // }
}
