const express = require("express");
const path = require("path");
const { createPreference } = require("./preferences.js");

const app = express();
app.use(express.json());

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.get("/create-preference", async (req, res) => {
  //tenho que receber as informações do app de alguma forma, depois, essa api pode inserir os dados na tabela venda ou o proprio ap pode fazer isso antes e só chamar essa api apos a criar os dados no banco com sucesso e depos passo os dados para criar a preferencia
  
  const data = req.query;
  try {
    const preferenceResponse = await createPreference(data);
    res.redirect(preferenceResponse);
    // se a preferencia for cirada com sucesso, devo redirecionar para a tela de checkout do mercado pago que nada mais é do qeu o link da recebido, esse link vai retornar muitos dados, incluindo o status do pagamento, caso o status seja 'sucesso', essa api pode alterar o dado na tabela vendas
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get("/pagamento-aprovado", (req, res) => {
  const {
    collection_id,
    collection_status,
    payment_id,
    status,
    external_reference,
    payment_type,
    merchant_order_id,
    preference_id,
    site_id,
    processing_mode,
    merchant_account_id,
  } = req.query;
  const message = `
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
  res.render("aprovado", { message });
  //aqui deve vir  função para alterar os dados no banco
});
app.get("/aguardando-pagamento", (req, res) => {
  res.render("pendente", {
    message:
      "Sua trancação está sendo processada. Status: Aguardando Pagamento",
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
