import Header from './components/Header.jsx';
import Image from 'next/image.js';
import nft0 from '../public/nft0.png';
import nft1 from '../public/nft1.png';
import { ethers } from 'ethers';
import {
  useAccount,
  useContractRead,
  useContractWrite,
  usePrepareContractWrite,
} from 'wagmi';
import {
  abi,
  contractAddress,
  silverNft,
  goldNft,
} from '../constants/index.js';
import { parseEther } from 'ethers/lib/utils.js';
import { useEffect } from 'react';

export default function Home() {
  const { isConnected } = useAccount();

  useEffect(() => {
    if (!isConnected) {
      alert('Please Connect Wallet');
    }
  });

  const silverId = 0;
  const amount = ethers.utils.parseEther('1') / 2;
  console.log(amount);

  const { data, write: mintSilverNft } = useContractWrite({
    address: contractAddress,
    abi: abi,
    functionName: 'mintNft',
    args: [0],
    overrides: {
      value: parseEther('0.5'),
    },
  });
  const { write: mintGoldNft } = useContractWrite({
    address: contractAddress,
    abi: abi,
    functionName: 'mintNft',
    args: [1],
    overrides: {
      value: parseEther('0.8'),
    },
  });

  return (
    <main>
      <Header></Header>

      <div className='mt-10 mb-5'>
        <h1 className='text-5xl font-extrabold font-LeagueSpartan text-center text-pink-700'>
          MAGISK
        </h1>
      </div>

      <h1 className='text-black text-center text-2xl font-LeagueSpartan'>
        Get Exclusive access to Events accross the World, Lounge and Enjoy
        Accociated Perks only for Magisk Nft Holders.
      </h1>

      <h1
        className='text-2xl text-center 
      mt-8 font-bold
      text-transparent
      bg-clip-text
      bg-gradient-to-r
      from-pink-400
      to-purple-500
      '
      >
        Mint Now & Enjoy Exclusive Benefits{' '}
      </h1>
      <div className='flex justify-center gap-40 mt-10'>
        <a href={silverNft} target={silverNft}>
          <div className='image-container'>
            <Image
              src={nft0}
              alt='silver-nft'
              width='250'
              height='100'
              className='border'
            />
            <div className='overlay'></div>
          </div>
        </a>
        <a href={goldNft} target={goldNft}>
          <div className='image-container'>
            <Image
              src={nft1}
              alt='Gold-Nft'
              width='250'
              height='100%'
              className='border'
            />
            <div className='overlay'></div>
          </div>
        </a>
      </div>
      <br />

      <div className='flex justify-center gap-60 '>
        <button
          className='button'
          onClick={() => {
            mintSilverNft?.();
          }}
        >
          Mint Silver 0.5 ETH
        </button>
        <button
          className='button'
          onClick={() => {
            mintGoldNft?.();
          }}
        >
          Mint Gold 0.8 ETH
        </button>
      </div>

      <br />

      <div className='flex flex-col pt-15 mt-10 items-center'>
        <h1 className='text-4xl text-pink-500 ml-7 pl-5 '>What is Magisk?</h1>
        <p className='text-grey text-m  ml-7 pl-5 text-center'>
          Magisk is a project that enables users to mint NFTs in the form of
          Silver and Gold with each NFT having a limited number of uses.
          <br /> The concept behind Magisk is similar to physical cards such as
          metro cards, where users can use the cards to access certain services.
          <br /> The Magisk NFTs can be used in various ways, such as gaining
          access to online/offline events or buying free food in offline events.
          <br /> Users can simply scan the QR code at the entrance of the events
          to gain access if they have the NFT and it has usage limits remaining.
          <br /> Magisk is not limited to just events, as it provides many other
          utilities for NFT holders, making it a versatile and practical
          project.
        </p>
      </div>
    </main>
  );
}
