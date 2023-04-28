import { Html, Head, Main, NextScript } from 'next/document';

export default function Document() {
  return (
    <Html lang='en'>
      <Head />
      <body class='font-[League+Spartan] bg-gradient-to-t from-[#000000] to-[#000000] h-screen'>
        <Main />
        <NextScript />

        <link rel='preconnect' href='https://fonts.googleapis.com' />
        <link rel='preconnect' href='https://fonts.gstatic.com' crossorigin />
        <link
          href='https://fonts.googleapis.com/css2?family=League+Spartan:wght@500;600;700;800;900&family=Oswald:wght@700&display=swap'
          rel='stylesheet'
        ></link>
      </body>
    </Html>
  );
}
