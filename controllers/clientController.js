// Render edit client form
exports.editClientForm = (req, res) => {
    const clientId = req.params.id;
    db.query('SELECT * FROM client WHERE client_id = ?', [clientId], (err, results) => {
        if (err || results.length === 0) {
            return res.status(404).send('Client not found');
        }
        res.render('editClient1', { client: results[0] });
    });
};
// Reports dashboard logic (restored and improved)
exports.viewReportDashboard = (req, res) => {
    const db = require('../db');
    // Fetch all clients
    db.query(`SELECT * FROM client`, async (err, clients) => {
        if (err) {
            return res.status(500).send('Error fetching clients: ' + err.message);
        }
        // Fetch blockchain clients
        let blockchainClients = [];
        try {
            if (contract && contract.methods && contract.methods.getAllClients) {
                const bcClients = await contract.methods.getAllClients().call();
                blockchainClients = bcClients.map(bc => ({
                    client_id: bc.id,
                    client_name: bc.name,
                    client_NRIC: bc.nric,
                    client_nationality: bc.nationality,
                    client_citizenship: bc.citizenship,
                    client_address: bc.addressLine,
                    client_postalcode: bc.postalCode,
                    client_gender: bc.gender,
                    client_cob: bc.countryOfBirth,
                    client_dob: bc.dateOfBirth,
                    client_home_number: bc.homeNumber,
                    client_phone_number: bc.phoneNumber,
                    client_occupation: bc.occupation,
                    client_employer_name: bc.employerName,
                    client_employer_number: bc.employerNumber,
                    risk_status: bc.riskStatus,
                    image: bc.image,
                    on_blockchain: 1
                }));
            }
        } catch (e) {
            console.error('Error fetching blockchain clients for report:', e);
        }
        // Country Risk Overview: group by client_nationality, count clients, avg total_risk_score
        db.query(`SELECT client_nationality AS country, COUNT(*) AS client_count, AVG(total_risk_score) AS avg_risk
                  FROM client
                  GROUP BY client_nationality
                  ORDER BY client_count DESC`, (err, countryRows) => {
            if (err) {
                return res.status(500).send('Error fetching country risk: ' + err.message);
            }
            // Fetch all transactions
            db.query(`SELECT * FROM transaction`, (err, txRows) => {
                if (err) {
                    return res.status(500).send('Error fetching transactions: ' + err.message);
                }
                res.render('viewReport', {
                    clients,
                    blockchainClients,
                    countryRisk: countryRows,
                    transactions: txRows
                });
            });
        });
    });
};
const db = require('../db');
const emailController = require('./emailController');

// List all clients

// Blockchain integration
const { Web3 } = require('web3');
const traceFIJson = require('../build/contracts/TraceFI.json');
const abi = traceFIJson.abi;
const contractAddress = process.env.CONTRACT_ADDRESS;
const web3 = new Web3(process.env.RPC_URL || 'http://localhost:8545');
const blockchainAccount = process.env.BLOCKCHAIN_ACCOUNT; // Must be unlocked or use private key
const contract = new web3.eth.Contract(abi, contractAddress);
exports.allClients = (req, res) => {
    // Fetch database clients
    const sql = `
        SELECT c.*, 
            (SELECT MAX(risk_score) FROM transaction t WHERE t.client_id = c.client_id) AS max_txn_risk
        FROM client c`;
    db.query(sql, async (err, results) => {
        if (err) {
            console.error("Error fetching clients:", err);
            return res.status(500).send("Error fetching clients");
        }
        results.forEach(client => {
            client.isNewClient = client.client_id >= 12;
            client.hideSendEmail = (client.risk_status === 'Blocked' || client.on_blockchain === 1);
        });

        // Fetch blockchain clients directly from contract
        let blockchainClients = [];
        try {
            if (contract && contract.methods && contract.methods.getAllClients) {
                const bcClients = await contract.methods.getAllClients().call();
                // Map blockchain client objects to a format usable by EJS
                blockchainClients = bcClients.map(bc => ({
                    client_id: bc.id,
                    client_name: bc.name,
                    client_NRIC: bc.nric,
                    client_nationality: bc.nationality,
                    client_citizenship: bc.citizenship,
                    client_address: bc.addressLine,
                    client_postalcode: bc.postalCode,
                    client_gender: bc.gender,
                    client_cob: bc.countryOfBirth,
                    client_dob: bc.dateOfBirth,
                    client_home_number: bc.homeNumber,
                    client_phone_number: bc.phoneNumber,
                    client_occupation: bc.occupation,
                    client_employer_name: bc.employerName,
                    client_employer_number: bc.employerNumber,
                    risk_status: bc.riskStatus,
                    image: bc.image,
                    on_blockchain: 1
                }));
            }
        } catch (e) {
            console.error('Error fetching blockchain clients:', e);
        }

        const emailSuccess = req.query.emailSuccess === '1';
        res.render('5_allClients', { 
            clients: results, 
            blockchainClients,
            success: emailSuccess ? 'Email sent successfully!' : '',
            currentFI: req.session.user ? req.session.user.FI_id : null,
        });
    });
};

