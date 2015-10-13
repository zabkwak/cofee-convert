express = require "express"

coffee = require "../"

port = 8080
app = express()

app.use coffee
	debug: yes
	srcDir: "#{__dirname}/assets"

app.listen port
console.log "Listening on #{port}"
