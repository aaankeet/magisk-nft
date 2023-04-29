import React from 'react';
import Header from './components/Header';

function Lounge() {
  const handleSumbit = () => {
    document.getElementById('submitBtn').addEventListener('click', function () {
      window.location.href = '/Lounge/chillspace';
    });
  };

  return (
    <div>
      <Header />
      <div>
        <h1 className='head_text pb-3 '>Welcome to the Lounge</h1>

        <h2 className='desc mt-2'>
          Join the Exclusive NFT Holder Lounge for Web3 Discussions and
          Networking
        </h2>
        <p className='desc justify-center text-center text-sm pt-3'>
          Are you a proud NFT holder looking to connect with like-minded <br />
          individuals in the Web3 space? Look no further than our exclusive NFT
          Holder Lounge,
          <br /> where you can join fellow enthusiasts to discuss the latest
          trends, share ideas, and network with one another.
        </p>
        <br />

        <div className='flex text-white justify-evenly mt-10 pt-14'>
          <h1 className=' text-4xl font-LeagueSpartan'>Chat</h1>
          <h1 className='text-4xl font-LeagueSpartan'>Connect</h1>
          <h1 className='text-4xl font-LeagueSpartan'>Level-Up</h1>
        </div>
        <div className='flex justify-center items-center pr-20 pt-8 pl-6'>
          <button
            id='submitBtn'
            type='submit'
            className='btn'
            onClick={handleSumbit}
          >
            Enter Lounge
          </button>
        </div>

        <h2 className='desc justify-center text-center text-sm mt-5'>
          Join the NFT Holder Lounge today and take your Web3 journey to the
          next level.
        </h2>
      </div>
    </div>
  );
}

export default Lounge;
