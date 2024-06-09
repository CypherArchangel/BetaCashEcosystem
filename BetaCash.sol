// SPDX-License-Identifier: MIT
//Based on OpenZeppelin ERC20 Token Standard (credit to them):
// 1. All Contracts are the same except for the ERC20 one and a minor change in the ERC20Votes one, 
//    only libraries change to minimize content.
// 2. ERC20 Contract is heavily modified. Please read carefully.

//by Cypher Archangel

pragma solidity ^0.8.20;

library SafeCast {
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);

    function toUint208(uint256 value) internal pure returns (uint208) {
        if (value > type(uint208).max) {
            revert SafeCastOverflowedUintDowncast(208, value);
        }
        return uint208(value);
    }

    function toUint48(uint256 value) internal pure returns (uint48) {
        if (value > type(uint48).max) {
            revert SafeCastOverflowedUintDowncast(48, value);
        }
        return uint48(value);
    }

    function toUint32(uint256 value) internal pure returns (uint32) {
        if (value > type(uint32).max) {
            revert SafeCastOverflowedUintDowncast(32, value);
        }
        return uint32(value);
    }
    
}

pragma solidity ^0.8.20;

interface IERC6372 {
    function clock() external view returns (uint48);
    function CLOCK_MODE() external view returns (string memory);
}

pragma solidity ^0.8.20;

interface IVotes {
    error VotesExpiredSignature(uint256 expiry);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    event DelegateVotesChanged(address indexed delegate, uint256 previousVotes, uint256 newVotes);
    function getVotes(address account) external view returns (uint256);
    function getPastVotes(address account, uint256 timepoint) external view returns (uint256);
    function getPastTotalSupply(uint256 timepoint) external view returns (uint256);
    function delegates(address account) external view returns (address);
    function delegate(address delegatee) external;
    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external;
}

pragma solidity ^0.8.20;

interface IERC5805 is IERC6372, IVotes {}

pragma solidity ^0.8.20;

abstract contract Nonces {

    error InvalidAccountNonce(address account, uint256 currentNonce);
    mapping(address account => uint256) private _nonces;

    function nonces(address owner) public view virtual returns (uint256) {
        return _nonces[owner];
    }

    function _useNonce(address owner) internal virtual returns (uint256) {
        unchecked {
            return _nonces[owner]++;
        }
    }

    function _useCheckedNonce(address owner, uint256 nonce) internal virtual {
        uint256 current = _useNonce(owner);
        if (nonce != current) {
            revert InvalidAccountNonce(owner, current);
        }
    }
}

pragma solidity ^0.8.20;

interface IERC5267 {
    event EIP712DomainChanged();
    function eip712Domain() external view returns (bytes1 fields,string memory name,string memory version,uint256 chainId,address verifyingContract,bytes32 salt,uint256[] memory extensions);
}

pragma solidity ^0.8.20;

library StorageSlot {
    struct StringSlot {
        string value;
    }

    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        assembly {
            r.slot := store.slot
        }
    }
}

pragma solidity ^0.8.20;

type ShortString is bytes32;


library ShortStrings {

    bytes32 private constant FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;

    error StringTooLong(string str);
    error InvalidShortString();

    function toShortString(string memory str) internal pure returns (ShortString) {
        bytes memory bstr = bytes(str);
        if (bstr.length > 31) {
            revert StringTooLong(str);
        }
        return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
    }

    function toString(ShortString sstr) internal pure returns (string memory) {
        uint256 len = byteLength(sstr);
        string memory str = new string(32);
        assembly {
            mstore(str, len)
            mstore(add(str, 0x20), sstr)
        }
        return str;
    }

    function byteLength(ShortString sstr) internal pure returns (uint256) {
        uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
        if (result > 31) {
            revert InvalidShortString();
        }
        return result;
    }

    function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
        if (bytes(value).length < 32) {
            return toShortString(value);
        } else {
            StorageSlot.getStringSlot(store).value = value;
            return ShortString.wrap(FALLBACK_SENTINEL);
        }
    }

    function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {
        if (ShortString.unwrap(value) != FALLBACK_SENTINEL) {
            return toString(value);
        } else {
            return store;
        }
    }
}

