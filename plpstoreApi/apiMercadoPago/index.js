const express = require('express');
const path = require('path');
const {createPreference} = require ('./preferences.js')

const app = express();
app.use(express.json());

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.get('/create-preference',async (req,res) => {
    //tenho que receber as informações do app de alguma forma, depois, essa api pode inserir os dados na tabela venda ou o proprio ap pode fazer isso antes e só chamar essa api apos a criar os dados no banco com sucesso e depos passo os dados para criar a preferencia 
    const data = req.body;
    try {
        const preferenceResponse = await createPreference(data);
        res.redirect(preferenceResponse);
        // se a preferencia for cirada com sucesso, devo redirecionar para a tela de checkout do mercado pago que nada mais é do qeu o link da recebido, esse link vai retornar muitos dados, incluindo o status do pagamento, caso o status seja 'sucesso', essa api pode alterar o dado na tabela vendas
    } catch (error) {
        res.status(500).json({error : error.message});
    }
    
});

app.get('/pagamento-aprovado', (req , res) => {
    res.render('aprovado', { message: 'Sua trancação está sendo processada. Aguarde!'})
    //aqui deve vir  função para alterar os dados no banco
})
app.get('/aguardando-pagamento', (req,res) => {
    res.render('pendente', { message: 'Sua trancação está sendo processada. Aguarde!'})
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});