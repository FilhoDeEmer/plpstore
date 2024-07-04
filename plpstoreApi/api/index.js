const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

// Configurar a conexão com o banco de dados MySQL
const connection = mysql.createConnection({
  host: '192.168.1.6',
  user: 'Emerson',
  password: '123456789',
  database: 'plpstore'
});

connection.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
    return;
  }
  console.log('Conectado ao banco de dados MySQL');
});

// Criar uma instância do aplicativo Express
const app = express();

// Middleware para processar corpo das requisições JSON
app.use(bodyParser.json());

// Rota de exemplo para buscar dados do banco de dados
app.get('/api/dados', (req, res) => {
  connection.query('SELECT * FROM mew151', (err, results) => {
    if (err) {
      console.error('Erro ao buscar dados do banco de dados:', err);
      res.status(500).send('Erro ao buscar dados do banco de dados');
      return;
    }
    res.json(results);
  });
});

// Iniciar o servidor na porta 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