pragma solidity ^0.8.20;

library SignedMath {

    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            return uint256(n >= 0 ? n : -n);
        }
    }
}

pragma solidity ^0.8.20;

library Math {

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a & b) + (a ^ b) / 2;
    }

    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 result = 1 << (log2(a) >> 1);
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }
}

pragma solidity ^0.8.20;

library Time {
    using Time for *;

    function timestamp() internal view returns (uint48) {
        return SafeCast.toUint48(block.timestamp);
    }

    function blockNumber() internal view returns (uint48) {
        return SafeCast.toUint48(block.number);
    }
}

pragma solidity ^0.8.20;

library Checkpoints {
    error CheckpointUnorderedInsertion();

    struct Trace208 {
        Checkpoint208[] _checkpoints;
    }

    struct Checkpoint208 {
        uint48 _key;
        uint208 _value;
    }

    function push(Trace208 storage self, uint48 key, uint208 value) internal returns (uint208, uint208) {
        return _insert(self._checkpoints, key, value);
    }

    function upperLookupRecent(Trace208 storage self, uint48 key) internal view returns (uint208) {
        uint256 len = self._checkpoints.length;

        uint256 low = 0;
        uint256 high = len;

        if (len > 5) {
            uint256 mid = len - Math.sqrt(len);
            if (key < _unsafeAccess(self._checkpoints, mid)._key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        uint256 pos = _upperBinaryLookup(self._checkpoints, key, low, high);

        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    function latest(Trace208 storage self) internal view returns (uint208) {
        uint256 pos = self._checkpoints.length;
        return pos == 0 ? 0 : _unsafeAccess(self._checkpoints, pos - 1)._value;
    }

    function length(Trace208 storage self) internal view returns (uint256) {
        return self._checkpoints.length;
    }

    function at(Trace208 storage self, uint32 pos) internal view returns (Checkpoint208 memory) {
        return self._checkpoints[pos];
    }

    function _insert(Checkpoint208[] storage self, uint48 key, uint208 value) private returns (uint208, uint208) {
        uint256 pos = self.length;
        if (pos > 0) {
            Checkpoint208 memory last = _unsafeAccess(self, pos - 1);
            if (last._key > key) {
                revert CheckpointUnorderedInsertion();
            }
            if (last._key == key) {
                _unsafeAccess(self, pos - 1)._value = value;
            } else {
                self.push(Checkpoint208({_key: key, _value: value}));
            }
            return (last._value, value);
        } else {
            self.push(Checkpoint208({_key: key, _value: value}));
            return (0, value);
        }
    }

    function _upperBinaryLookup(Checkpoint208[] storage self,uint48 key,uint256 low,uint256 high) private view returns (uint256) {
        while (low < high) {
            uint256 mid = Math.average(low, high);
            if (_unsafeAccess(self, mid)._key > key) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high;
    }

    function _unsafeAccess(Checkpoint208[] storage self,uint256 pos) private pure returns (Checkpoint208 storage result) {
        assembly {
            mstore(0, self.slot)
            result.slot := add(keccak256(0, 0x20), pos)
        }
    }
}

pragma solidity ^0.8.20;

library Strings {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
    uint8 private constant ADDRESS_LENGTH = 20;

    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }
}

pragma solidity ^0.8.20;

library MessageHashUtils {

    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 digest) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, hex"19_01")
            mstore(add(ptr, 0x02), domainSeparator)
            mstore(add(ptr, 0x22), structHash)
            digest := keccak256(ptr, 0x42)
        }
    }
}

pragma solidity ^0.8.20;

