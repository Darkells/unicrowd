## UniCrowd
UniCrowd 是一个去中心化的 Web3 众筹平台，基于以太坊区块链，允许用户为创意项目、开源软件或社区提案捐款 ETH，并记录捐款信息。项目旨在通过智能合约实现透明、安全的资金管理，未来可扩展为 Launchpad，支持代币发行（IDO）。UniCrowd 使用 Foundry 开发智能合约，React 构建用户友好的前端界面，致力于赋能 Web3 社区。
### 功能

- 去中心化众筹：用户通过 MetaMask 捐款 ETH，智能合约自动记录金额和消息。
- 透明可审计：所有捐款记录存储在区块链上，可通过 Etherscan 验证。
- 事件记录：触发 Contribution 事件，实时更新捐款状态。
- 安全保障：使用 OpenZeppelin 的 ReentrancyGuard 防止重入攻击。
- 未来扩展：计划支持 ERC-20 代币分发、DAO 治理和 DEX 集成（如 Uniswap）。

### 技术栈

- 后端：Foundry（Forge、Cast、Anvil）用于智能合约开发、测试和部署。
- 前端：React（CDN）+ Ethers.js，连接 MetaMask，提供用户交互界面。
- 区块链：以太坊（Sepolia 测试网），未来支持 Layer-2（如 Arbitrum）。
- 依赖：OpenZeppelin Contracts（安全合约模板）。
- 工具：Git、GitHub Actions（CI）、IPFS（可选，存储项目元数据）。

### 安装
#### 前置条件

- Node.js：用于前端本地服务器（建议 v16+）。
- Foundry：安装 Forge、Cast 和 Anvil，参考 Foundry Book。
- MetaMask：浏览器插件，用于用户交互和交易签名。
- WSL2（可选）：推荐在 Linux 环境下开发（如 Ubuntu）。
Git：用于代码管理。

#### 项目结构

```
unicrowd
├── src
│   └── Crowdfunding.sol          # 核心众筹合约
├── test
│   └── Crowdfunding.t.sol        # Foundry 测试文件
├── script
│   └── DeployCrowdfunding.s.sol  # 部署脚本
├── lib
│   └── openzeppelin-contracts    # 依赖库
├── .gitignore                    # 忽略敏感文件
├── foundry.toml                  # Foundry 配置
└── README.md                     # 项目说明
```

#### 开发流程

##### 智能合约开发：

- 修改 src/Crowdfunding.sol，实现新功能（如退款、代币分发）。
- 使用 forge test 验证逻辑。
- 参考 OpenZeppelin 的 ERC20 或 Crowdsale 扩展 Launchpad 功能。


#### 测试与部署：

- 使用 Anvil 测试本地交互。
- 部署到 Sepolia 或 Arbitrum，验证合约（Etherscan）。
- 运行模糊测试：forge test --fuzz


#### 未来计划

多项目支持：允许创建多个众筹项目，存储在链上。
Launchpad 扩展：集成 ERC-20 代币分发，支持 IDO。
DAO 治理：引入社区投票（如 Aragon）决定资金分配。
IPFS 集成：存储项目描述和图片。
Layer-2 部署：降低 gas 费用，支持 Arbitrum 或 Optimism。

感谢支持 UniCrowd