exports.sendEmailToClient = (req, res) => {
    emailController.sendEmail(req, res);
};

function changeClientStatus(id) {
    let sql = "SELECT * FROM client where client_id = ?";
    db.query(sql, [id], (err, results) => {
        if (err) {
            console.error("Error fetching clients:", err);
            return res.status(500).send("Error fetching clients");
        }
        let client = results[0], max = client.low_vote_count, new_status = 'low';
        let votes = {
            'medium': client.medium_vote_count,
            'high': client.high_vote_count,
        };
        for (let status in votes) {
            if (votes[status] > max) {
                max = votes[status];
                new_status = status;
            }
        }
        sql = "UPDATE client SET risk_status = ? where client_id = ?";
        db.query(sql, [new_status, id], (err) => {
            if (err) {
                console.error("Error updating client:", err);
                return res.status(500).send("Error updating client");
            }
        });
    });
}


// Accept = block client, increment accept count, store on blockchain if 2+ accepts
exports.acceptStatusChange = async (req, res) => {
    const {id, status} = req.params;
    // Support sessionless: get FI id from query param if no session
    let fi_id = req.session.user ? req.session.user.FI_id : null;
    if (!fi_id && req.query.fi) {
        fi_id = parseInt(req.query.fi, 10);
    }
    const responderEmail = req.session.user ? req.session.user.institute_email : null;
    const responderName = req.session.user ? req.session.user.institute_name : null;
    const notificationController = require('./notificationController');
    // Prevent duplicate accepts by the same FI
    if (!fi_id) {
        return res.status(400).send("Missing FI identifier. Please use the link from your email or log in.");
    }
    db.query("SELECT * FROM verification WHERE client_id = ? AND verified_by = ? AND response = 'approved'", [id, fi_id], (err, existingRows) => {
        if (err) {
            console.error("Error checking for existing accept:", err);
            return res.status(500).send("Error checking for existing accept");
        }
        if (existingRows && existingRows.length > 0) {
            // Already accepted by this FI
            return res.status(400).send("You have already accepted this client.");
        }
        // Insert vote as 'accepted' (block)
        db.query("INSERT INTO verification (client_id, response, verified_by) VALUES (?, 'approved', ?)", [id, fi_id], (err) => {
            if (err) {
                console.error("Error recording vote:", err);
                return res.status(500).send("Error recording vote");
            }
            // Count unique accepts for this client
            db.query("SELECT COUNT(DISTINCT verified_by) AS acceptCount FROM verification WHERE client_id = ? AND response = 'approved'", [id], async (err, countRows) => {
                if (err) return res.status(500).send("Error counting accepts");
                const acceptCount = countRows[0].acceptCount;
                // If 2 or more unique accepts, block client and always store new details on blockchain (append-only)
                if (acceptCount >= 2) {
                    // Set risk_status to 'Blocked' and on_blockchain = 1
                    db.query("UPDATE client SET risk_status = 'Blocked', on_blockchain = 1 WHERE client_id = ?", [id], (err) => {
                        if (err) {
                            console.error('Error updating client status to Blocked:', err);
                        } else {
                            console.log(`Client ${id} status updated to Blocked.`);
                        }
                        // Always store new details on blockchain for every assessment
                        db.query("SELECT * FROM client WHERE client_id = ?", [id], async (err, clientRows) => {
                            if (!err && clientRows.length > 0) {
                                const client = clientRows[0];
                                let blockchainSuccess = false;
                                try {
                                    await contract.methods.registerClient(
                                        client.client_name,
                                        client.client_NRIC,
                                        client.client_nationality,
                                        client.client_citizenship,
                                        client.client_address,
                                        client.client_postalcode,
                                        client.client_gender,
                                        client.client_cob,
                                        client.client_dob,
                                        client.client_home_number,
                                        client.client_phone_number,
                                        client.client_occupation,
                                        client.client_employer_name,
                                        client.client_employer_number,
                                        client.risk_status,
                                        client.image || ''
                                    ).send({ from: blockchainAccount });
                                    blockchainSuccess = true;
                                    console.log(`Client ${client.client_id} stored on blockchain.`);
                                } catch (e) {
                                    console.error('Blockchain registerClient error:', e);
                                }
                                // No need to update on_blockchain again, already set above
                            } else {
                                console.error('Error fetching client for blockchain:', err);
                            }
                            // After blockchain, re-fetch clients and render allClients
                            if (!res.headersSent) {
                                db.query(`SELECT c.*, (SELECT MAX(risk_score) FROM transaction t WHERE t.client_id = c.client_id) AS max_txn_risk FROM client c`, (err, results) => {
                                    if (err) {
                                        if (!res.headersSent) return res.status(500).send("Error fetching clients");
                                    } else {
                                        results.forEach(client => {
                                            client.isNewClient = client.client_id >= 12;
                                            client.hideSendEmail = (client.risk_status === 'Blocked' || client.on_blockchain === 1);
                                        });
                                        if (!res.headersSent) {
                                            res.render('5_allClients', {
                                                clients: results,
                                                success: 'Client status updated and stored on blockchain!',
                                                currentFI: req.session.user ? req.session.user.FI_id : null,
                                            });
                                        }
                                    }
                                });
                            }
                        });
                    });
                }
                // Notify initiator FI
                db.query("SELECT client_name, FI_id FROM client WHERE client_id = ?", [id], (err, clientRows) => {
                    if (err || clientRows.length === 0) {
                        return res.render('confirmationEmail', { fiName: responderName, clientName: '', responseType: 'ACCEPTED', redirectHome: true });
                    }
                    const clientName = clientRows[0].client_name;
                    const initiatorFIId = clientRows[0].FI_id;
                    db.query("SELECT institute_email, institute_name FROM financial_institute WHERE FI_id = ?", [initiatorFIId], (err, fiRows) => {
                        const initiatorEmail = fiRows && fiRows[0] ? fiRows[0].institute_email : null;
                        const initiatorName = fiRows && fiRows[0] ? fiRows[0].institute_name : null;
                        if (initiatorFIId && fi_id) {
                            const notifTitle = `Client Blocked`;
                            const notifMsg = `${responderName} blocked client ${clientName}.`;
                            notificationController.addNotification(initiatorFIId, notifTitle, notifMsg, null);
                        }
                        // Confirmation email
                        const ejs = require('ejs');
                        const fs = require('fs');
                        const path = require('path');
                        const nodemailer = require('nodemailer');
                        const transporter = require('./emailController').transporter || require('nodemailer').createTransport({ service: "gmail", auth: { user: "braydonxly@gmail.com", pass: "cpdb ldum vnmh llpn" }, tls: { rejectUnauthorized: false } });
                        const confTemplate = fs.readFileSync(path.join(__dirname, '../views/confirmationEmail.ejs'), 'utf-8');
                        const confHtml = ejs.render(confTemplate, { fiName: responderName, clientName, responseType: 'BLOCKED' });
                        // Always send confirmation to the responder FI
                        if (responderEmail) {
                            transporter.sendMail({ from: 'braydonxly@gmail.com', to: responderEmail, subject: 'Your response has been recorded', html: confHtml });
                        }
                        if (req.session && req.session.user) {
                            req.flash('success', 'Blocked client successfully!');
                            return res.redirect('/home');
                        } else {
                            return res.render('confirmationEmail', { fiName: responderName, clientName, responseType: 'BLOCKED', redirectHome: false });
                        }
                    });
                });
            });
        });
    });
};


