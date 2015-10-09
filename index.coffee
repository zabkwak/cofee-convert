coffee = require "coffee-script"
uglify = require "uglify-js"
fs = require "fs"
async = require "async"

__cache = {}
__options = 
	srcDir: "./assets"
	outDir: "/script"
	cacheTime: 86400
	minify: yes
	lazy: no

__send = (req, res, cacheTime) ->
	res.setHeader "content-type", "text/javascript"
	res.setHeader "Cache-Control", "max-age=#{cacheTime}, public"
	res.setHeader "Pragma", "public"
	res.end __cache[req.url]

__convert = (file, out, minify, cb) ->
	fs.readFile file, "UTF-8", (err, data) =>
		return cb err if err
		try 
			js = coffee.compile data.toString(), bare: yes
		catch e
			return cb e 
		if minify
			result = uglify.minify js, fromString: yes
			js = result.code
		__cache[out] = js
		cb? no, js


module.exports = (options = {}) ->
	@options = {}
	@options[k] = v for k, v of options
	for k, v of __options
		continue unless @options[k] is undefined
		@options[k] = v
	
	reg = new RegExp "^#{@options.outDir}/.+.js$"
	unless @options.lazy
		fs.readdir @options.srcDir, (err, files) =>
			return console.error err if err
			async.each files, (file, callback) =>
				path = "#{@options.srcDir}/#{file}"
				out = path.replace @options.srcDir, @options.outDir
				out = out.replace /\.coffee/, ".js"
				__convert path, out, @options.minify, (err, data) ->
					return callback err if err
					console.log "#{path} compiled"
					callback()
			, (err) ->
				return console.error err if err
				console.log "files compiled"

	return (req, res, next) =>
		return next() unless reg.test req.url
		return __send req, res, @options.cacheTime if __cache[req.url]
		path = req.url.replace @options.outDir, @options.srcDir
		path = path.replace /\.js/, ".coffee"
		out = req.url
		__convert path, out, @options.minify, (err, data) ->
			if err
				console.error err
				return next()
			__send req, res, @options.cacheTime


