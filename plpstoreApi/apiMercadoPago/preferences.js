const { MercadoPagoConfig, Preference } = require("mercadopago");
const client = new MercadoPagoConfig({
  accessToken:
    "",
  options: { timeout: 5000, idempotencyKey: "abc" },
});

const preference = new Preference(client);
const  createPreference = async(data) => {
  const body = {
    items: [
      {
        id: data.id || "1234",
        title: "Cartas da PLP Store",
        category_id: "jogo_de_cartas",
        quantity: 1,
        picture_url: 'https://plpstore.com.br/img/logo.png',
        currency_id: "BRL",
        unit_price: 1.01,
      },
    ],
    back_urls: {
      success: "http://url/pagamento-aprovado",
      failure: "http://url/aguardando-pagamento",
      pending: "http://url/aguardando-pagamento",
    },
    expires: false,
    auto_return: "all",
    notification_url: "http://notificationurl.com",//url para enviar email para cliente????

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


