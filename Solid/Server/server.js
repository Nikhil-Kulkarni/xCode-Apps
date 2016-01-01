var express = require('express')
var app = express();
var mongoose = require('mongoose');
var bodyParser = require('body-parser');
var User = require('./models/user.js');
var Request = require('./models/request.js');

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
mongoose.connect('mongodb://admin:pass@ds033915.mongolab.com:33915/solid');

var port = process.env.PORT || 8080;
var router = express.Router();

router.use(function(req,res, next) {
	console.log('Incoming request');
	next();
});

router.route('/')
	.get(function(req, res) {
		res.json({message: 'Welcome to Solid API'});
	});

router.route('/register')
	.post(function(req, res){
		var user = new User();
		user.name = req.body.name;
		user.phone_number = req.body.phone_number;
		user.solid_points = "0";
		user.save(function(err) {
			if (err) {
				res.send(err);
			} else {
				res.json({message: "Created Successfully"});
			}
		});
	});

router.route('/request')
	.post(function(req, res){
		var request = new Request();
		request.type = req.body.type;
		request.description = req.body.description;
		request.latitude = req.body.latitude;
		request.longitude = req.body.longitude;
		request.status = "Posted";
		request.phone_number = req.body.phone_number;
		request.solid_number = "";
		request.save(function(err) {
			if (err) {
				res.send(err);
			} else {
				res.json({message: 'Posted Request Successfully!'})
			}
		});
	})

	.put(function(req, res) {
		Request.findById(req.body.id, function(err, request) {
			if (err) {
				res.send(err);
			} else {
				request.comments.push({
					text: req.body.text
				});
				request.save(function(err) {
					if (err) {
						res.send(err);
					} else {
						res.json({message: 'Commented Successfully!'});
					}
				})
			}
		});
	})

	.get(function(req, res) {
		Request.find(function(err, requests) {
			if (err) {
				res.send(err);
			} else {
				res.json(requests);
			}
		})
	});

router.route('/solid')
	.put(function(req, res) {
		Request.findById(req.body.id, function(err, request) {
			if (err) {
				res.send(err);
			} else {
				request.status = "In process";
				request.solid_number = req.body.solid_number;
				request.save(function(err) {
					if (err) {
						res.send(err);
					} else {
						res.json({message: "Status updated Successfully!"});
					}
				});
			}
		});
	})
	.delete(function(req, res) {
		Request.remove({
			_id: req.body.id
		}, function(err, request) {
			if (err) {
				res.send(err);
			}
			res.json({message: 'Solid completed'});
		});
	});

app.use('/api', router);
app.listen(port);
console.log('Server started on port: ' + port);