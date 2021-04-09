const express = require('express')
const compression = require('compression')
//const bodyParser = require('body-parser')
const routerVeranstaltungen = require('./routes/veranstaltungRoute')
const routerUser = require('./routes/userRoute')
const routerFileUpload = require('./routes/fileUploadRoute')

const app = express()
const port = 3000

app.use(express.urlencoded({ extended: false }))
app.use(express.json())

app.use(compression())

app.use('/api/veranstaltungen', routerVeranstaltungen)
app.use('/api/user', routerUser)
app.use('/api/fileupload', routerFileUpload)
app.get('/api/*',async (req, res) => res.send('Hello Aktiv App API!'))
app.get('/',async (req, res) =>  res.send('Hello Aktiv App!'))

app.listen(port, () => console.log('AktivApp Backend listening on port '+ port +'!'))
