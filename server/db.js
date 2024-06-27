const mongoose = require('mongoose');
const { Schema } = mongoose;

// MongoDB connection
mongoose.connect('mongodb+srv://the_dev_karan:N51SL1HOfxT8mLf0@pdfriend.wgm7dyw.mongodb.net/?retryWrites=true&w=majority&appName=pdfriend');

// Message schema
const messageSchema = new Schema({
    // senderId: { type: String, required: false },
    // recipientId: { type: String, required: false },
    message: { type: String, required: true },
    otp: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

// Message model
const Message = mongoose.model('TextStuffs', messageSchema);

// Function to save a text message to MongoDB
function saveMessage( message, otp) {
    const newMessage = new Message({
        // senderId,
        // recipientId,
        message,
        otp
    });
    return newMessage.save();
}

// Function to retrieve a text message from MongoDB based on OTP
function getMessage(otp) {
    return Message.findOne({ otp }).exec();
}

module.exports = {
    saveMessage,
    getMessage
};
