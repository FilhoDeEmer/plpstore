const { MercadoPagoConfig, Payment } = require("mercadopago");
const client = new MercadoPagoConfig({
  accessToken:
    "APP_USR-6558376728906994-041714-06373b57e10b878abe198ed0914acf09-1728049498",
  options: { timeout: 5000, idempotencyKey: "abc" },
});
const payment = new Payment(client);

const searchPayment = async (payment_id) => {
  try {
    const response = await payment.get({ id: payment_id });
    return response;
  } catch (error) {
    console.error(error);
    throw new Error("Erro ao buscar pagamento");
  }
};

module.exports = {
  searchPayment,
};
