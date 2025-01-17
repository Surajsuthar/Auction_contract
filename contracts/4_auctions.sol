// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Auction {
    
    struct Item {
        string name;
        string description;
        address payable highestBidder;
        uint highestBid;
    }
    
    mapping(uint => Item) public items;
    uint public itemCount;
    
    function createItem(string memory _name, string memory _description) public {
        itemCount++;
        items[itemCount] = Item(_name, _description, payable(msg.sender), 0);
    }
    
    function placeBid(uint _itemId, uint _bidAmount) public payable {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        require(_bidAmount > items[_itemId].highestBid, "Bid amount must be higher than current highest bid");
        
        if (items[_itemId].highestBidder != address(0)) {
            // Refund the previous highest bidder if exists
            items[_itemId].highestBidder.transfer(items[_itemId].highestBid);
        }
        
        items[_itemId].highestBidder = payable(msg.sender);
        items[_itemId].highestBid = _bidAmount;
    }
    
    function getWinningBid(uint _itemId) public view returns (address, uint) {
        require(_itemId > 0 && _itemId <= itemCount, "Invalid item ID");
        
        return (items[_itemId].highestBidder, items[_itemId].highestBid);
    }

    function getAllInfo() public  view returns(Item[] memory){
        Item[] memory arr = new Item[](itemCount);
        for(uint i=0;i<itemCount;i++){
            Item memory _item = items[i];
            arr[i] = _item;
        }
        return arr;
    }
}
