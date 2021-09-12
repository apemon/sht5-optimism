// SPDX-License-Identifier: GPL-3.0

import "@openzeppelin/contracts/utils/Address.sol";

pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;
/**
 * @dev Provides a function to batch together multiple calls in a single external call.
 *
 * _Available since v4.1._
 */
abstract contract Multicall {
    /**
    * @dev Receives and executes a batch of function calls on this contract.
    */
    function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint i = 0; i < data.length; i++) {
            results[i] = Address.functionDelegateCall(address(this), data[i]);
        }
        return results;
    }
}