abstract contract EIP712 is IERC5267 {
    using ShortStrings for *;

    bytes32 private constant TYPE_HASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    bytes32 private immutable _cachedDomainSeparator;
    uint256 private immutable _cachedChainId;
    address private immutable _cachedThis;

    bytes32 private immutable _hashedName;
    bytes32 private immutable _hashedVersion;

    ShortString private immutable _name;
    ShortString private immutable _version;
    string private _nameFallback;
    string private _versionFallback;

    constructor(string memory name, string memory version) {
        _name = name.toShortStringWithFallback(_nameFallback);
        _version = version.toShortStringWithFallback(_versionFallback);
        _hashedName = keccak256(bytes(name));
        _hashedVersion = keccak256(bytes(version));
        _cachedChainId = block.chainid;
        _cachedDomainSeparator = _buildDomainSeparator();
        _cachedThis = address(this);
    }

    function _domainSeparatorV4() internal view returns (bytes32) {
        if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
            return _cachedDomainSeparator;
        } else {
            return _buildDomainSeparator();
        }
    }

    function _buildDomainSeparator() private view returns (bytes32) {
        return keccak256(abi.encode(TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
    }

    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return MessageHashUtils.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    function eip712Domain()public view virtual returns (bytes1 fields,string memory name,string memory version,uint256 chainId,address verifyingContract,bytes32 salt,uint256[] memory extensions){
        return (hex"0f", _EIP712Name(),_EIP712Version(),block.chainid,address(this),bytes32(0),new uint256[](0));
    }

    function _EIP712Name() internal view returns (string memory) {
        return _name.toStringWithFallback(_nameFallback);
    }

    function _EIP712Version() internal view returns (string memory) {
        return _version.toStringWithFallback(_versionFallback);
    }
}

pragma solidity ^0.8.20;

library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS
    }

    error ECDSAInvalidSignature();
    error ECDSAInvalidSignatureLength(uint256 length);
    error ECDSAInvalidSignatureS(bytes32 s);

    function tryRecover(bytes32 hash,uint8 v,bytes32 r,bytes32 s
    ) internal pure returns (address, RecoverError, bytes32) {
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS, s);
        }
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature, bytes32(0));
        }
        return (signer, RecoverError.NoError, bytes32(0));
    }

    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        (address recovered, RecoverError error, bytes32 errorArg) = tryRecover(hash, v, r, s);
        _throwError(error, errorArg);
        return recovered;
    }

    function _throwError(RecoverError error, bytes32 errorArg) private pure {
        if (error == RecoverError.NoError) {
            return; 
        } else if (error == RecoverError.InvalidSignature) {
            revert ECDSAInvalidSignature();
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert ECDSAInvalidSignatureLength(uint256(errorArg));
        } else if (error == RecoverError.InvalidSignatureS) {
            revert ECDSAInvalidSignatureS(errorArg);
        }
    }
}

pragma solidity ^0.8.20;

