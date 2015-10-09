# Coffee Converter

[Express](https://www.npmjs.com/package/express) middleware. Converts all *coffee* files in the directory to the *js* files. Out js strings are stored in memory. 

## Usage
```coffeescript
express = require "express"
coffee = require "coffee-convert"

port = 8080
app = express()

app.use coffee()

app.listen port
console.log "Listening on #{port}"
```

## Options
- **srcDir** Directory is scanned for .coffee files. Default: ./assets
- **outDir** Directory in uri for js link. Default: /script
- **cacheTime** Time in seconds for which is the js file cached in the browser. Default: 86400
- **minify** If true the js file is minified. Default: true
- **lazy** If true files are converted when there're needed. Otherwise files are converted after the middleware usage. Default: false