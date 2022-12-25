const  express = require("express");
const Document = require("../models/document");
const auth = require("../middlewares/auth");

const documentRouter = express.Router();

documentRouter.post('/doc/create', auth, async (req, res) => {
    try {
        const { createdAt } = req.body;
        let doc = new Document({
            uid: req.user,
            title: 'Untitled Document',
            createdAt,
        });

        doc = await doc.save();
        
        res.json(doc);
    } catch (e) {

    }
});

module.exports = documentRouter;
