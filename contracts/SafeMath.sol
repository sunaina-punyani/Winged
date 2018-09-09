pragma solidity ^0.4.17;

contract SafeMath {
    function mul(uint a, uint b) external returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) external returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function sub(uint a, uint b) external returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) external returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    function assert(bool assertion) external {
        if (!assertion) {
            throw;
        }
    }
}

