
'use strict';

var debug_enable = true;

function debug(message) {
	if (debug_enable) {
		print(message);
	}
};

function print(message) {
	var now = new Date();
	console.log('[' + now + '] ' + JSON.stringify(message, null, '\t'));
};

// Ivars
var allChefs = [ ];

// Modules
var express = require('express');
var app = express();
var url = require('url');
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false}));

// Braintree
var braintree = require('braintree');
var gateway = braintree.connect({
	environment: braintree.Environment.Sandbox,
	merchantId: '7hxkq9rvzjv6fnvc',
	publicKey: '34592bdwr7tfjdct',
	privateKey: '64b4b640bb25a94f5840aad3d6a0780e'
});
var customerID = {};
gateway.customer.create({
	firstName: 'Justin',
	lastName: 'Loew',
	email: 'SquirrelFruit@aol.com',
	phone: '555.555.5555'
}, function(err, result) {
	if (err) {
		print(err);
	} else {
		debug('successfully created customer: ' + result.success + ' ' + result.customer.id);
		customerID = result.customer.id;
	}
});

app.get('/client_token', function(req, res) {
	gateway.clientToken.generate({
		customerId: customerID
	}, function(err, response) {
		res.json({client_token: response.clientToken});
	});
});

app.post('/payment_methods', function(req, res) {
	var nonce = req.body.payment_method_nonce;
//	var nonce = req.query['payment_method_nonce'];
	debug('Received nonce ' + nonce);
	res.send("yes");

	
	gateway.transaction.sale({
		amount: '10.00',
		paymentMethodNonce: nonce,
	}, function(err, result) {
		if (err) {
			print(err);
		} else {
			debug('Sale:');
			debug(result);
		}
	});
});

// Server
app.get('/api', function(req, res) {
	// check for chef requests
	var chefsRequested = req.query['chefs'];
	if (chefsRequested)
		handleChefsRequested(chefsRequested, res);
});

app.get('/img/:name', function(req, res) {
	var options = {
		root: __dirname + '/img/',
		dotfiles: 'deny',
		headers: {
			'x-timestamp': Date.now(),
			'x-sent': true
		}
	};
	
	var fileName = req.params.name;
	res.sendFile(fileName, options, function(err) {
		if (err) {
			print(err);
			res.status(err.status).end();
		} else {
			debug('Sent: ' + fileName);
		}
	});
});

app.post('/recipe', function(req, res) {
	res.send('Got a POST request');
});

app.get('/debug', function(req, res) {
	res.send('Hello, World!');
});

var server = app.listen(3000, function() {
	var host = server.address().address;
	var port = server.address().port;
	print('Listening at http://' + host + ':' + port);
});

// Request handlers
function handleChefsRequested(chefsRequested, res) {
	print('Chef request handler called');
	// serialize chefs
	var chefs = {};
	// get chefs to send
	if (chefsRequested === '*')
		for (var i in allChefs) {
			var chef = allChefs[i];
			chefs[chef.id] = chef;
		}
	else
		for (var chefReqIdx in chefsRequested) {
			var chefReq = chefsRequested[chefReqIdx];
			chefs[chefReq] = allChefs[chefForID(chefReq)];
		}
	// send
	debug({ chefs: chefs });
	if (debug_enable) {
		// send pretty JSON
		res.type('json');
		res.send(JSON.stringify({ chefs: chefs }, null, '\t'));
	} else {
		res.json({ chefs: chefs });
	}
};

// Helpers
function chefForID(id) {
	for (var chef in allChefs)
		if (chef.id === id)
			return chef;
};

// Dummy data
function addDummyData() {
	var recipeID = 1;
	var spaghetti = {
		id: recipeID,
		name: 'Spaghetti',
		image: '/img/' + recipeID + '.png'
	};

	var quinoaPilaf = {
		id: 'quinoaPilaf',
		name: 'Quinoa Pilaf',
		image: '/img/quinoa.png',
		desc: "This light and hearty dish is great for a thursday night meal. Loaded with plenty of crispy vegetables and hearty quinoa, this dish is perfect for weight loss"
	};

	var porkTacos = {
		id: 'porkTacos',
		name: 'Grilled Chipotle Pork Tacos',
		image: '/img/porkTacos.png',
		desc: "This sweet and savory dish provides a twist to a classic mexican dish. With the sweet pineapple and savory grilled pork complementing each other, one will find themselves saying only one thing, YUM!"
	};
	
	var chefID = 'ryan.mathiu@jellybelly.demo';
	var ryanMathiu = {
		id: chefID,
		name: 'Ryan Mathiu',
		profileImage: '/img/' + chefID + '.profile.png',
		backgroundImage: '/img/' + chefID + '.background.png',
		bio: "This is Ryan. Say hi to Ryan. Ryan cooks food. The food cooked by Ryan is tastygood.",
		locationCoordinates: {
			latitude: 41.84,
			longitude: -87.68
		},
		locationDescription: 'Chicago, IL',
		locationType: 'Home',
		rating: 0.82,
		recipes: [
			spaghetti
		]
	};
	allChefs.push(ryanMathiu);
	
	var lena = {
		id: 'Lena',
		name: 'Lena',
		profileImage: '/img/Lena.png',
		bio: "Lena is a simple woman who just wants to bring joy to people with her baked goods. She enjoys photography, transformation matrices, and long walks on the beach.",
		locationDescription: 'Lincoln Park',
		rating: 0.91,
		recipes: [
			quinoaPilaf,
			porkTacos
		]
	};
	allChefs.push(lena);

	var mrPebble = {
		id: 'MrPebble',
		name: 'Mr. Pebble',
		profileImage: '/img/MrPebble.png',
		bio: "Mr. Pebble is a man of simple pleasures. He's almost always in a good mood. Unfortunately, he has a tendency to melt into his food.",
		locationDescription: 'Urbana, IL',
		rating: 0.67,
		recipes: [
		]
	};
	allChefs.push(mrPebble);
};
if (debug_enable)
	addDummyData();

