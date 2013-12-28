#!/usr/bin/env node
/*
 * This script requies Node.JS and the following modules
 *   - request
 *   - cheerio
 */

var fs = require('fs');
var request = require("request");
var cheerio = require("cheerio");

// Get arguments
var args = process.argv.slice(2);

request({
	uri: "http://sumai.ur-net.go.jp/chintai/s/danchi/8080" + args[0] + ".html",
}, function(error, res, body) {
	var $ = cheerio.load(body);
	$("table.housing_complex_table").each(function() {
		console.log($(this).length);
	});
});