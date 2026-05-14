const express = require('express');
const router = express.Router();
const katalogController = require('../controllers/katalogController.js');
const {authenticateToken} = require('../middleware/auth.js');
const upload = require('../middleware/upload.js');

const {isAdmin} = require('../middleware/permission.js')

router.post('/', authenticateToken, isAdmin, upload.single('gambar'), katalogController.createKatalog);
router.put('/:id', authenticateToken, isAdmin, katalogController.updateKatalog);
router.delete('/:id', authenticateToken, isAdmin,katalogController.deleteKatalog);
router.get('/', katalogController.getAllKatalog);
router.get('/:id', katalogController.getKatById);
// router.post('/katalog', upload.single('gambar'), katalogController.createKatalog);

module.exports = router;