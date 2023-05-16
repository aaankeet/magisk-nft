import '@/styles/globals.css';
import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider, getDefaultWallets } from '@rainbow-me/rainbowkit';
import { createClient, configureChains, WagmiConfig } from 'wagmi';
import { alchemyProvider, infuraProvider } from 'wagmi/providers/infura';
import { polygonMumbai, sepolia } from 'wagmi/chains';

const { chains, provider } = configureChains(
  [sepolia],
  [infuraProvider({ apiKey: process.env.INFURA_API_KEY })]
);

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
