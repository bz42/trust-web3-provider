import { registerWallet } from './register.js';
import { AwsomeWalletWallet } from './wallet.js';
import type { AwsomeWallet } from './window.js';

export function initialize(awsWallet: AwsomeWallet): void {
    registerWallet(new AwsomeWalletWallet(awsWallet));
}
