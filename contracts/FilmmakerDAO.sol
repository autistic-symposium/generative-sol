// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/**
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
______________________________________________________________________________*/

import {Strings} from "../utils/Strings.sol";
import {Address} from "../utils/Address.sol";
import {Base64} from "../utils/Base64.sol";
import {ERC721} from "../utils/ERC721.sol";
import {IERC721} from "../utils/IERC721.sol";
import {IERC165} from "../utils/IERC165.sol";
import {ERC165} from "../utils/ERC165.sol";
import {Context} from "../utils/Context.sol";



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
        require(newOwner != address(0), "new owner is the zero address");
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
        require(_status != _ENTERED, "reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
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
        require(index < ERC721.balanceOf(owner), "owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "global index out of bounds");
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
        "black comedy ",
        "anime ",
        "mumblecore ",
        "musical ",
        "korean bew wave ",
        "japanese erotica ",
        "acid western ",
        "dogme 95 ",
        "french new wave   ",
        "italian neo realism ",
        "pulp ",
        "noir ",
        "screwball comedy ",
        "epic ",
        "psychological thriller ",
        "torture porn ",
        "snuff film ",
        "samurai film ",
        "wuXia film ",
        "bollywood ",
        "gangster film ",
        "courtroom ",
        "mockumentary ",
        "monster movie ",
        "oscar bait "
    ];

    string[] private medium = [
        "short film,",
        "feature film,",
        "episodic,",
        "limited series,",
        "podcast,",
        "VR film,",
        "narrative audio,",
        "IMAX film,",
        "Tik Tok video,",
        "NFT collection,",
        "teleplay,",
        "Youtube series",
        "theatre production,"
    ];

    string[] private cities = [
        "London,",
        "New York,",
        "Los Angeles,",
        "Atlanta,",
        "Miami,",
        "Buenos Aires,",
        "Curitiba,",
        "Lisbon,",
        "Berlin,",
        "New Orleans,",
        "Detroit,",
        "New Zealand,",
        "Australia,",
        "Marfa,",
        "Bucharest,",
        "Hong Kong,",
        "Jackson,",
        "Budapest,",
        "Sao Paulo,",
        "Lagos,",
        "Gold Coast,",
        "Paris,",
        "Tokyo,",
        "Barcelona,",
        "Goa,",
        "Rio de Janeiro,",
        "Atlantis,",
        "New Orleans,",
        "Middle Earth,",
        "Shaghai,",
        "Kyoto,",
        "Mars,",
        "Outer Space,",
        "Alien Planet,"
    ];

    string[] private archetypes = [
        " lover ",
        " witch ",
        " hero ",
        " magician ",
        " outlaw ",
        " shaman ",
        " teenager ",
        " writer ",
        " monarch ",
        " guy next door ",
        " supervillain ",
        " anarchist ",
        " nihilist ",
        " poet ",
        " dude ",
        " nomad ",
        " anti-hero ",
        " Dark Lord ",
        " Wojak ",
        " Ohmie ",
        " Chad ",
        " Soyjak ",
        " Pepe ",
        " Tetranode ",
        " Sisyphus ",
        " God ",
        " pixie girl ",
        " Timothee type ",
        " Pikachu ",
        " clown ",
        " superhero "
    ];

    string[] private verbs = [
        " breaks into pieces ",
        " steals  ",
        " kisses ",
        " run away from ",
        " fights against ",
        " escapes from ",
        " falls on ",
        " thinks about ",
        " drives away from ",
        " tries to kidnap  ",
        " makes love with ",
        " walks away from ",
        " writes about ",
        " yells at ",
        " eats a piece of ",
        " plays with ",
        " jumps into ",
        " sings with ",
        " dances with ",
        " sleeps with ",
        " flirts with ",
        " marries ",
        " mess around with ",
        " dreams about "
    ];

    string[] private objects = [
        "a ugly painting",
        "a shinning diamond",
        "a bag full of money",
        "a tiny skateboard",
        "a dead phone",
        "an empty coffee cup",
        "a can of diet coke",
        "a large red axe",
        "a M1911 pistol",
        "a small plastic bird",
        "a giant bowtie",
        "a purple toy hat",
        "a half doobie",
        "a giant ugly sweater",
        "a jug full of drugs"
    ];

    string[] private titles = [
        "acclaimed",
        "recognized",
        "exalted",
        "renowned",
        "celebrated",
        "distinguished",
        "impressive",
        "eminent",
        "popular",
        "respected",
        "an oscar-winner",
        "famed",
        "a rockstar"
    ];

    string[] private adjetives = [
        "adorable ",
        "vivid ",
        "aggressive ",
        "annoying ",
        "awful ",
        "intense ",
        "clever ",
        "cheerful ",
        "charming ",
        "courageous ",
        "cruel ",
        "defiant ",
        "disturbed ",
        "brilliant ",
        "delightful ",
        "dark ",
        "cute ",
        "terrible ",
        "silly ",
        "grotesque ",
        "grumpy ",
        "hilarious ",
        "horrible ",
        "glorious ",
        "magnificent ",
        "naughty ",
        "repulsive ",
        "wicked ",
        "sexy ",
        "ingenious ",
        "genius ",
        "dark ",
        "heroic ",
        "intrepid ",
        "romantic ",
        "mad ",
        "stoned ",
        "irate ",
        "funny ",
        "spooky ",
        "sad ",
        "powerful ",
        "raging ",
        "creepy "
    ];

    string[] private locations = [
        "in the hallway.",
        "in the bedroom.",
        "at the park.",
        "in the office.",
        "in the kitchen.",
        "in the street.",
        "at the airport.",
        "in the car.",
        "at church.",
        "at school.",
        "at the supermarket.",
        "in Outer Space.",
        "in the Metaverse.",
        "in the desert.",
        "in the rain forest.",
        "in the bathroom.",
        "in the shower.",
        "in the jungle.",
        "at the therapist's office.",
        "at the mother in law's bedroom.",
        "at the golf course.",
        "at the bowling alley.",
        "at the DMV."
    ];

    string[] private colors = [
        "#33E0FF",
        "#FFF033",
        "#33FF8D",
        "#FF33D4",
        "#FF8D33",
        "#EE5967",
        "#726EB2"
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

    function getColor(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "COLORS", colors);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[27] memory parts;
        string memory idstr = toString(tokenId);

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.cool {fill: ';
        parts[1] = getColor(tokenId);
        parts[2] = '; } .base { fill: white; font-family: arial; font-size: 12px; </style><rect width="100%" height="100%" fill="black" /><text x="40" y="100" class="cool">';
        parts[3] = 'You are filmmaker #';
        parts[4] = idstr;
        parts[5] = '</text><text x="40" y="140" class="base">';
        parts[6] = 'You are ';
        parts[7] = getTitles(tokenId);
        parts[8] = ' for your ';
        parts[9] = '</text><text x="40" y="160" class="base">';
        parts[10] = getGenres(tokenId);
        parts[11] = getMediums(tokenId);
        parts[12] = '</text><text x="40" y="180" class="base">';
        parts[13] = 'particularly for that ';
        parts[14] = getAdjectives(tokenId+1);
        parts[15] = ' scene in ';
        parts[16] = getCities(tokenId);
        parts[17] = '</text><text x="40" y="200" class="base">';
        parts[18] = ' when the ';
        parts[19] = getAdjectives(tokenId);
        parts[20] = getArchetypes(tokenId);
        parts[21] = '</text><text x="40" y="220" class="base">';
        parts[22] = getVerbs(tokenId);
        parts[23] = getObjects(tokenId);
        parts[24] = '</text><text x="40" y="240" class="base">';
        parts[25] = getLocations(tokenId);
        parts[26] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8], parts[9]));
        output = string(abi.encodePacked(output, parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16], parts[17], parts[18]));
        output = string(abi.encodePacked(output, parts[19], parts[20], parts[21], parts[22], parts[23], parts[24], parts[25], parts[26]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Filmmaker #', toString(tokenId), '", "description": "The Storytelling card collection is the FilmmakerDAO generative storytelling NFT series for season 0. It is a randomized story generated and stored on-chain. We thought Loot was a great project to spur further creative thought, and we hope Filmmakers can carry on that idea. Feel free to use your Storyteller Card in any way you want!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function claim(uint256 tokenId) public nonReentrant {
        require(tokenId > 0 && tokenId < 1338, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }

    function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 1337 && tokenId < 1999, "Reserved Token ID");
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

