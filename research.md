https://docs.openzeppelin.com/learn/deploying-and-interacting#deploying-a-smart-contract
- We interact with the deployed smart contracts through the Truffle contracts

https://blog.openzeppelin.com/the-hitchhikers-guide-to-smart-contracts-in-ethereum-848f08001f05
- Smart contracts run in Ethereum's Virtual Machine (EVM)
- constant functions: do not change state, so they cost no gas - they only read things and return values
  - contract idea: could have a contract that just reads account balances??
- transaction functions: do change state, so they require gas

https://ethereum.org/en/developers/docs/smart-contracts/deploying/#:~:text=You%20need%20to%20deploy%20your,contract%20without%20specifying%20any%20recipient.

https://ethereum.stackexchange.com/questions/42/how-can-a-contract-run-itself-at-a-later-time
- How to have smart contracts wait a certain amount of time/in the future to execute or change state

https://medium.com/wavesprotocol/blockchain-trigger-a-tool-for-automatic-smart-contract-invocation-1cb2748c53be
- Technology that deploys a smart contract based on a trigger

https://nextrope.com/how-to-create-a-simple-smart-contract-to-manage-auctions/
- Article that creates smart contracts for creating bid transactions

https://medium.com/coinmonks/build-a-smart-contract-to-sell-goods-6cf73609d25
- Article about selling something on network through smart contracts

https://ethereum.org/pt/developers/tutorials/transfers-and-approval-of-erc-20-tokens-from-a-solidity-smart-contract/
- Transfering ERC20 for ether!! this is important for the project!!
- https://github.com/fabiojose/ethereum-ex/blob/master/contracts/Deal.sol
