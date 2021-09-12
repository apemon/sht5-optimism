// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

pragma solidity >=0.6.0 <0.8.0;

contract Token is ERC20 {
    using SafeMath for uint;
    
    constructor (string memory _name, string memory _symbol) 
        ERC20(_name, _symbol) {
            
        }
        
    function mint(address _recipient, uint256 _amount) public payable {
        _mint(_recipient, _amount);
    }
}