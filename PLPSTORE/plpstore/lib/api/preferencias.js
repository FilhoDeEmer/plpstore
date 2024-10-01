
import { MercadoPagoConfig } from 'mercadopago';

const client = new MercadoPagoConfig({ accessToken: '' });// acess token

const preference = new Preference(client);

preference.create({
  body: {
    items: [
      {
        title: 'My product',
        quantity: 1,
        unit_price: 0.05
      }
    ],
  }
})
.then(console.log)
.catch(console.log);
