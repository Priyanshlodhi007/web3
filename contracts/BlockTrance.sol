// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BlockTrance
 * @dev Lightweight ETH escrow and transfer hub with labeled payment flows
 * @notice Users can create labeled transfers, lock funds, and release or refund via simple rules
 */
contract BlockTrance {
    address public owner;
    uint256 public nextTransferId;

    enum TransferState {
        Pending,
        Released,
        Refunded,
        Canceled
    }

    struct Transfer {
        uint256 id;
        address payer;
        address payee;
        uint256 amount;
        string  label;        // e.g. "milestone-1", "service-fee"
        uint256 createdAt;
        TransferState state;
    }

    // transferId => Transfer
    mapping(uint256 => Transfer) public transfers;

    // payer => transferIds
    mapping(address => uint256[]) public transfersByPayer;

    // payee => transferIds
    mapping(address => uint256[]) public transfersByPayee;

    event TransferCreated(
        uint256 indexed id,
        address indexed payer,
        address indexed payee,
        uint256 amount,
        string label,
        uint256 createdAt
    );

    event TransferReleased(
        uint256 indexed id,
        address indexed payer,
        address indexed payee,
        uint256 amount,
        uint256 timestamp
    );

    event TransferRefunded(
        uint256 indexed id,
        address indexed payer,
        uint256 amount,
        uint256 timestamp
    );

    event TransferCanceled(
        uint256 indexed id,
        address indexed payer,
        uint256 timestamp
    );

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyPayer(uint256 id) {
        require(transfers[id].payer == msg.sender, "Not payer");
        _;
    }

    modifier onlyPayee(uint256 id) {
        require(transfers[id].payee == msg.sender, "Not payee");
        _;
    }

    modifier transferExists(uint256 id) {
        require(transfers[id].amount > 0, "Transfer not found");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Create a new escrowed transfer to a payee
     * @param payee Recipient address
     * @param label Human-readable label for this transfer
     */
    function createTransfer(address payee, string calldata label)
        external
        payable
        returns (uint256 id)
    {
        require(payee != address(0), "Invalid payee");
        require(msg.sender != payee, "Self transfer not allowed");
        require(msg.value > 0, "Amount must be > 0");

        id = nextTransferId;
        nextTransferId += 1;

        transfers[id] = Transfer({
            id: id,
            payer: msg.sender,
            payee: payee,
            amount: msg.value,
            label: label,
            createdAt: block.timestamp,
            state: TransferState.Pending
        });

        transfersByPayer[msg.sender].push(id);
        transfersByPayee[payee].push(id);

        emit TransferCreated(
            id,
            msg.sender,
            payee,
            msg.value,
            label,
            block.timestamp
        );
    }

    /**
     * @dev Payer releases funds to payee
     * @param id Transfer identifier
     */
    function release(uint256 id)
        external
        transferExists(id)
        onlyPayer(id)
    {
        Transfer storage t = transfers[id];
        require(t.state == TransferState.Pending, "Not pending");

        t.state = TransferState.Released;

        uint256 amount = t.amount;
        t.amount = 0;

        (bool ok, ) = payable(t.payee).call{value: amount}("");
        require(ok, "Transfer failed");

        emit TransferReleased(id, t.payer, t.payee, amount, block.timestamp);
    }

    /**
     * @dev Payer can refund funds back to themselves (if not yet released)
     * @param id Transfer identifier
     */
    function refund(uint256 id)
        external
        transferExists(id)
        onlyPayer(id)
    {
        Transfer storage t = transfers[id];
        require(t.state == TransferState.Pending, "Not pending");

        t.state = TransferState.Refunded;

        uint256 amount = t.amount;
        t.amount = 0;

        (bool ok, ) = payable(t.payer).call{value: amount}("");
        require(ok, "Refund failed");

        emit TransferRefunded(id, t.payer, amount, block.timestamp);
    }

    /**
     * @dev Payee can mark transfer as canceled if they choose not to accept,
     *      payer can later refund or re-route off-chain.
     *      No funds move here, just state tagging.
     * @param id Transfer identifier
     */
    function cancelByPayee(uint256 id)
        external
        transferExists(id)
        onlyPayee(id)
    {
        Transfer storage t = transfers[id];
        require(t.state == TransferState.Pending, "Not pending");
        t.state = TransferState.Canceled;

        emit TransferCanceled(id, t.payer, block.timestamp);
    }

    /**
     * @dev Get all transfers created by a payer
     */
    function getTransfersByPayer(address payer)
        external
        view
        returns (uint256[] memory)
    {
        return transfersByPayer[payer];
    }

    /**
     * @dev Get all transfers assigned to a payee
     */
    function getTransfersByPayee(address payee)
        external
        view
        returns (uint256[] memory)
    {
        return transfersByPayee[payee];
    }

    /**
     * @dev Get contract ETH balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Transfer contract ownership
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        address prev = owner;
        owner = newOwner;
        emit OwnershipTransferred(prev, newOwner);
    }
}
