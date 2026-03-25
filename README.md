# Bonga App + GroPesa: Offline-First Mesh Messaging & Crypto Rewards

**Bonga App** is a **decentralized, offline-first messaging platform** built on a **hybrid mesh protocol** (Wi-Fi Direct, Multipeer Connectivity, Ad-Hoc Networks). Users earn **GroPesa (GRO)**, a utility token redeemable for airtime, data, or traded on DEXs.

## 🌍 Vision
- **No Internet Needed**: Peer-to-peer messaging using **Wi-Fi Direct (Android)** and **Multipeer Connectivity (iOS)**.
- **Earn GRO**: Rewards for chatting, inviting friends, and contributing to the mesh network.
- **Redeem GRO**: Convert to **KES (Kenyan Shillings)** via M-Pesa or airtime/data bundles.
- **Super-Nodes**: PCs/macOS devices act as **relayers** to extend mesh range.

---

## 🛠 Technical Stack

| **Component**          | **Technology**                                                                                     | **Purpose**                                                                                     |
|------------------------|-------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| **Frontend**           | Flutter (Mobile), React (Web)                                                                   | Cross-platform UI for chat + GRO wallet.                                                        |
| **Mesh Protocol**      | Wi-Fi Direct (Android), Multipeer Connectivity (iOS), Ad-Hoc (PC)                              | Offline P2P messaging.                                                                         |
| **Blockchain**         | Polygon (GRO Token), Chainlink Keepers                                                          | GRO rewards, redemptions, and automation.                                                      |
| **Backend**            | Netlify Functions, Firebase (Firestore/Storage)                                                | KYC, GRO minting, and redemption logic.                                                        |
| **KYC**                | FaceIO (Liveness), Manual Review (Firebase)                                                      | Compliance for GRO ↔ KES conversions.                                                          |
| **SMS**                | Resend.com                                                                                       | Notifications for redemptions/KYC approvals.                                                  |
| **Security**           | OpenZeppelin Defender (Multi-Sig), Slither/MythX (Audits)                                       | Protect admin functions and smart contracts.                                                  |

---

## 📱 Setup & Deployment

### **Prerequisites**
1. **GitHub Account**: Fork this repo.
2. **Netlify Account**: [Sign up](https://app.netlify.com/) for hosting.
3. **Firebase Project**: [Create one](https://console.firebase.google.com/) for KYC data.
4. **Polygon Wallet**: MetaMask with MATIC for gas.

### **Local Development**
1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/bonga-app.git
   cd bonga-app