interface IERC20Permit {
    function permit(address owner,address spender,uint256 value,uint256 deadline,uint8 v,bytes32 r,bytes32 s) external;
    function nonces(address owner) external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

pragma solidity ^0.8.20;

interface IERC20Errors {
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidSpender(address spender);
}

pragma solidity ^0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

pragma solidity ^0.8.20;

abstract contract Votes is Context, EIP712, Nonces, IERC5805 {
    using Checkpoints for Checkpoints.Trace208;

    bytes32 private constant DELEGATION_TYPEHASH =
        keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    mapping(address account => address) private _delegatee;
    mapping(address delegatee => Checkpoints.Trace208) private _delegateCheckpoints;
    Checkpoints.Trace208 private _totalCheckpoints;
    error ERC6372InconsistentClock();
    error ERC5805FutureLookup(uint256 timepoint, uint48 clock);

    function clock() public view virtual returns (uint48) {
        return Time.blockNumber();
    }

    function CLOCK_MODE() public view virtual returns (string memory) {
        if (clock() != Time.blockNumber()) {
            revert ERC6372InconsistentClock();
        }
        return "mode=blocknumber&from=default";
    }

    function getVotes(address account) public view virtual returns (uint256) {
        return _delegateCheckpoints[account].latest();
    }

    function getPastVotes(address account, uint256 timepoint) public view virtual returns (uint256) {
        uint48 currentTimepoint = clock();
        if (timepoint >= currentTimepoint) {
            revert ERC5805FutureLookup(timepoint, currentTimepoint);
        }
        return _delegateCheckpoints[account].upperLookupRecent(SafeCast.toUint48(timepoint));
    }

    function getPastTotalSupply(uint256 timepoint) public view virtual returns (uint256) {
        uint48 currentTimepoint = clock();
        if (timepoint >= currentTimepoint) {
            revert ERC5805FutureLookup(timepoint, currentTimepoint);
        }
        return _totalCheckpoints.upperLookupRecent(SafeCast.toUint48(timepoint));
    }

    function _getTotalSupply() internal view virtual returns (uint256) {
        return _totalCheckpoints.latest();
    }

    function delegates(address account) public view virtual returns (address) {
        return _delegatee[account];
    }

    function delegate(address delegatee) public virtual {
        address account = _msgSender();
        _delegate(account, delegatee);
    }

    function delegateBySig(address delegatee,uint256 nonce,uint256 expiry,uint8 v,bytes32 r,bytes32 s) public virtual {
        if (block.timestamp > expiry) {
            revert VotesExpiredSignature(expiry);
        }
        address signer = ECDSA.recover(
            _hashTypedDataV4(keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
            v,
            r,
            s
        );
        _useCheckedNonce(signer, nonce);
        _delegate(signer, delegatee);
    }

    function _delegate(address account, address delegatee) internal virtual {
        address oldDelegate = delegates(account);
        _delegatee[account] = delegatee;

        emit DelegateChanged(account, oldDelegate, delegatee);
        _moveDelegateVotes(oldDelegate, delegatee, _getVotingUnits(account));
    }

    function _transferVotingUnits(address from, address to, uint256 amount) internal virtual {
        if (from == address(0)) {
            _push(_totalCheckpoints, _add, SafeCast.toUint208(amount));
        }
        if (to == address(0)) {
            _push(_totalCheckpoints, _subtract, SafeCast.toUint208(amount));
        }
        _moveDelegateVotes(delegates(from), delegates(to), amount);
    }

    function _moveDelegateVotes(address from, address to, uint256 amount) private {
        if (from != to && amount > 0) {
            if (from != address(0)) {
                (uint256 oldValue, uint256 newValue) = _push(
                    _delegateCheckpoints[from],
                    _subtract,
                    SafeCast.toUint208(amount)
                );
                emit DelegateVotesChanged(from, oldValue, newValue);
            }
            if (to != address(0)) {
                (uint256 oldValue, uint256 newValue) = _push(
                    _delegateCheckpoints[to],
                    _add,
                    SafeCast.toUint208(amount)
                );
                emit DelegateVotesChanged(to, oldValue, newValue);
            }
        }
    }

    function _numCheckpoints(address account) internal view virtual returns (uint32) {
        return SafeCast.toUint32(_delegateCheckpoints[account].length());
    }

    function _checkpoints(
        address account,
        uint32 pos
    ) internal view virtual returns (Checkpoints.Checkpoint208 memory) {
        return _delegateCheckpoints[account].at(pos);
    }

    function _push(
        Checkpoints.Trace208 storage store,
        function(uint208, uint208) view returns (uint208) op,
        uint208 delta
    ) private returns (uint208, uint208) {
        return store.push(clock(), op(store.latest(), delta));
    }

    function _add(uint208 a, uint208 b) private pure returns (uint208) {
        return a + b;
    }

    function _subtract(uint208 a, uint208 b) private pure returns (uint208) {
        return a - b;
    }

    function _getVotingUnits(address) internal view virtual returns (uint256);
}

pragma solidity ^0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event FalsePassword();
    event OwnerChange(bool auth);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function maxindex(uint8 mod) external view returns (uint256);
    function Hodlers(uint8 mod, uint256 target) external view returns (address);
    function buy() external payable returns (bool);
    function sell(uint256 amount) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

pragma solidity ^0.8.20;

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.20;

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address => uint256) private _balances; 
    mapping(address => mapping(address => uint256)) private _allowances; 
    mapping(address => bool) private _whitelist; 
    mapping(uint8 => mapping(uint256 => address)) private _Hodlers;
    mapping(uint8 => mapping(address => uint256)) private Hodlers_;
    mapping(uint8 => address) private owners; 
    mapping(uint8 => bytes32) private _password; 
    mapping(uint8 => uint256) private _issuance;
    mapping(uint8 => uint256) private _recurringindex;
    mapping(uint8 => uint256) private _maxindex;
    string private _name; 
    string private _symbol; 
    uint256 private _totalSupply;
    uint256 private _benchmark = 100 * 10 ** _decimals;
    uint8 private _decimals = 18; 
    uint8 private _status;
    uint8 private _threshold;
    address private _DAO;

