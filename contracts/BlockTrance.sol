// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BlockTrance
 * @dev A decentralized music streaming and royalty distribution platform
 * @notice This contract manages music NFTs, streaming records, and automated royalty payments
 */
contract BlockTrance {
    
    struct Track {
        uint256 id;
        string title;
        address artist;
        uint256 streamCount;
        uint256 royaltyPerStream;
        bool isActive;
        uint256 timestamp;
    }
    
    struct Artist {
        address wallet;
        string name;
        uint256 totalEarnings;
        uint256 trackCount;
        bool isRegistered;
    }
    
    // State variables
    mapping(uint256 => Track) public tracks;
    mapping(address => Artist) public artists;
    mapping(address => mapping(uint256 => bool)) public userStreams;
    
    uint256 public trackCounter;
    uint256 public platformFeePercentage = 5; // 5% platform fee
    address public platformOwner;
    uint256 public platformBalance;
    
    // Events
    event ArtistRegistered(address indexed artist, string name);
    event TrackUploaded(uint256 indexed trackId, address indexed artist, string title);
    event TrackStreamed(uint256 indexed trackId, address indexed listener, uint256 royaltyPaid);
    event RoyaltyWithdrawn(address indexed artist, uint256 amount);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == platformOwner, "Only platform owner can call this");
        _;
    }
    
    modifier onlyRegisteredArtist() {
        require(artists[msg.sender].isRegistered, "Artist not registered");
        _;
    }
    
    constructor() {
        platformOwner = msg.sender;
        trackCounter = 0;
    }
    
    /**
     * @dev Register as an artist on the platform
     * @param _name Artist name
     */
    function registerArtist(string memory _name) external {
        require(!artists[msg.sender].isRegistered, "Artist already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");
        
        artists[msg.sender] = Artist({
            wallet: msg.sender,
            name: _name,
            totalEarnings: 0,
            trackCount: 0,
            isRegistered: true
        });
        
        emit ArtistRegistered(msg.sender, _name);
    }
    
    /**
     * @dev Upload a new track to the platform
     * @param _title Track title
     * @param _royaltyPerStream Royalty amount in wei per stream
     */
    function uploadTrack(string memory _title, uint256 _royaltyPerStream) external onlyRegisteredArtist {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(_royaltyPerStream > 0, "Royalty must be greater than 0");
        
        trackCounter++;
        
        tracks[trackCounter] = Track({
            id: trackCounter,
            title: _title,
            artist: msg.sender,
            streamCount: 0,
            royaltyPerStream: _royaltyPerStream,
            isActive: true,
            timestamp: block.timestamp
        });
        
        artists[msg.sender].trackCount++;
        
        emit TrackUploaded(trackCounter, msg.sender, _title);
    }
    
    /**
     * @dev Stream a track and pay royalties
     * @param _trackId ID of the track to stream
     */
    function streamTrack(uint256 _trackId) external payable {
        Track storage track = tracks[_trackId];
        
        require(track.isActive, "Track is not active");
        require(_trackId > 0 && _trackId <= trackCounter, "Invalid track ID");
        require(msg.value >= track.royaltyPerStream, "Insufficient payment");
        
        // Calculate platform fee and artist royalty
        uint256 platformFee = (msg.value * platformFeePercentage) / 100;
        uint256 artistRoyalty = msg.value - platformFee;
        
        // Update balances
        platformBalance += platformFee;
        artists[track.artist].totalEarnings += artistRoyalty;
        
        // Update stream count
        track.streamCount++;
        userStreams[msg.sender][_trackId] = true;
        
        emit TrackStreamed(_trackId, msg.sender, artistRoyalty);
    }
    
    /**
     * @dev Withdraw earnings for artists
     */
    function withdrawEarnings() external onlyRegisteredArtist {
        uint256 earnings = artists[msg.sender].totalEarnings;
        require(earnings > 0, "No earnings to withdraw");
        
        artists[msg.sender].totalEarnings = 0;
        
        (bool success, ) = payable(msg.sender).call{value: earnings}("");
        require(success, "Withdrawal failed");
        
        emit RoyaltyWithdrawn(msg.sender, earnings);
    }
    
    /**
     * @dev Get track details
     * @param _trackId ID of the track
     */
    function getTrack(uint256 _trackId) external view returns (Track memory) {
        require(_trackId > 0 && _trackId <= trackCounter, "Invalid track ID");
        return tracks[_trackId];
    }
    
    /**
     * @dev Get artist details
     * @param _artist Address of the artist
     */
    function getArtist(address _artist) external view returns (Artist memory) {
        require(artists[_artist].isRegistered, "Artist not registered");
        return artists[_artist];
    }
    
    /**
     * @dev Platform owner can withdraw platform fees
     */
    function withdrawPlatformFees() external onlyOwner {
        uint256 balance = platformBalance;
        require(balance > 0, "No platform fees to withdraw");
        
        platformBalance = 0;
        
        (bool success, ) = payable(platformOwner).call{value: balance}("");
        require(success, "Withdrawal failed");
    }
    
    /**
     * @dev Update platform fee percentage (only owner)
     * @param _newFee New fee percentage
     */
    function updatePlatformFee(uint256 _newFee) external onlyOwner {
        require(_newFee <= 20, "Fee cannot exceed 20%");
        platformFeePercentage = _newFee;
    }
}