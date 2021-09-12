const ethers = require("ethers");
const axios = require('axios')
const game_abi = require('./Game.json')
const fs = require('fs')
const cron = require('node-cron')
require('dotenv').config()
const {TOKEN_ADDR, GAME_ADDR, MNEMONIC, API} = process.env
async function main() {
    // get data from queue
    const text = fs.readFileSync('queue', 'utf-8')
    let response = await axios.get(`${API}/queue/${text}`)
    const messages = response.data
    const provider = new ethers.providers.JsonRpcProvider('https://kovan.optimism.io')
    const signer = ethers.Wallet.fromMnemonic(MNEMONIC);
    const game = new ethers.Contract(GAME_ADDR, game_abi.abi).connect(signer);
    let trans = []
    messages.forEach(msg => {
        if(msg.type == 'pawn')
            trans.push(game.interface.encodeFunctionData('pawn',[msg.killer, msg.victim, msg.room]))
        else if(msg.type == 'survive')
            trans.push(game.interface.encodeFunctionData('survive',[msg.survivor, msg.room]))
    });
    if(trans.length > 0) {
        let nonce = await provider.getTransactionCount(signer.address);
        let unsignedTx = await game.populateTransaction.multicall(trans)
        unsignedTx['nonce'] = nonce
        unsignedTx['gasPrice'] = 15000000
        unsignedTx['chainId'] = 69
        unsignedTx['gasLimit'] = 4000000
        const signed = await signer.signTransaction(unsignedTx)
        await provider.sendTransaction(signed)
        fs.writeFileSync('queue', trans.length.toString())
    } else 
        fs.writeFileSync('queue', '0')
}

cron.schedule('*/5 * * * * *', async() => {
    try {
        await main()
    } catch (err) {
        console.log(err)
    }
})
/*
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
*/