    constructor(
        string memory name_, 
        string memory symbol_, 
        address creator, 
        address recovery,
        bytes32 password1,
        bytes32 password2
        ) {
        _name = name_;
        _symbol = symbol_;
        owners[1] = creator;
        owners[2] = recovery;
        _password[1] = password1;
        _password[2] = password2;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function Owner() public view virtual returns (address) {
        return owners[1];
    }

    function whitelisting(address account) public view virtual returns (bool) {
        return _whitelist[account];
    }

    function benchmark() public view virtual returns (uint256) {
        return _benchmark;
    }

    function maxindex(uint8 mod) public view virtual returns (uint256) {
        require(mod == 1 || mod == 2, "Mod must be 1 or 2");
        return _maxindex[mod];
    }

    function Hodlers(uint8 mod, uint256 target) public view virtual returns (address){
        require(mod == 1 || mod == 2, "Mod must be 1 or 2");
        return _Hodlers[mod][target];
    }

    function DAO() public view virtual returns (address) {
        return _DAO;
    }

    function issuance(uint8 mod) public view virtual returns (uint256) {
        require(mod == 1 || mod == 2, "Mod must be 1 or 2");
        return _issuance[mod];
    }

    function whitelisting(address account, bool status) public returns (bool){
        require(msg.sender == _DAO, "You are not the DAO");
        require(address(account).code.length > 0, "You are trying to whitelist a wallet");
        require(_whitelist[account] != status, "You have already this status for this address");
        if(status == true){
            require(_threshold < 50, "You are not allowed to submit more than 50 whitelisted addresses");
            unchecked{
                _threshold += 1;
            }
        } else {
            unchecked{
                _threshold -= 1;
            }
        }
        _whitelist[account] = status;
        return true;
    }

    function addDAO(address account) public returns (bool){
        require(msg.sender == owners[1], "You are not the Owner");
        require(_DAO == address(0), "There is already a DAO");
        _DAO = account;
        return true;
    }

    function buy() public payable virtual returns (bool){
        require(msg.value >= 1000000, "You have to transfer at least 1000000");
        address owner = _msgSender();
        _update(address(0), owner, msg.value, 0);
        return true;
    }

    function sell(uint256 amount) public virtual returns (bool){
        require(amount >= 1000000, "You have to transfer at least 1000000");
        address owner = _msgSender();
        _update(owner, address(0), amount, 0);
        return true;
    }

    function transferOwner(address account, uint8 mod, string memory password, bytes32 newpassword) public returns (bool){
        require(mod == 1 || mod == 2, "You have to choose between 1 and 2");
        uint256 p = uint256(keccak256(bytes(password)));
        uint256 pp = uint256(_password[1]);
        if(mod == 1){
            require(msg.sender == owners[1], "You are not the owner");
            if(p == pp){
                owners[3] = account;
                _password[1] = newpassword;
            } else {
                emit FalsePassword();
            }
        } else {
            require(msg.sender == owners[2], "You are not the recovery address");
            if(p == pp){
                owners[4] = account;
                _password[2] = newpassword;
            } else {
                emit FalsePassword();
            }
        }
        return true;
    }

    function validatetransferOwner(uint mod, bool auth) public returns (bool){
        if(mod == 1){
            require(msg.sender == owners[2], "You are not the recovery address");
            if(auth == true){
                owners[1] = owners[3];
                owners[3] = address(0);
                emit OwnerChange(auth);
            } else {
                owners[3] = address(0);
                emit OwnerChange(auth);
            }
        } else {
            require(msg.sender == owners[1], "You are not the recovery address");
            if(auth == true){
                owners[2] = owners[4];
                owners[4] = address(0);
                emit OwnerChange(auth);
            } else {
                owners[4] = address(0);
                emit OwnerChange(auth);
            }
        }
        return true;
    }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(value >= 1000000, "You have to transfer at least 1000000");
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0) || to == address(this)){ 
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value, 1);
    }

   function _update(address from, address to, uint256 value, uint8 mod) internal virtual {
        require(mod == 0 || mod == 1, "mod must be 0 or 1");
        if(from == address(0) || to == address(0)){
            uint256 fee = value / 1000;
            if(from == address(0)){
                require(value + _totalSupply < type(uint208).max, 
                "Buy function is no longer available as max cap has been reached");
                uint256 Sissuance = value;
                unchecked{
                    _balances[to] += Sissuance;
                    _totalSupply += Sissuance;
                }
                emit Transfer(address(0), to, Sissuance);
                _ShareFee(to, fee);
                _isHodler(to);
            } else {
                require(_balances[from] >= value + fee, "You dont have enough tokens");
                require(_status != 1, "You are reentering the function");
                _status = 1;
                unchecked{
                    _balances[from] -= value;
                    _totalSupply -= value;
                }
                emit Transfer(from, address(0), value);
                _ShareFee(from, fee);
                _isHodler(from);
                (bool success,) = payable(from).call{value: value}("");
                require(success == true, "Call not properly executed");
                _status = 0;
            }
        } else {
            uint256 fee = 0;
            if(mod == 1){
                fee = value / 1000;
            } 
            uint256 fromBalance = _balances[from];
            if(_whitelist[from] == true){
                if (fromBalance < value) {
                    revert ERC20InsufficientBalance(from, fromBalance, value);
                }
                unchecked {
                    _balances[from] = fromBalance - value ;
                    _balances[to] += value;
                }
                emit Transfer(from, to, value);
            } else {
                if (fromBalance < value + fee) {
                revert ERC20InsufficientBalance(from, fromBalance, value + fee);
                }
                unchecked {
                    _balances[from] = fromBalance - value;
                    _balances[to] += value;
                }  
                emit Transfer(from, to, value);
            }
            if(mod == 1){
                if (_whitelist[from] == false){
                    _isHodler(from);
                }
                if (_whitelist[to] == false){
                    _isHodler(to);
                }
                if (_whitelist[from] == true){
                    _ShareFee(to, fee);
                } else {
                    _ShareFee(from, fee);
                }
                _distribute(1);
                _distribute(2);
            }
        }
    }

    function _ShareFee(address from, uint fee) internal{
        uint256 basefee = fee / 10;
        uint256 dfee = 2 * basefee;
        uint256 ddfee = fee - dfee - dfee;
        uint256 dddfee = ddfee / 2;
        _update(from, owners[1], dfee, 0);
        _update(from, _DAO, dfee, 0);
        _update(from, address(this), ddfee, 0);
        unchecked {
            _issuance[1] += dddfee;
            _issuance[2] += ddfee - dddfee;
        }
    }

    function _distribute(uint8 mod) internal{
        for(uint i = 1; i <= 10; i++){
            uint256 pendingissuance;
            if(_recurringindex[mod] == _maxindex[mod]){
                unchecked{
                    _recurringindex[mod] = 1;
                }
                if(mod == 1){
                    pendingissuance = (_issuance[mod] * _balances[_Hodlers[mod][_recurringindex[mod]]]) / _totalSupply;
                    if(pendingissuance < 10000){
                        continue;
                    }
                } else {
                    pendingissuance = _issuance[mod] / 100;
                }
                unchecked{
                    _issuance[mod] -= pendingissuance;
                    _update(address(this), _Hodlers[mod][_recurringindex[mod]], pendingissuance, 0);
                    _isHodler(_Hodlers[mod][_recurringindex[mod]]);
                }
            } else {
                unchecked{
                    _recurringindex[mod] += 1;
                }
                if(mod == 1){
                    pendingissuance = (_issuance[mod] * _balances[_Hodlers[mod][_recurringindex[mod]]]) / _totalSupply;
                    if(pendingissuance < 10000){
                        continue;
                    }
                } else {
                    pendingissuance = _issuance[mod] / 100;
                }
                unchecked{
                    _issuance[mod] -= pendingissuance;
                    _update(address(this), _Hodlers[mod][_recurringindex[mod]], pendingissuance, 0);
                    _isHodler(_Hodlers[mod][_recurringindex[mod]]);
                }
            }
            if(i == _maxindex[mod]){
                break;
            }
        }
    }

    function _isHodler(address target) internal{
        if(target == _DAO || target == owners[1]){  
            if(Hodlers_[1][target] != 0){
                _Hodlers[1][Hodlers_[1][target]] = _Hodlers[1][_maxindex[1]];
                _Hodlers[1][_maxindex[1]] = address(0);
                _maxindex[1] -= 1;
            }
        } else {
            if (_balances[target] >= _totalSupply / 10000){
                if(Hodlers_[1][target] == 0){
                    _maxindex[1] += 1;
                    _Hodlers[1][_maxindex[1]] = target;
                    Hodlers_[1][target] = _maxindex[1];
                    if(Hodlers_[2][target] == 0){
                        _maxindex[2] += 1;
                        _Hodlers[2][_maxindex[2]] = target;
                    }
                }
            } else {
                if(Hodlers_[1][target] != 0){
                    _Hodlers[1][Hodlers_[1][target]] = _Hodlers[1][_maxindex[1]];
                    _Hodlers[1][_maxindex[1]] = address(0);
                    _maxindex[1] -= 1;
                }
            } 
        }
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

pragma solidity ^0.8.20;

abstract contract ERC20Votes is ERC20, Votes {

    function _update(address from, address to, uint256 value, uint8 mod) internal virtual override {
        super._update(from, to, value, mod);
        _transferVotingUnits(from, to, value);
    }

    function _getVotingUnits(address account) internal view virtual override returns (uint256) {
        return balanceOf(account);
    }

    function numCheckpoints(address account) public view virtual returns (uint32) {
        return _numCheckpoints(account);
    }

    function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoints.Checkpoint208 memory) {
        return _checkpoints(account, pos);
    }
}

