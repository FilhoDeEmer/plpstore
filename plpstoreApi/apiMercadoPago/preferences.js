const { MercadoPagoConfig, Preference } = require("mercadopago");
const client = new MercadoPagoConfig({
  accessToken:
    "APP_USR-6558376728906994-041714-06373b57e10b878abe198ed0914acf09-1728049498",
  options: { timeout: 5000, idempotencyKey: "abc" },
});

const preference = new Preference(client);
const  createPreference = async(data) => {
  const body = {
    items: [
      {
        id: data.id || "1234",
        title: "Compra Teste",
        description: "Dummy description",
        picture_url: "http://www.myapp.com/myimage.jpg",
        category_id: "car_electronics",
        quantity: 1,
        currency_id: "BRL",
        unit_price: 0.01,
      },
    ],
    payer: {
      name: "Test",
      surname: "User",
      email: "your_test_email@example.com",
      phone: {
        area_code: "11",
        number: "4444-4444",
      },
      identification: {
        type: "CPF",
        number: "19119119100",
      },
      address: {
        zip_code: "06233200",
        street_name: "Street",
        street_number: 123,
      },
    },
    back_urls: {
      success: "http://192.168.1.8:3000/pagamento-aprovado",
      failure: "http://192.168.1.8:3000/aguardando-pagamento",
      pending: "http://192.168.1.8:3000/aguardando-pagamento",
    },
    expires: false,
    auto_return: "all",
    notification_url: "http://notificationurl.com",

    statement_descriptor: "Plp Store",
  };

  try {
    const response = await preference.create({ body });
    link_pagamento = response["init_point"];
  } catch (error) {
    console.error(error);
  }

  return link_pagamento;
}
module.exports = {
  createPreference,
};


