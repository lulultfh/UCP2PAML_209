const express = require('express');
const router = express.Router();
const kategoriController = require('../controllers/kategoriController.js');

const {authenticateToken} = require('../middleware/auth.js');
const {isAdmin} = require('../middleware/permission.js')

router.post('/', authenticateToken, isAdmin, kategoriController.createKategori);
router.put('/:id', authenticateToken, isAdmin, kategoriController.updateKategori);
router.delete('/:id', authenticateToken, isAdmin, kategoriController.deleteKategori);
router.get('/', authenticateToken, kategoriController.getAllKat);

module.exports = router;