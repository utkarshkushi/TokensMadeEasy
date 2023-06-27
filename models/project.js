const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
    address: {
        type: String,
        required: true
      },
    name: {
    type: String,
    required: true
  },
  symbol: {
    type: String,
    required: true
  },

  tokensPerEth: {
    type: Number,
    required: true
  },
  initialMint: {
    type: Number,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  
  incentives: {
    type: [String],
    required: true
  },
  web: {
    type: String,
    required: true
  },
  link: {
    type: String
  },
  
 
});

module.exports = mongoose.model('Project', projectSchema);