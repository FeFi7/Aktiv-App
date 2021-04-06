const express = require('express')
const compression = require('compression')
const bodyParser = require('body-parser')
const routerVeranstaltungen = require('./routes/veranstaltungRoute')

const app = express()
const port = 3000

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.use(compression())

app.use('/api/veranstaltungen', routerVeranstaltungen)
app.get('/api/*',async (req, res) => res.send('Hello Aktiv App API!'))
app.get('/',async (req, res) =>  res.send('Hello Aktiv App!'))

app.listen(port, () => console.log('Example app listening on port '+ port +'!'))
