import Header from './components/Header.jsx';
import Image from 'next/image.js';
import nft0 from '../public/nft0.png';
import nft1 from '../public/nft1.png';

export default function Home() {
  return (
    <main>
      <Header></Header>
      <div className='mt-10 mb-5'>
        <h1 className='text-5xl font-extrabold font-LeagueSpartan text-center text-pink-700'>
          MAGISK
        </h1>
      </div>
      <h1 className='text-white text-center text-2xl font-LeagueSpartan'>
        Get Exclusive access to Our Lounge, Events accross the world and Enjoy
        Accociated Perks only for Magisk Nft Holders
      </h1>
      <div className='flex justify-center gap-40 mt-20'>
        <Image
          src={nft0}
          alt='silver-nft'
          width='250'
          height='100'
          className='border'
        />
        <Image
          src={nft1}
          alt='Gold-Nft'
          width='250'
          height='100'
          className='border'
        />
      </div>
    </main>
  );
}
