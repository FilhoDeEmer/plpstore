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
        title: "Cartas da PLP Store",
        category_id: "jogo_de_cartas",
        quantity: 1,
        picture_url: 'https://plpstore.com.br/img/logo.png',
        currency_id: "BRL",
        unit_price: 1.01,
      },
    ],
    back_urls: {
      success: "http://192.168.1.8:3000/pagamento-aprovado",
      failure: "http://192.168.1.8:3000/aguardando-pagamento",
      pending: "http://192.168.1.8:3000/aguardando-pagamento",
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


// http://192.168.1.8:3000/pagamento-aprovado?collection_id=82687067905&collection_status=approved&payment_id=82687067905&status=approved&external_reference=null&payment_type=credit_card&merchant_order_id=20829679879&preference_id=1728049498-b3fe9624-1f68-48ac-a623-166bcdf36b4b&site_id=MLB&processing_mode=aggregator&merchant_account_id=null