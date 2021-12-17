// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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


import {ERC721} from "../utils/ERC721.sol";
import {Ownable} from "../utils/Ownable.sol";
import {SafeMath} from "../utils/SafeMath.sol";
import {Address} from "../utils/Address.sol";
import {Base64} from "../utils/Base64.sol";
import {ReentrancyGuard} from "../utils/ReentrancyGuard.sol";
import {ERC721Enumerable} from "../utils/ERC721Enumerable.sol";



contract FilmmakerDAO is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint256 public constant SALE_PRICE = 0.05 ether;

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
        "korean new wave ",
        "acid western ",
        "Dogme 95 ",
        "french new wave ",
        "italian neo realism ",
        "pulp ",
        "noir ",
        "screwball comedy ",
        "epic ",
        "psychological thriller ",
        "snuff ",
        "samurai ",
        "wuXia ",
        "bollywood ",
        "gangster ",
        "courtroom ",
        "mockumentary ",
        "monster "
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
        "NFT video collection,",
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
        "Mars,"
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
        " Pepe ",
        " Tetranode ",
        " God ",
        " pixie girl ",
        " Timothee type ",
        " clown ",
        " superhero "
    ];

    string[] private verbs = [
        " steals  ",
        " kisses ",
        " runs away from ",
        " fights against ",
        " escapes with ",
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
        " messes with ",
        " dreams about "
    ];

    string[] private objects = [
        "a stunning painting",
        "a shinning diamond",
        "a bag full of money",
        "a tiny skateboard",
        "a dead phone",
        "an empty coffee cup",
        "a can of diet coke",
        "a large red axe",
        "a toy gun",
        "a small plastic bird",
        "a broken lighter",
        "a giant bowtie",
        "a golf cart",
        "a bowl full of pasta",
        "an old laptop",
        "a map to a treasure",
        "a trash can",
        "an incriminating photo",
        "a shiny watch",
        "a purple doll",
        "a half doobie",
        "a giant ugly sweater",
        "a jug full of drugs",
        "a spell book",
        "a teddy bear",
        "a poisoned apple",
        "a red balloon"
    ];

    string[] private titles = [
        "acclaimed",
        "recognized",
        "Youtube famous",
        "renowned",
        "a BAFTA winner",
        "a Golden Globe winner",
        "a DGA Award winner",
        "distinguished",
        "Instagram famous",
        "Twitter popular",
        "an Independent Spirit winner",
        "a MTV Awards winner",
        "respected",
        "an Oscar winner",
        "Teen Choice Awards winner",
        "celebrated",
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
        "beautiful ",
        "terrible ",
        "silly ",
        "grotesque ",
        "grumpy ",
        "hilarious ",
        "horrible ",
        "glorious ",
        "magnificent ",
        "naughty ",
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
        "funny ",
        "spooky ",
        "sad ",
        "powerful ",
        "raging ",
        "creepy "
    ];

    string[] private locations = [
        "under a bridge.",
        "in some park.",
        "in the mall.",
        "in the kitchen.",
        "at Starbucks.",
        "in the airport.",
        "in the church.",
        "in the school.",
        "in the supermarket.",
        "in the Metaverse.",
        "in a desert.",
        "in a forest.",
        "in a bathroom.",
        "in a shower.",
        "in a jungle.",
        "in a deli.",
        "at the therapist's office.",
        "at the mother in law's bedroom.",
        "in a golf course.",
        "in a bowling alley.",
        "at the DMV.",
        "at McDonald's.",
        "at 7-Eleven."
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
        return pluck(tokenId, "A", genres);
    }

    function getMediums(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "AB", medium);
    }

    function getCities(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABC", cities);
    }

    function getArchetypes(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCD", archetypes);
    }

    function getVerbs(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCDE", verbs);
    }

    function getObjects(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCDEF", objects);
    }

    function getLocations(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCDEFG", locations);
    }

    function getAdjectives(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCDEFGI", adjetives);
    }

    function getTitles(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ABCDEFGIH", titles);
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
        parts[14] = getAdjectives(tokenId+137);
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

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Filmmaker #', toString(tokenId), '", "description": "The Storytelling card collection is the FilmmakerDAO generative storytelling NFT series. It is a randomized story generated and stored on-chain. Feel free to use your Storyteller Card in any way you want!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintCard(uint256 tokenId) public payable {
        require(msg.value >= SALE_PRICE, "Not enough ETH sent: check price.");
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

    constructor() ERC721("Storyteller Card", "FILMMAKER") Ownable() {}
}

