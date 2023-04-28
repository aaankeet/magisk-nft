import React from 'react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import Link from 'next/link';
function Header() {
  return (
    <div className=' flex justify-between gap-4 pr-20 pt-5 border-slate-800'>
      <h1 className='text-pink-600 text-bold font-bold text-2xl items-end pl-5  underline decoration-sky-500'>
        Magisk
      </h1>
      <div className=' flex gap-5 pt-2 place-content-end  text-white '>
        <Link href='/Home'>Home</Link>
        <Link href='/Lounge'>Lounge</Link>
        <Link href='/About'>About</Link>
      </div>
      <ConnectButton />
    </div>
  );
}

export default Header;
