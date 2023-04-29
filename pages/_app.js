import '@/styles/globals.css';
import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider, getDefaultWallets } from '@rainbow-me/rainbowkit';
import { createClient, configureChains, WagmiConfig } from 'wagmi';
import { jsonRpcProvider } from 'wagmi/providers/jsonRpc';
import { shardeumSphinx } from 'wagmi/chains';
import Header from './components/Header.jsx';

const { chains, provider } = configureChains(
  [shardeumSphinx],
  [
    jsonRpcProvider({
      rpc: (shardeumSphinx) => ({
        https: `https://sphinx.shardeum.org/`,
      }),
    }),
  ]
);
const id = '345b8d88ebea1ec8fe7c27963b4a1789';

const { connectors } = getDefaultWallets({
  appName: 'Magisk',
  // projectId: id,
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
});

export default function App({ Component, pageProps }) {
  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains}>
        <Component {...pageProps} />
      </RainbowKitProvider>
    </WagmiConfig>
  );
}
