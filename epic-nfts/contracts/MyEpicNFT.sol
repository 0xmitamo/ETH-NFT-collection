// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["coffee", "water", "soda", "tea", "juice", "beer", "tap water", "black tea", "assam tea", "roasted tea", "iced tea", "Chinese tea", "Puer tea", "brown rice tea", "Chai"];
    string[] secondWords = ["Acapulco", "Accra", "Astana", "Addis Ababa", "Istanbul", "Wonsan", "monitor", "program", "application", "keyboard", "javascript", "gaming", "network"];
    string[] thirdWords = ["Oakland", "Olympia", "Ottawa", "Jerusalem", "Woodstock", "Indianapolis", "1", "2", "3", "4", "5"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract.");
    }

      // シードを生成する関数を作成します。
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
      // pickRandomFirstWord 関数のシードとなる rand を作成します。
      uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
      // seed rand をターミナルに出力する。
      console.log("rand seed: ", rand);
      // firstWords配列の長さを基準に、rand 番目の単語を選びます。
      rand = rand % firstWords.length;
      // firstWords配列から何番目の単語が選ばれるかターミナルに出力する。
      console.log("rand first word: ", rand);
      return firstWords[rand];
    }

      // pickRandomSecondWord関数は、2番目に表示されるの単語を選びます。
      function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {

        // pickRandomSecondWord 関数のシードとなる rand を作成します。
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
      }

      // pickRandomThirdWord関数は、3番目に表示されるの単語を選びます。
      function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {

        // pickRandomThirdWord 関数のシードとなる rand を作成します。
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
      }


    function makeAnEpicNFT() public {

      uint256 newItemId = _tokenIds.current();
      // 3つの配列からそれぞれ1つの単語をランダムに取り出します。
      string memory first = pickRandomFirstWord(newItemId);
      string memory second = pickRandomSecondWord(newItemId);
      string memory third = pickRandomThirdWord(newItemId);

      	  // 3つの単語を連携して格納する変数 combinedWord を定義します。
      string memory combinedWord = string(abi.encodePacked(first, second, third));
      // 3つの単語を連結して、<text>タグと<svg>タグで閉じます。
      string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // NFTに出力されるテキストをターミナルに出力します。
      console.log("\n--------------------");
      console.log(finalSvg);
      console.log("--------------------\n");

         // JSONファイルを所定の位置に取得し、base64としてエンコードします。
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                      '{"name": "',
                      // NFTのタイトルを生成される言葉（例: GrandCuteBird）に設定します。
                      combinedWord,
                      '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                      //  data:image/svg+xml;base64 を追加し、SVG を base64 でエンコードした結果を追加します。
                      Base64.encode(bytes(finalSvg)),
                      '"}'
                  )
              )
          )
      );

          // データの先頭に data:application/json;base64 を追加します。
      string memory finalTokenUri = string(
          abi.encodePacked("data:application/json;base64,", json)
      );

      console.log("\n----- Token URI ----");
      console.log(finalTokenUri);
      console.log("--------------------\n");

      _safeMint(msg.sender, newItemId);
      _setTokenURI(newItemId, finalTokenUri);
      console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
      _tokenIds.increment();
      emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}