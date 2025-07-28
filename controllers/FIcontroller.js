const db = require('../db');

// View All Financial Institutions
exports.getAllFIs = (req, res) => {
    const sql = 'SELECT * FROM financial_institute';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching FIs:', err.message);
            return res.status(500).send('Error retrieving financial institutions');
        }
        res.render('viewFI', { institutions: results });
    });
};

// View One Financial Institution
exports.getFIById = (req, res) => {
    const fiId = req.params.id;
    const sql = 'SELECT * FROM financial_institute WHERE FI_id = ?';
    db.query(sql, [fiId], (err, results) => {
        if (err) {
            console.error('Error fetching FI:', err.message);
            return res.status(500).send('Error retrieving financial institution');
        }
        if (results.length > 0) {
            res.render('viewOneFI', { institution: results[0] });
        } else {
            res.status(404).send('Institution not found');
        }
    });
};



// Render Edit FI Form
exports.editFIForm = (req, res) => {
    const fiId = req.params.id;
    const sql = 'SELECT * FROM financial_institute WHERE FI_id = ?';
    db.query(sql, [fiId], (err, results) => {
        if (err) {
            console.error('Error retrieving FI:', err.message);
            return res.status(500).send('Error retrieving institution');
        }
        if (results.length > 0) {
            res.render('editFI', { institution: results[0] });
        } else {
            res.status(404).send('Institution not found');
        }
    });
};

// Update FI
exports.editFI = (req, res) => {
    const fiId = req.params.id;
    const { institute_name, institute_email, institute_contact_name, institute_phone_number } = req.body;
    const sql = `
        UPDATE financial_institute 
        SET institute_name = ?, institute_email = ?, institute_contact_name = ?, institute_phone_number = ? 
        WHERE FI_id = ?
    `;
    db.query(sql, [institute_name, institute_email, institute_contact_name, institute_phone_number, fiId], (err, result) => {
        if (err) {
            console.error('Error updating FI:', err.message);
            return res.status(500).send('Error updating institution');
        }
        // Notification: FI updated
        const notificationController = require('./notificationController');
        notificationController.addNotification(fiId, 'FI Updated', `Financial Institution (${institute_name}) details updated.`, null);
        res.redirect('/institutions');
    });
};

// Delete FI
exports.deleteFI = (req, res) => {
    const fiId = req.params.id;
    const sql = 'DELETE FROM financial_institute WHERE FI_id = ?';
    db.query(sql, [fiId], (err, result) => {
        if (err) {
            console.error('Error deleting FI:', err.message);
            return res.status(500).send('Error deleting institution');
        }
        // Notification: FI deleted
        const notificationController = require('./notificationController');
        notificationController.addNotification(fiId, 'FI Deleted', `Financial Institution (ID: ${fiId}) was deleted.`, null);
        res.redirect('/institutions');
    });
};

exports.getMyAccount = (req, res) => {
    const fiId = req.session.user.FI_id; // assuming session stores FI_id
    const sql = 'SELECT * FROM financial_institute WHERE FI_id = ?';
    db.query(sql, [fiId], (err, results) => {
        if (err) {
            console.error('Error retrieving FI:', err.message);
            return res.status(500).send('Error retrieving institution');
        }
        if (results.length > 0) {
            res.render('editFI', { institution: results[0], allowEdit: true });
        } else {
            res.status(404).send('Institution not found');
        }
    });
};
