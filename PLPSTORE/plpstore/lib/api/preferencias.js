
import { MercadoPagoConfig } from 'mercadopago';

const client = new MercadoPagoConfig({ accessToken: 'APP_USR-6558376728906994-041714-06373b57e10b878abe198ed0914acf09-1728049498' });// acess token

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
