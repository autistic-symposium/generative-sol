// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/**
______________________________________________________,_________________________
_______________________________________________,╥▄▓█████________________________
________________________________________╓▄▄▄▒└    └╙▀▀██▌_______________________
_________________________________,-≤░░╙▀███████▓▄▄ ,»ⁿ"_└_______________________
__________________________,▄▓▓████▓▄░░░░░┐╙╙▀█▀▀╙└______________________________
_____________________ ▓▒░░░░│╙▀▀███████▀"_______________________________________
______________________║█╬╬Å▄▄░░╚²"└¬____________________________________________
_______________________▓▒░░░╚▓,_________________________________________________
_______________________█▒░▒▒▒░╠╦''╓▓████▀││││,▓████▀│░░░▄▓▌_____________________
_______________________█▓╬╩╩╩╩╬╬▓█████╙'░░│▄█████▀│░░│▄███▌_____________________
_______________________▀▀▄▄▄▄▄▓█████▄▄▄▄▄▓█████▄▄▄▄▄█████▀¬_____________________
_________________________███████████████████████████████▌_______________________
_________________________██▓▓███████ bt3gl █████████████▌_______________________
_________________________███████████████████████████████▌_______________________
_________________________██▓▓███ FilmmakerDAO ██████████▌_______________________
_________________________███████████████████████████████▌_______________________
_________________________▓██████████▓████████╫██████████`_______________________
__________________________└▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀_________________________
________________________________________________________________________________
______________________________________________________________________________*/

import {Strings} from "../utils/Strings.sol";
import {Address} from "../utils/Address.sol";
import {Base64} from "../utils/Base64.sol";


interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}


interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}


contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    string private _name;
    string private _symbol;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current story-owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve story-caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent story-card");

        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to story-caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of story-card that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non-ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}


interface IERC721Enumerable is IERC721 {
    function totalSupply() external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) external view returns (uint256);
}


abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    uint256[] private _allTokens;
    mapping(uint256 => uint256) private _allTokensIndex;

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;

        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}


contract FilmmakerDAO is ERC721Enumerable, ReentrancyGuard, Ownable {

    string[] private genres = [
        "chick flick ",
        "comedy ",
        "action ",
        "fantasy ",
        "horror ",
        "romance ",
        "western ",
        "thriller ",
        "rom-com ",
        "drama ",
        "romantic thriller ",
        "black Comedy ",
        "anime ",
        "mumblecore "
    ];

    string[] private medium = [
        "short film,",
        "feature film,",
        "episodic,",
        "limited series,",
        "documentary film,",
        "podcast,",
        "VR film,",
        "narrative audio,",
        "IMAX film,"
    ];

    string[] private cities = [
        "London",
        "New York",
        "Los Angeles",
        "Atlanta",
        "Miami",
        "Buenos Aires",
        "Curitiba",
        "Lisbon",
        "Hamburg",
        "Pyongyang",
        "Berlin",
        "New Orleans",
        "Detroit",
        "New Zealand",
        "Australia",
        "Marfa",
        "Bucharest",
        "Hong Kong",
        "Jackson",
        "Budapest",
        "Sao Paulo",
        "Lagos",
        "Omaha",
        "Gold Coast",
        "Paris",
        "Tokyo",
        "Saint Petersburg",
        "San Francisco",
        "Barcelona",
        "Kisumu",
        "Ramallah",
        "Goa",
        "Rio de Janeiro"
    ];

    string[] private archetypes = [
        " lover ",
        " witch "
        " hero ",
        " magician ",
        " outlaw ",
        " explorer ",
        " sage ",
        " innocent child ",
        " creator ",
        " ruler ",
        " caregiver ",
        " guy next door ",
        " jester ",
        " villian ",
        " anarchist ",
        " nihilist ",
        " poet ",
        " funny dude ",
        " nomad "
    ];

    string[] private verbs = [
        " delivers ",
        " defeats ",
        " persuades ",
        " kisses ",
        " run from ",
        " fights against ",
        " escapes from ",
        " falls on ",
        " thinks about ",
        " buys ",
        " drives away from ",
        " texts ",
        " makes love with ",
        " walks away from ",
        " writes about ",
        " yells at ",
        " eats a piece of ",
        " plays with ",
        " jumps from ",
        " sings with ",
        " dances with ",
        " swims away ",
        " sleeps with ",
        " flirts with ",
        " marries ",
        " assaults "
    ];

    string[] private objects = [
        "a blue umbrella",
        "a shinning diamond",
        "a money truk",
        "a tiny skateboard",
        "a dead cell phone",
        "an empty coffee cup",
        "a cup of diet coke",
        "a sharp knife",
        "a fake gun",
        "a small dog"
    ];

    string[] private titles = [
        "acclaimed",
        "recognized",
        "exalted",
        "renowned",
        "celebrated",
        "distinguished",
        "unimportant",
        "unnotable",
        "infamous",
        "unremarkable",
        "obscure",
        "regular",
        "unimpressive",
        "eminent",
        "popular",
        "respected",
        "oscar-winner",
        "famed",
        "star"
    ];

    string[] private adjetives = [
        "adorable ",
        "adventurous ",
        "aggressive ",
        "annoying ",
        "awful ",
        "bright ",
        "brainy ",
        "cheerful ",
        "charming ",
        "courageous ",
        "cruel ",
        "defiant ",
        "disturbed ",
        "doubtful ",
        "delightful ",
        "dark ",
        "cute ",
        "terrible ",
        "foolish ",
        "funny ",
        "grotesque ",
        "grumpy ",
        "hilarious ",
        "horrible ",
        "glorious ",
        "magnificent ",
        "naughty ",
        "repulsive ",
        "wicked ",
        "sexy "
    ];

    string[] private locations = [
        "in the hallway",
        "in the bedroom",
        "at the park",
        "in the office",
        "in the kitchen",
        "on the street",
        "at the airport",
        "in the car",
        "at church",
        "at school",
        "at the supermarket",
        "in Outer Space",
        "in the Metavese",
        "in the desert",
        "in the rain forrest",
        "in the bathroom",
        "on thes hower",
        "in the jungle",
        "at the therapists office",
        "at the mother in law's bedroom",
        "at the golf course",
        "at the bowling alley",
        "at the DMV"
    ];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getGenres(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "GENRES", genres);
    }

    function getMediums(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "MEDIUMS", medium);
    }

    function getCities(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "CITIES", cities);
    }

    function getArchetypes(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ARCHETYPES", archetypes);
    }

    function getVerbs(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "VERBS", verbs);
    }

    function getObjects(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "OBJCTS", objects);
    }

    function getLocations(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "LOCATIONS", locations);
    }

    function getAdjectives(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ADJETIVES", adjetives);
    }

    function getTitles(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "TITLES", titles);
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[22] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: arial; font-size: 12px; </style><rect width="100%" height="100%" fill="black" /><text x="40" y="100" class="base">';
        parts[1] = 'Hello, storyteller! Welcome to FilmmakerDAO!';
        parts[2] = '</text><text x="40" y="140" class="base">';
        parts[3] = 'You have are kind of ';
        parts[4] = getTitles(tokenId);
        parts[5] = ' for your ';
        parts[6] = '</text><text x="40" y="160" class="base">';
        parts[7] = getGenres(tokenId);
        parts[8] = getMediums(tokenId);
        parts[9] = '</text><text x="40" y="180" class="base">';
        parts[10] = 'particularly for that ';
        parts[11] = getAdjectives(tokenId);
        parts[12] = ' scene on ';
        parts[13] = getCities(tokenId);
        parts[14] = '</text><text x="40" y="200" class="base">';
        parts[15] = ' when the ';
        parts[16] = getArchetypes(tokenId);
        parts[17] = getVerbs(tokenId);
        parts[18] = getObjects(tokenId);
        parts[19] = '</text><text x="40" y="220" class="base">';
        parts[20] = getLocations(tokenId);
        parts[21] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9], parts[10]));
        output = string(abi.encodePacked(output, parts[11], parts[12], parts[13], parts[14], parts[15], parts[16], parts[17], parts[18], parts[19], parts[20], parts[21]));
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Filmmaker #', toString(tokenId), '", "description": "FilmmakerDAO is the DAO for filmmakers and film enthusiasts. The storytelling industry is opaque, gatekept, and faces a cold start problem. Our mission is to empower every human on earth to tell stories. By redefining how storytelling is produced, we redefine how legacy and culture are created and our identity as a society.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function claim(uint256 tokenId) public nonReentrant {
        require(tokenId > 0 && tokenId < 1338, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }

    function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 1337 && tokenId < 1999, "Story card ID invalid");
        _safeMint(owner(), tokenId);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor() ERC721("FilmmakerDAO Season 0", "FILMMAKER") Ownable() {}
}

