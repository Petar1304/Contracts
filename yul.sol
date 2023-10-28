// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Assembly {

    function ful_let(uint256 x) public pure returns (uint256 z) {
        assembly {
            // if lt(x, 10) {
            //     z := 99
            // }

            switch x 
            case 1 {
                z := 10
            }
            case 2 {
                z := 20
            }
            default {
                z := 30
            }

            // revert(0, 0)
        }
    }

    function yul_for_loop() public pure returns (uint256 z) {
        assembly {
            for { let i := 0 } lt (i, 10) { i := add(i, 1) } {
                z := add(z, 1)
            }
        }
    }
}

