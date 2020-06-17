pragma solidity ^0.4.0;

contract Funding {
    address manager;
    uint256 public fundingGoal;
    string public projectName;
    string public description;
    uint256 public startTime;
    uint256 public endTime;

    address[] public backers; // all backers address
    mapping(address => uint256) public accounts; // backers' supported money
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
        require(now <= endTime, "Fund raising is currently closed");
        _;
    }

    modifier closed {
        require(now > endTime, "Fund raising is still ongoing");
        _;
    }

    function setDesc(string memory _desc) public onlyManager {
        description = _desc;
    }

    /**
     * support money to the funding
     */
    function support() public payable onGoing {
        addBacker(msg.sender, msg.value);
        raisedMoney += msg.value;
    }

    /**
     * retract money before the fund raising closed.
     */
    function retract(uint256 amount) public onGoing {
        if (amount > 0 && amount <= accounts[msg.sender]) {
            msg.sender.transfer(amount);
            raisedMoney -= amount;
            if (accounts[msg.sender] > amount) {
                accounts[msg.sender] -= amount;
            } else {
                removeBacker(msg.sender);
            }
        }
    }

    function getMySupport() public view returns (uint256 amount) {
        return accounts[msg.sender];
    }

    function addBacker(address backer, uint256 share) internal {
        if (accounts[backer] == 0) backers.push(backer);
        accounts[backer] += share;
    }

    function removeBacker(address backer) internal {
        delete accounts[msg.sender];
        for (uint256 i = 0; i < backers.length; i++) {
            if (backers[i] == backer) {
                delete backers[i];
                break;
            }
        }
    }

    function getBalance() public view returns (uint256) {
        return this.balance;
    }

    function refund() public closed {
        require(raisedMoney >= fundingGoal, "Enough funding has been raised.");
        for(address backer: backers){
            backer.transfer(accounts[backer]);
        }
        selfdestruct(manager);
    }

    // function claimFund() public onlyManager closed {
    //     address payable addr = address(uint160(manager));
    //     addr.transfer(raisedMoney);
    // }
}
