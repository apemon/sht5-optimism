// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Multicall.sol";

pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Game is Ownable, Multicall {
    
    using SafeMath for uint;
    
    address public token_addr;
    uint public pawn_point;
    uint public survival_point;
    mapping(string => uint) public rooms;
    
    event Pawn(address indexed killer, address indexed victim, string room);
    event Survive(address indexed survivor, string room);
    
    constructor() {
        token_addr = 0x99a2f223c862FcCA7e5B1D3a688CffcAAf37fADA;
        pawn_point = 5e17;
        survival_point = 5e17;
    }

    function setAddress(address _token_addr) onlyOwner public {
        token_addr = _token_addr;
    }
    
    function pawn(address _killer, address _victim, string memory _room) onlyOwner public {
        IERC20 token = IERC20(token_addr);
        token.transferFrom(_victim, _killer, pawn_point);
        token.transferFrom(_victim, address(this), survival_point);
        rooms[_room] += survival_point;
        emit Pawn(_killer, _victim, _room);
    }
    
    function survive(address _survivor, string memory _room) onlyOwner public {
        IERC20 token = IERC20(token_addr);
        token.transfer(_survivor, rooms[_room]);
        rooms[_room] = 0;
        emit Survive(_survivor, _room);
    }
}