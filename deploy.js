const ethers = require('ethers');
const fs = require('fs-extra');
require('dotenv').config();

 async function main() {
    // connect to local blockchain and modify it with ether.js
    const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL); 
    const wallet = new ethers.Wallet(
        process.env.PRIVATE_KEY, 
        provider
    );
    const wallet_address = '0x2770337A85BE29e2Cc35fd612C75BF09638d114a';

    const abi = fs.readFileSync('./Fund_sol_Fund.abi', 'utf8');
    const binary = fs.readFileSync('./Fund_sol_Fund.bin', 'utf8');
    const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
    const contract = await contractFactory.deploy();

    const myFavoriteNumber = await contract.retrieve();
    console.log(myFavoriteNumber / 1e18);
 }

 main()
    .then( () => process.exit(0))
    .catch((error) => {
        console.error(error); 
        process.exit(1);
    })