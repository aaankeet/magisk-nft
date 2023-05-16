import React from 'react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';

function Header() {
  return (
    <div className='flex bg-grey-200 justify-around gap-5 pt-5 pb-6 rounded-none border-green-600'>
      <h1 className='flex ml-5 text-pink-600 font-bold text-3xl'>Magisk.</h1>
      <div className=' flex gap-20 pt-2 text-black '>
        <br />
        <Link href='/' className='font-LeagueSpartan text-1xl'>
          Home
        </Link>
        <Link href='/Lounge' className='font-LeagueSpartan text-1xl'>
          Lounge
        </Link>
        <Link href='/Events' className='font-LeagueSpartan text-1xl'>
          Events
        </Link>
        <Link href='/Refill' className='font-LeagueSpartan text-1xl'>
          Refill
        </Link>
      </div>
      <ConnectButton />
    </div>
  );
}

export default Header;
