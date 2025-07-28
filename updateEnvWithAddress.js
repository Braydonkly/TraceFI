const fs = require('fs');
const path = require('path');

const artifactPath = path.join(__dirname, 'build', 'contracts', 'TraceFI.json');
const envPath = path.join(__dirname, '.env');

const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
const networks = artifact.networks;
const lastNetworkId = Object.keys(networks).pop();
const address = networks[lastNetworkId].address;

let env = fs.readFileSync(envPath, 'utf8');
if (env.match(/CONTRACT_ADDRESS=.*/)) {
  env = env.replace(/CONTRACT_ADDRESS=.*/g, `CONTRACT_ADDRESS=${address}`);
} else {
  env += `\nCONTRACT_ADDRESS=${address}\n`;
}
fs.writeFileSync(envPath, env);
console.log('Updated .env with contract address:', address);
