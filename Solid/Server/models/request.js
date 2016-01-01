var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var requestSchema = new Schema({
	type: String,
	latitude: String,
	longitude: String,
	description: String, // Limit to 75 characters
	comments: [{
		text: String // Limit to 75 characters
	}],
	status: String,
	phone_number: String,
	solid_number: String
});

module.exports = mongoose.model('Request', requestSchema);