// Reject = allow further onboarding, increment reject count, add warning if all FIs reject
exports.rejectStatusChange = (req, res) => {
    const { id, status } = req.params;
    if (req.method !== 'POST') {
        const confirmation = req.query.confirmation === '1';
        db.query('SELECT client_name FROM client WHERE client_id = ?', [id], (err, rows) => {
            const client_name = rows && rows[0] ? rows[0].client_name : '';
            return res.render('rejectReasonForm', { client_id: id, risk_status: status, client_name, confirmation });
        });
    } else {
    // Support sessionless: get FI id from query param if no session
    let fi_id = req.session.user ? req.session.user.FI_id : null;
    if (!fi_id && req.query.fi) {
        fi_id = parseInt(req.query.fi, 10);
    }
    const responderEmail = req.session.user ? req.session.user.institute_email : null;
    const responderName = req.session.user ? req.session.user.institute_name : null;
        const reason = req.body.reason || '';
        const notificationController = require('./notificationController');
        if (!fi_id) {
            return res.status(400).send("Missing FI identifier. Please use the link from your email or log in.");
        }
        db.query("INSERT INTO verification (client_id, response, verified_by, reason) VALUES (?, 'rejected', ?, ?)", [id, fi_id, reason], (err) => {
            if (err) {
                console.error("Error recording rejection:", err);
                return res.status(500).send("Error recording rejection");
            }
            // Count rejects for this client
            db.query("SELECT COUNT(*) AS rejectCount FROM verification WHERE client_id = ? AND response = 'rejected'", [id], (err, countRows) => {
                if (!err) {
                    const rejectCount = countRows[0].rejectCount;
                    // Get total number of FIs
                    db.query("SELECT COUNT(*) AS totalFIs FROM financial_institute", [], (err, fiRows) => {
                        if (!err) {
                            const totalFIs = fiRows[0].totalFIs;
                            if (rejectCount === totalFIs) {
                                // All FIs rejected, add warning flag
                                db.query("UPDATE client SET warning_flag = 1 WHERE client_id = ?", [id]);
                            }
                        }
                    });
                }
            });
            // Notify initiator FI
            db.query("SELECT client_name, FI_id FROM client WHERE client_id = ?", [id], (err, clientRows) => {
                if (err || clientRows.length === 0) {
                    return res.render('rejectReasonForm', { client_id: id, risk_status: status, client_name: '' });
                }
                const clientName = clientRows[0].client_name;
                const initiatorFIId = clientRows[0].FI_id;
                db.query("SELECT institute_email, institute_name FROM financial_institute WHERE FI_id = ?", [initiatorFIId], (err, fiRows) => {
                    const initiatorEmail = fiRows && fiRows[0] ? fiRows[0].institute_email : null;
                    const initiatorName = fiRows && fiRows[0] ? fiRows[0].institute_name : null;
                    if (initiatorFIId && fi_id) {
                        const notifTitle = `Client Allowed for Further Assessment`;
                        const notifMsg = `${responderName} allowed client ${clientName} for further assessment. Reason: ${reason}`;
                        notificationController.addNotification(initiatorFIId, notifTitle, notifMsg, null);
                    }
                    // Confirmation email
                    try {
                        const ejs = require('ejs');
                        const fs = require('fs');
                        const path = require('path');
                        const nodemailer = require('nodemailer');
                        const transporter = require('./emailController').transporter || nodemailer.createTransport({ service: 'gmail', auth: { user: 'braydonxly@gmail.com', pass: 'cpdb ldum vnmh llpn' }, tls: { rejectUnauthorized: false } });
                        const confTemplate = fs.readFileSync(path.join(__dirname, '../views/confirmationEmail.ejs'), 'utf-8');
                        const confHtml = ejs.render(confTemplate, { fiName: responderName, clientName, responseType: 'REJECTED' });
                        // Always send confirmation to the responder FI
                        if (responderEmail) {
                            transporter.sendMail({ from: 'braydonxly@gmail.com', to: responderEmail, subject: 'Your response has been recorded', html: confHtml });
                        }
                    } catch (e) {
                        console.error('Error sending confirmation email:', e);
                    }
                    // Redirect to FI dashboard/home after rejection
                    if (req.session && req.session.user) {
                        req.flash('success', 'Rejection submitted successfully!');
                        return res.redirect('/home');
                    } else {
                        return res.redirect(`/reject/${id}/${status}?confirmation=1`);
                    }
                });
            });
        });
    }
};
exports.viewClientById = (req, res) => {
    const clientId = req.params.id;
    const sql = "SELECT * FROM client WHERE client_id = ?";
    db.query(sql, [clientId], async (err, results) => {
        if (err) {
            console.error("Error fetching client:", err);
            return res.status(500).send("Error fetching client data");
        }
        if (results.length === 0) {
            return res.render("clientDetails", { client: null, rejectionReasons: [], transactions: [], blockchainTransactions: [] });
        }
        const client = results[0];
        // Fetch rejection reasons from verification table
        db.query("SELECT fi.institute_name, v.reason FROM verification v JOIN financial_institute fi ON v.verified_by = fi.FI_id WHERE v.client_id = ? AND v.response = 'rejected'", [clientId], async (err, reasons) => {
            if (err) {
                console.error("Error fetching rejection reasons:", err);
                return res.render("clientDetails", { client, rejectionReasons: [], transactions: [], blockchainTransactions: [] });
            }
            // Fetch transaction/AML data
            if (client.on_blockchain) {
                // Blockchain client: fetch transactions from blockchain
                let blockchainTransactions = [];
                try {
                    if (contract && contract.methods && contract.methods.getTransactions) {
                        blockchainTransactions = await contract.methods.getTransactions(client.client_id).call();
                    }
                } catch (e) {
                    console.error('Error fetching blockchain transactions:', e);
                }
                return res.render("clientDetails", { client, rejectionReasons: reasons, transactions: [], blockchainTransactions });
            } else {
                // Database client: fetch transactions from DB
                db.query("SELECT * FROM transaction WHERE client_id = ? ORDER BY created_at DESC", [clientId], (err, txRows) => {
                    if (err) {
                        console.error("Error fetching transactions:", err);
                        return res.render("clientDetails", { client, rejectionReasons: reasons, transactions: [], blockchainTransactions: [] });
                    }
                    return res.render("clientDetails", { client, rejectionReasons: reasons, transactions: txRows, blockchainTransactions: [] });
                });
            }
        });
    });
};
// View full client details
exports.viewClientFullDetails = (req, res) => {
    const clientId = req.params.id;
    db.query("SELECT * FROM client WHERE client_id = ?", [clientId], (err, clientResults) => {
        if (err || clientResults.length === 0) {
            console.error("Error fetching client info:", err);
            return res.status(500).send("Error fetching client info");
        }
        const client = clientResults[0];
        db.query("SELECT * FROM transaction WHERE client_id = ? ORDER BY risk_score ASC", [clientId], (err, txnResults) => {
            if (err) {
                console.error("Error fetching transactions:", err);
                return res.status(500).send("Error fetching transactions");
            }
            res.render("6_invClient", { client, transactions: txnResults || [] });
        });
    });
};

