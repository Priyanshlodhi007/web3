State variables
    mapping(uint256 => Track) public tracks;
    mapping(address => Artist) public artists;
    mapping(address => mapping(uint256 => bool)) public userStreams;
    
    uint256 public trackCounter;
    uint256 public platformFeePercentage = 5; Events
    event ArtistRegistered(address indexed artist, string name);
    event TrackUploaded(uint256 indexed trackId, address indexed artist, string title);
    event TrackStreamed(uint256 indexed trackId, address indexed listener, uint256 royaltyPaid);
    event RoyaltyWithdrawn(address indexed artist, uint256 amount);
    
    Calculate platform fee and artist royalty
        uint256 platformFee = (msg.value * platformFeePercentage) / 100;
        uint256 artistRoyalty = msg.value - platformFee;
        
        Update stream count
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
// 
Updated on 2025-11-05
// 
