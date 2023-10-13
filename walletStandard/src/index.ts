import { initialize } from './initialize.js'; './initialize';
import { AwsomeWalletWallet } from './wallet';

window.wsInjections = {
    Setup: initialize
}

declare global {
    interface Window {
        wsInjections: {
            Setup: typeof initialize;
        };
    }
}