const express = require('express')
const compression = require('compression')
const routerVeranstaltungen = require('./routes/veranstaltung')

const app = express()
const port = 3000

app.use(compression())

app.use('/api/veranstaltung', routerVeranstaltungen)
app.get('/api/*',async (req, res) => res.send('Hello Aktiv App API!'))
app.get('/',async (req, res) => res.send('Hello Aktiv App!'))

app.listen(port, () => console.log('Example app listening on port '+ port +'!'))