
const  express = require("express");
const User = require("../models/user");

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {

    try {

        const { name, email, profilePic } = req.body;
        
        // email already exists?
        let user = await User.findOne({email});

        if (!user) {
            user = new User({
                name,
                email,
                profilePic,
            });

            user = await user.save();   
        }

        // store data
        res.json({ user });

    } catch (e) {

    }

});

module.exports = authRouter;