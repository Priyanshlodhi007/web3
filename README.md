# BlockTrance

## Project Description

BlockTrance is a decentralized music streaming and royalty distribution platform built on blockchain technology. It revolutionizes the music industry by enabling artists to upload their tracks, receive instant royalties for each stream, and maintain complete control over their music rights. The platform eliminates intermediaries, ensures transparent payment distribution, and creates a direct connection between artists and listeners.

Using smart contracts on the Ethereum blockchain, BlockTrance automates royalty payments, tracks streaming metrics in real-time, and provides a trustless environment where artists can monetize their work fairly. Listeners pay a small fee per stream, which is automatically distributed to the artist after deducting a minimal platform fee.

## Project Vision

Our vision is to democratize the music industry by:

- **Empowering Artists**: Giving independent musicians direct access to their audience without relying on traditional music labels or streaming platforms that take significant cuts
- **Ensuring Fair Compensation**: Implementing transparent, automated royalty payments that guarantee artists receive their fair share immediately
- **Building Trust Through Transparency**: Using blockchain technology to create an immutable record of streams, earnings, and transactions
- **Fostering Creative Freedom**: Allowing artists to set their own pricing and maintain full ownership of their creative works
- **Creating a Global Platform**: Enabling artists and listeners from anywhere in the world to connect without geographical or financial barriers

## Key Features

### 1. **Artist Registration**
- Artists can register on the platform with their unique identity
- Each artist receives a dedicated profile tracking their uploads and earnings
- Simple one-time registration process

### 2. **Track Upload & Management**
- Artists can upload unlimited tracks to the platform
- Set custom royalty rates per stream for each track
- Full control over track availability and pricing
- Immutable ownership records on the blockchain

### 3. **Decentralized Streaming**
- Listeners can stream any active track by paying the set royalty fee
- Instant payment processing through smart contracts
- Transparent fee structure (5% platform fee, 95% to artist)
- Stream history tracked on-chain for complete transparency

### 4. **Automated Royalty Distribution**
- Real-time earnings calculation and tracking
- Instant royalty allocation after each stream
- Artists can withdraw earnings at any time
- No delays or payment disputes

### 5. **Platform Governance**
- Configurable platform fee structure
- Owner-controlled platform settings
- Fair and transparent fee collection

## Future Scope

### Short-term Enhancements (3-6 months)
- **NFT Integration**: Convert tracks into tradeable NFTs for collectors
- **Playlist Creation**: Allow users to create and share playlists
- **Social Features**: Add following, comments, and likes functionality
- **Mobile Application**: Develop iOS and Android apps for seamless streaming

### Mid-term Development (6-12 months)
- **DAO Governance**: Transition to community-governed platform decisions
- **Staking Mechanism**: Allow token holders to stake and earn rewards
- **Collaborative Tracks**: Enable multiple artists to co-own and split royalties
- **Advanced Analytics**: Provide artists with detailed streaming analytics and demographics
- **IPFS Integration**: Store audio files on decentralized storage (IPFS/Arweave)

### Long-term Goals (1-2 years)
- **Cross-chain Support**: Deploy on multiple blockchains (Polygon, BSC, Solana)
- **AI-powered Recommendations**: Implement personalized music discovery
- **Live Streaming Concerts**: Host virtual concerts with NFT ticketing
- **Merchandise Integration**: Allow artists to sell merchandise directly through the platform
- **Licensing Marketplace**: Create a marketplace for music licensing and sync rights
- **Subscription Models**: Offer unlimited streaming subscriptions with batch royalty distribution
- **Record Label DAOs**: Enable formation of decentralized record labels

### Technical Improvements
- Layer 2 scaling solutions to reduce gas fees
- Advanced security audits and formal verification
- Multi-signature wallet support for collaborative accounts
- Upgraded oracle integration for real-world data feeds
- Cross-platform SDK for third-party integrations

---

## Project Structure

```
BlockTrance/
├── contracts/
│   └── BlockTrance.sol
├── README.md
└── package.json
```

## Technology Stack

- **Smart Contract**: Solidity ^0.8.0
- **Blockchain**: Ethereum (EVM-compatible)
- **Development**: Hardhat/Truffle
- **Frontend**: React.js (recommended)
- **Web3 Integration**: ethers.js/web3.js

## Getting Started

### Prerequisites
- Node.js v16 or higher
- MetaMask or similar Web3 wallet
- Hardhat or Truffle for deployment

### Installation

```bash
npm install
```

### Compilation

```bash
npx hardhat compile
```

### Deployment

```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

### Testing

```bash
npx hardhat test
```

## Smart Contract Functions

### Public Functions
- `registerArtist(string _name)` - Register as an artist
- `uploadTrack(string _title, uint256 _royaltyPerStream)` - Upload a new track
- `streamTrack(uint256 _trackId)` - Stream a track (payable)
- `withdrawEarnings()` - Withdraw artist earnings
- `getTrack(uint256 _trackId)` - View track details
- `getArtist(address _artist)` - View artist details

### Owner Functions
- `withdrawPlatformFees()` - Withdraw platform fees
- `updatePlatformFee(uint256 _newFee)` - Update platform fee percentage

## Contributing

We welcome contributions! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Contract Details: 
Transaction ID: 0xb8103EB18f34A4CBCA87f3c33Cc96EDAe900C61e
<img width="1366" height="522" alt="image" src="https://github.com/user-attachments/assets/6416b9ad-3591-41a1-9ca6-fdb73a2d1439" />


## License

MIT License - See LICENSE file for details

## Contact

For questions and support, please open an issue on GitHub or reach out to our community channels.

---

**BlockTrance** - Empowering artists through blockchain technology 🎵⛓️
