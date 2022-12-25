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
        res.status(500).json({ error: e.message });
    }
});

documentRouter.get('/docs/me', auth, async (req, res) => {

    try {
        
        let docs = await Document.find({ uid: req.user });
        res.json(docs);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

documentRouter.post('/doc/title', auth, async (req, res) => {
    try {
        const { id, title } = req.body;

        const doc = await Document.findByIdAndUpdate(id, { title });
        
        res.json(doc);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

documentRouter.get('/doc/:id', auth, async (req, res) => {

    try {
        
        const doc = await Document.findById(req.params.id);
        res.json(doc);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = documentRouter;
