const express = require("express");
const path = require("path");
const { createPreference } = require("./preferences.js");
const { searchPayment } = require("./payment.js");

const app = express();
app.use(express.json());

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.get("/create-preference", async (req, res) => {
  // essa api pode inserir os dados na tabela venda ou o proprio app pode fazer isso antes, e só chamar essa api apos criar os dados no banco com sucesso e depois passa os dados para criar a preferencia

  const data = req.query;
  try {
    const linkpayment = await createPreference(data);
    return res.redirect(linkpayment);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});
app.get("/pagamento-aprovado", async (req, res) => {
  var message;
  //informações que o MP retorna via query
  const {
    collection_status,
    payment_id,
    status,
    payment_type,
    merchant_order_id,
    preference_id,
    site_id,
    processing_mode,
  } = req.query;
  //consulta o status do pagamento se for via pix
  if (collection_status == "pending") {
    try {
      const payment = await searchPayment(payment_id);
      const {
        id,
        date_approved,
        date_created,
        payment_method_id,
        status,
        transaction_amount,
      } = payment;
      message = `
        Sua transação foi aprovada.
        Id: ${id}
        Data da Criação: ${new Date(date_created).toLocaleString("pt-BR")}
        Data da Aprovação: ${new Date(date_approved).toLocaleString("pt-BR")}
        Status: ${status}
        Pagamento via: ${payment_method_id}
        Quantia: R$ ${transaction_amount.toFixed(2)}
      `;
    } catch (error) {
      return res.status(500).json({ error: error.message });
    }
  } else {
    message = `
    Sua transação foi aprovada.
    Collection ID: ${collection_id}
    Collection Status: ${collection_status}
    Payment ID: ${payment_id}
    Status: ${status}
    External Reference: ${external_reference}
    Payment Type: ${payment_type}
    Merchant Order ID: ${merchant_order_id}
    Preference ID: ${preference_id}
    Site ID: ${site_id}
    Processing Mode: ${processing_mode}
    Merchant Account ID: ${merchant_account_id}
  `;
  }

  return res.render("aprovado", { message });
  //aqui deve vir  função para alterar os dados no banco
  // a principal informação que devo mandar é o collection_id que serve para fazer consulgta na api do mercado paga para saber o status do pagamento, principalmente se for via pix
});
app.get("/aguardando-pagamento", (req, res) => {
  return res.render("pendente", {
    message:
      "Sua trancação está sendo processada. Status: Aguardando Pagamento",
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