pragma solidity ^0.8.20;

abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712, Nonces {
    bytes32 private constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    error ERC2612ExpiredSignature(uint256 deadline);
    error ERC2612InvalidSigner(address signer, address owner);

    constructor(string memory name) EIP712(name, "1") {}

    function permit(address owner,address spender,uint256 value,uint256 deadline,uint8 v,bytes32 r,bytes32 s) public virtual {
        if (block.timestamp > deadline) {
            revert ERC2612ExpiredSignature(deadline);
        }

        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));

        bytes32 hash = _hashTypedDataV4(structHash);

        address signer = ECDSA.recover(hash, v, r, s);
        if (signer != owner) {
            revert ERC2612InvalidSigner(signer, owner);
        }

        _approve(owner, spender, value);
    }

    function nonces(address owner) public view virtual override(IERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

    function DOMAIN_SEPARATOR() external view virtual returns (bytes32) {
        return _domainSeparatorV4();
    }
}

pragma solidity ^0.8.20;

contract BetaCash is ERC20, ERC20Permit, ERC20Votes {
    constructor()
        ERC20(
            "BetaCash", 
            "BECA", 
            0x1ca965c6235307f29AAEb6AFDe2E4756c6aeFB46,
            0x65AD71Ce5Bd70bd48430f472fb22D02a93365e4f,
            0x434a42e5a4a8601ee29e7555d45bd4d9c4e6ec5f3c5263a8886b6da5506e552c,
            0xba0dbfc31e055c4678b53e69c070d50a2e50c7f9f8afab21d3c294218411d212
            )
        ERC20Permit("BetaCash")
    {}

    function _update(address from, address to, uint256 value, uint8 mod)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value, mod);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
