var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
	name: String,
	phone_number: String,
	solid_points: String
});

module.exports = mongoose.model('User', userSchema);