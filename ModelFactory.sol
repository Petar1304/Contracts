// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Model Factory
 * @author ZentrixLab
 * @notice Contract used for storing records of shares of models and distributing ERC20 tokens according to amount of shares account posses
 * @dev
 */
contract ModelFactory {

    // contracts owner    
    address private _owner;

    // current models id
    uint256 public _modelId;

    // Mapping model_id => address => shares
    mapping(uint256 => mapping(address => uint256)) public _models;

    // Mapping model_id => address[] (used for indexing _models)
    mapping(uint256 => address[]) public _modelAddresses;

    // total shares per model
    mapping(uint256 => uint256) public _modelTotalShares;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }

    /**
     * @dev Transfers ownership of the contract to other address
     * @param _newOwner address of new owner of contract
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        _owner = _newOwner;
    }

    /**
     * @dev Creates mappings between addresses and shares they hold for each new model and increments model_id by 1
     * @param _addresses array of addresses of model shareholders
     * @param _shares amount of shares address owns
     * @return uint256
     */
    function addModel(address[] calldata _addresses, uint256[] calldata _shares) external onlyOwner returns(uint256) {
        require(_addresses.length == _shares.length, "Error: Wrong input size");
        // incrementing model id
        unchecked {
            _modelId += 1;
        }
        for (uint256 i = 0; i < _addresses.length; i++) {
            _addAccount(_modelId, _addresses[i], _shares[i]);
        }
        return _modelId;
    }

    /**
     * @dev Distributes tokens to all share holders of a model given by model id 
     * @param _id models id
     * @param _token address of ERC20 token
     * @param _amount number of tokens that should be distributed to share holders
     */
    function payEveryone(uint256 _id, IERC20 _token, uint256 _amount) external onlyOwner{
        require(_token.balanceOf(msg.sender) >= _amount, "Insufficient funds");
        // loop over all accounts
        for (uint i = 0; i < _modelAddresses[_id].length; i++) {
            _send(_token, _id, _amount, _modelAddresses[_id][i]);
        }
    }

    /**
     * @dev Getter for amount of shares owned by address for particular model
     * @param _id model id number
     * @param _address address
     * @return uint256
     */
    function getShares(uint256 _id, address _address) public view returns (uint256) {
        return _models[_id][_address];
    }

    /**
     * @dev Transfers tokens to _address according to amount of shares _address holds for model
     */
    function _send(IERC20 _token, uint256 _id, uint256 _amount, address _address) internal {
        require(_models[_id][_address] > 0, "Account has no shares");
        uint256 payment = _getPayment(_id, _amount, _address);
        require(payment != 0, "Account is not due payment");
        SafeERC20.safeTransfer(_token, _address, payment);
        // bool sucess = _token.transfer(_address, payment);
        // require(sucess, "Transaction Failed");
    }

    /**
     * @dev Add accounts address and shares for model to contract
     */
    function _addAccount(uint256 _id, address _address, uint256 _share) internal {
        require(_address != address(0), "Account is the zero address");
        require(_share > 0, "Shares are 0");
        _models[_id][_address] = _share;
        _modelAddresses[_id].push(_address);
        _modelTotalShares[_id] += _share;
    }

    /**
     * @dev Calculates how much token should be transacted to account given by _address according to amount of shares it holds 
     */
    function _getPayment(uint256 _id, uint256 _amount, address _address) internal view returns(uint256) {
        uint256 payment = _amount * (_models[_id][_address] / _modelTotalShares[_id]);
        return payment;
    }

}