// Show add client form (single page)
exports.showAddClientForm = (req, res) => {
    // ...existing code...
    res.render('8_1_addClient', {
        // ...existing code...
    });
};

// Handle adding a client with scoring
exports.addClient = (req, res) => {
    const {
        client_name, client_NRIC, client_nationality, customer_type, client_citizenship,
        client_address, client_postalcode, client_gender, client_cob, client_dob,
        client_home_number, client_phone_number, client_occupation, pep_status, source_of_funds,
        client_employer_name, client_employer_number
    } = req.body;

    let image = req.file ? req.file.filename : null;
    const FI_id = req.session.user ? req.session.user.FI_id : null;
    const cob = (client_cob || '').toLowerCase();
    const nationality = (client_nationality || '').toLowerCase();
    let geography_score = (cob === 'iran' || cob === 'nigeria' || nationality === 'iran' || nationality === 'nigeria') ? 20 : 0;
    let customer_type_score = (customer_type === 'Offshore company' || customer_type === 'Trust') ? 20 : 0;
    let occupation_score = (client_occupation && client_occupation.toLowerCase().includes('politician')) ? 20 : 0;
    let pep_score = (pep_status === 'Foreign PEP' || pep_status === 'Domestic PEP') ? 25 : 0;
    let source_of_funds_score = (source_of_funds === 'Cryptocurrency Proceeds') ? 20 : 0;
    let transaction_behavior_score = 15;
    let previous_sar_score = 15;
    let total_risk_score = geography_score + customer_type_score + occupation_score + pep_score + source_of_funds_score + transaction_behavior_score + previous_sar_score;
    let risk_status = 'N/A';
    // Only set to 'Low' if both risk and transaction are low risk
    let tempRiskStatus = total_risk_score < 40 ? 'Low' : 'N/A';

    // Check for duplicate/blacklisted NRIC
    db.query('SELECT * FROM client WHERE client_NRIC = ?', [client_NRIC], async (err, existingClients) => {
        if (err) {
            console.error('Error checking for duplicate NRIC:', err);
            return res.status(500).send('Error checking for duplicate NRIC');
        }
        let is_duplicate = 0;
        let aml_flag_reason = null;
        let sendAmlEmail = false;
        let blacklistedClient = null;
        if (existingClients && existingClients.length > 0) {
            // Check for high or medium risk
            const highRiskClient = existingClients.find(c => c.risk_status === 'High');
            const mediumRiskClient = existingClients.find(c => c.risk_status === 'Medium');
            if (highRiskClient) {
                is_duplicate = 1;
                aml_flag_reason = 'Identity misuse or money laundering risk: Duplicate NRIC with high-risk client';
                sendAmlEmail = true;
                // Notification: Duplicate NRIC with high risk
                const notificationController = require('./notificationController');
                notificationController.addNotification(FI_id, 'Duplicate High-Risk Client', `Duplicate NRIC with high-risk client detected for ${client_name}.`, null);
            } else if (mediumRiskClient) {
                is_duplicate = 1;
                aml_flag_reason = 'Potential identity misuse: Duplicate NRIC with medium-risk client';
                sendAmlEmail = true;
                // Notification: Duplicate NRIC with medium risk
                const notificationController = require('./notificationController');
                notificationController.addNotification(FI_id, 'Duplicate Medium-Risk Client', `Duplicate NRIC with medium-risk client detected for ${client_name}.`, null);
            } else {
                is_duplicate = 1;
                aml_flag_reason = 'Duplicate NRIC detected';
                // Notification: Duplicate NRIC (general)
                const notificationController = require('./notificationController');
                notificationController.addNotification(FI_id, 'Duplicate Client', `Duplicate NRIC detected for ${client_name}.`, null);
            }
        }

        const sql = `
            INSERT INTO client (
                client_name, client_NRIC, client_nationality, customer_type, client_citizenship,
                client_address, client_postalcode, client_gender, client_cob, client_dob,
                client_home_number, client_phone_number, client_occupation, pep_status, source_of_funds,
                client_employer_name, client_employer_number, image,
                geography_score, customer_type_score, occupation_score, pep_score, source_of_funds_score,
                transaction_behavior_score, previous_sar_score, total_risk_score, risk_status, FI_id,
                is_duplicate, aml_flag_reason
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const values = [
            client_name, client_NRIC, client_nationality, customer_type, client_citizenship,
            client_address, client_postalcode, client_gender, client_cob, client_dob,
            client_home_number, client_phone_number, client_occupation, pep_status, source_of_funds,
            client_employer_name, client_employer_number, image,
            geography_score, customer_type_score, occupation_score, pep_score, source_of_funds_score,
            transaction_behavior_score, previous_sar_score, total_risk_score, risk_status, FI_id,
            is_duplicate, aml_flag_reason
        ];
        db.query(sql, values, async (err, result) => {
            if (err) {
                console.error('Error adding client:', err);
                return res.status(500).send('Error adding client');
            }
            // Get the new client_id
            const clientId = result.insertId;
            // Insert a random transaction for the new client
            const transactionTypes = ['credit_cash','credit_wire','credit_crypto','credit_cheque','credit_card','debit_cash','debit_wire','debit_crypto','debit_cheque','debit_card'];
            const randomType = transactionTypes[Math.floor(Math.random() * transactionTypes.length)];
            const randomAmount = (Math.random() * 20000 + 100).toFixed(2); // 100 - 20100
            const randomStatus = ['pending','approved','rejected'][Math.floor(Math.random() * 3)];
            const randomCountry = client_nationality || client_cob || 'Singapore';
            const randomRiskScore = Math.floor(Math.random() * 100);
            // Determine AML reason for transaction
            let txnAmlReason = null;
            if (randomRiskScore >= 80) {
                txnAmlReason = 'High risk transaction pattern detected';
            }
            if (randomStatus === 'rejected') {
                txnAmlReason = txnAmlReason ? (txnAmlReason + '; Rejected: unusual or suspicious activity') : 'Rejected: unusual or suspicious activity';
            }
            if (is_duplicate && aml_flag_reason) {
                txnAmlReason = txnAmlReason ? (txnAmlReason + '; ' + aml_flag_reason) : aml_flag_reason;
            }
            // Insert transaction with AML reason
            const transactionSql = `INSERT INTO transaction (client_id, amount, transaction_type, transaction_status, country, risk_score, red_flags) VALUES (?, ?, ?, ?, ?, ?, ?)`;
            db.query(transactionSql, [clientId, randomAmount, randomType, randomStatus, randomCountry, randomRiskScore, txnAmlReason], async (txnErr) => {
                // If client is low risk but transaction is flagged as AML, set to N/A for assessment
                if (tempRiskStatus === 'Low' && randomRiskScore < 80) {
                    risk_status = 'Low';
                } else {
                    risk_status = 'N/A';
                }
                // Update client risk_status after transaction insert
                db.query('UPDATE client SET risk_status = ? WHERE client_id = ?', [risk_status, clientId]);
                if (txnErr) {
                    console.error('Error adding random transaction for new client:', txnErr);
                }
                // Notification: High-risk client added
                if (risk_status === 'High') {
                    const notificationController = require('./notificationController');
                    notificationController.addNotification(FI_id, 'High-Risk Client Added', `A new high-risk client (${client_name}) was added.`, null);
                }
                // Notification: PEP detected
                if (pep_status === 'Foreign PEP' || pep_status === 'Domestic PEP') {
                    const notificationController = require('./notificationController');
                    notificationController.addNotification(FI_id, 'PEP Detected', `A client marked as PEP (${client_name}) was added.`, null);
                }
                // Send AML alert email if needed
                if (sendAmlEmail) {
                    db.query('SELECT institute_email, institute_name FROM financial_institute WHERE FI_id = ?', [FI_id], async (err, fiRows) => {
                        if (!err && fiRows && fiRows[0]) {
                            const mailOptions = {
                                from: 'braydonxly@gmail.com',
                                to: fiRows[0].institute_email,
                                subject: 'CRITICAL AML ALERT: Duplicate/Blacklisted NRIC Detected',
                                html: `<p>A client with NRIC <b>${client_NRIC}</b> matches a blacklisted client in the system.<br>This is a critical AML red flag (possible identity misuse or money laundering). Immediate review required.</p>`
                            };
                            const nodemailer = require('nodemailer');
                            const transporter = require('./emailController').transporter || nodemailer.createTransport({ service: 'gmail', auth: { user: 'braydonxly@gmail.com', pass: 'cpdb ldum vnmh llpn' }, tls: { rejectUnauthorized: false } });
                            await transporter.sendMail(mailOptions);
                            // Add notification for the FI
                            const notificationController = require('./notificationController');
                            const notifTitle = 'CRITICAL AML ALERT';
                            const notifMsg = `A client with NRIC ${client_NRIC} matches a blacklisted client in the system. Immediate review required.`;
                            notificationController.addNotification(FI_id, notifTitle, notifMsg, null);
                        }
                    });
                }

                // --- AUTOMATIC EMAIL LOGIC ---
                // Determine if email should be sent for risk assessment
                // 1. Medium/High risk based on form
                // 2. Low risk but transaction is flagged as AML (risk score >= 80)
                let shouldSendEmail = false;
                let reason = '';
                if (risk_status === 'High' || risk_status === 'Medium') {
                    shouldSendEmail = true;
                    reason = 'Medium/High risk based on form details';
                } else if (risk_status === 'Low' && randomRiskScore >= 80) {
                    shouldSendEmail = true;
                    reason = 'Low risk by form, but transaction flagged as AML';
                }
                if (shouldSendEmail) {
                    // Mimic a request object for emailController.sendEmail
                    const reqForEmail = {
                        params: { id: clientId },
                        session: { user: { FI_id: FI_id, institute_name: req.session.user.institute_name, institute_email: req.session.user.institute_email } }
                    };
                    const resForEmail = {
                        redirect: () => {},
                        status: () => ({ send: () => {} }),
                        send: () => {},
                        json: () => {}
                    };
                    await require('./emailController').sendEmail(reqForEmail, resForEmail);
                    console.log(`Risk assessment email sent for client ${client_name} (${clientId}): ${reason}`);
                }

                // Optionally, show a warning in the UI (flash message or query param)
                res.redirect('/all-clients?amlFlag=' + (sendAmlEmail ? '1' : '0'));
            });
        });
    });
};

// Edit existing client, recalculate scores
exports.updateClient = (req, res) => {
    const clientId = req.params.id;
    const {
        client_name, client_NRIC, client_nationality, customer_type, client_citizenship,
        client_address, client_postalcode, client_gender, client_cob, client_dob,
        client_home_number, client_phone_number, client_occupation, pep_status, source_of_funds,
        client_employer_name, client_employer_number
    } = req.body;

    let image = req.file ? req.file.filename : req.body.existing_image;

    let geography_score = (client_cob === 'Iran' || client_cob === 'Nigeria') ? 20 : 0;
    let customer_type_score = (customer_type === 'Offshore company' || customer_type === 'Trust') ? 20 : 0;
    let occupation_score = (client_occupation.toLowerCase().includes('politician')) ? 20 : 0;
    let pep_score = (pep_status === 'Foreign PEP' || pep_status === 'Domestic PEP') ? 25 : 0;
    let source_of_funds_score = (source_of_funds === 'Cryptocurrency Proceeds') ? 20 : 0;
    let transaction_behavior_score = 15;
    let previous_sar_score = 15;

    let total_risk_score = geography_score + customer_type_score + occupation_score + pep_score +
                           source_of_funds_score + transaction_behavior_score + previous_sar_score;

    // Set risk_status to 'N/A' for all edits except when risk is low
    let risk_status = 'N/A';
    // Only set to 'Low' if both risk and transaction are low risk
    let tempRiskStatus = total_risk_score < 40 ? 'Low' : 'N/A';

    const sql = `
        UPDATE client SET
            client_name=?, client_NRIC=?, client_nationality=?, customer_type=?, client_citizenship=?,
            client_address=?, client_postalcode=?, client_gender=?, client_cob=?, client_dob=?,
            client_home_number=?, client_phone_number=?, client_occupation=?, pep_status=?, source_of_funds=?,
            client_employer_name=?, client_employer_number=?, image=?,
            geography_score=?, customer_type_score=?, occupation_score=?, pep_score=?, source_of_funds_score=?,
            transaction_behavior_score=?, previous_sar_score=?, total_risk_score=?, risk_status=?
        WHERE client_id=?
    `;

    const values = [
        client_name, client_NRIC, client_nationality, customer_type, client_citizenship,
        client_address, client_postalcode, client_gender, client_cob, client_dob,
        client_home_number, client_phone_number, client_occupation, pep_status, source_of_funds,
        client_employer_name, client_employer_number, image,
        geography_score, customer_type_score, occupation_score, pep_score, source_of_funds_score,
        transaction_behavior_score, previous_sar_score, total_risk_score, risk_status,
        clientId
    ];

    db.query(sql, values, async (err) => {
        if (err) {
            console.error("Error updating client:", err);
            return res.status(500).send("Error updating client");
        }
        // Assign a new random transaction after edit
        const transactionTypes = ['credit_cash','credit_wire','credit_crypto','credit_cheque','credit_card','debit_cash','debit_wire','debit_crypto','debit_cheque','debit_card'];
        const randomType = transactionTypes[Math.floor(Math.random() * transactionTypes.length)];
        const randomAmount = (Math.random() * 20000 + 100).toFixed(2);
        const randomStatus = ['pending','approved','rejected'][Math.floor(Math.random() * 3)];
        const randomCountry = client_nationality || client_cob || 'Singapore';
        const randomRiskScore = Math.floor(Math.random() * 100);
        const transactionSql = `INSERT INTO transaction (client_id, amount, transaction_type, transaction_status, country, risk_score) VALUES (?, ?, ?, ?, ?, ?)`;
        db.query(transactionSql, [clientId, randomAmount, randomType, randomStatus, randomCountry, randomRiskScore], async (txnErr) => {
            // If client is low risk but transaction is flagged as AML, set to N/A for assessment
            if (tempRiskStatus === 'Low' && randomRiskScore < 80) {
                risk_status = 'Low';
            } else {
                risk_status = 'N/A';
            }
            // Update client risk_status after transaction insert
            db.query('UPDATE client SET risk_status = ? WHERE client_id = ?', [risk_status, clientId]);
            if (txnErr) {
                console.error('Error adding random transaction for edited client:', txnErr);
            }
            // Fetch FI_id for this client for notifications
            db.query('SELECT FI_id FROM client WHERE client_id = ?', [clientId], async (fiErr, fiRows) => {
                const fi_id = (fiRows && fiRows[0]) ? fiRows[0].FI_id : null;
                const notificationController = require('./notificationController');
                if (fi_id) {
                    notificationController.addNotification(fi_id, 'Client Updated', `Client (${client_name}) information was updated.`, null);
                    if (req.body.aml_flag_reason) {
                        notificationController.addNotification(fi_id, 'AML/Compliance Flag Updated', `AML/Compliance flag reason updated for client (${client_name}).`, null);
                    }
                }
                // Only send assessment email if risk_status is 'N/A' (i.e., not low)
                if (risk_status === 'N/A') {
                    // Mimic a request object for emailController.sendEmail
                    const reqForEmail = {
                        params: { id: clientId },
                        session: { user: { FI_id: req.session.user.FI_id, institute_name: req.session.user.institute_name, institute_email: req.session.user.institute_email } }
                    };
                    const resForEmail = {
                        redirect: () => {},
                        status: () => ({ send: () => {} }),
                        send: () => {},
                        json: () => {}
                    };
                    await require('./emailController').sendEmail(reqForEmail, resForEmail);
                    console.log(`Risk assessment email sent for client ${client_name} (${clientId}): N/A status, assessment required.`);
                }
                res.redirect('/all-clients');
            });
        });
    });
};

exports.deleteClient = (req, res) => {
    const id = req.params.id;
    db.query("DELETE FROM client WHERE client_id = ?", [id], (err) => {
        if (err) {
            console.error("Error deleting client:", err);
            return res.status(500).send("Error deleting client");
        }
        res.redirect('/all-clients');
    });
};
