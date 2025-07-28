const nodemailer = require("nodemailer");
const ejs = require("ejs");
const fs = require("fs");
const path = require("path");
const db = require('../db');

// Configure Nodemailer transporter
// Use the below links to setup Nodemailer for Gmail (in order):
// 1) Create Gmail app password: https://myaccount.google.com/apppasswords
// 2) Nodemailer configuration code: https://nodemailer.com/usage/using-gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "braydonxly@gmail.com",
    pass: "cpdb ldum vnmh llpn",
  },
  tls: {
    rejectUnauthorized: false
  }
});

// Function to send email
const sendEmail = async (req, res) => {
  try {
    // Retrieve client and sender FI data
    const client_id = req.params.id;
    const senderFI = req.session.user;
    if (!senderFI) {
      return res.status(401).send("Not logged in");
    }
    // Get client details with all risk scores
    const clientSql = `SELECT client_id, client_name, risk_status, total_risk_score, geography_score, customer_type_score, occupation_score, pep_score, source_of_funds_score, transaction_behavior_score, previous_sar_score, client_cob, client_nationality, customer_type, client_occupation, pep_status, source_of_funds FROM client WHERE client_id = ?`;
    db.query(clientSql, [client_id], async (err, clientResults) => {
      if (err || clientResults.length === 0) {
        console.error("Error fetching client:", err);
        return res.status(500).send("Error fetching client");
      }
      const client = clientResults[0];
      if (client.risk_status !== 'N/A') {
        return res.status(400).send("Client already has a risk status");
      }
      // Calculate risk status to display (Medium/High) based on scoring
      let displayRisk = 'Medium';
      if (client.total_risk_score >= 80) displayRisk = 'High';
      else displayRisk = 'Medium';

      // Prepare risk reasons breakdown and include actual client details
      let riskReasons = [];
      if (client.geography_score >= 20) {
        let geoDetail = client.client_cob ? `Country of Birth: ${client.client_cob}` : (client.client_nationality ? `Nationality: ${client.client_nationality}` : 'Unknown');
        riskReasons.push(`Geography: ${geoDetail}, high risk country (Score: ${client.geography_score})`);
      }
      if (client.customer_type_score >= 20) {
        let custType = client.customer_type || 'Unknown';
        riskReasons.push(`Customer Type: ${custType} (Score: ${client.customer_type_score})`);
      }
      if (client.occupation_score >= 20) {
        let occ = client.client_occupation || 'Unknown';
        riskReasons.push(`Occupation: ${occ} (Score: ${client.occupation_score})`);
      }
      if (client.pep_score >= 25) {
        let pep = client.pep_status || 'Unknown';
        riskReasons.push(`PEP Status: ${pep} (Score: ${client.pep_score})`);
      }
      if (client.source_of_funds_score >= 20) {
        let sof = client.source_of_funds || 'Unknown';
        riskReasons.push(`Source of Funds: ${sof} (Score: ${client.source_of_funds_score})`);
      }

      // Helper to promisify db.query
      const dbQuery = (sql, params) => new Promise((resolve, reject) => {
        db.query(sql, params, (err, results) => {
          if (err) reject(err);
          else resolve(results);
        });
      });

      // Fetch all transactions for this client
      let transactions = await dbQuery('SELECT * FROM transaction WHERE client_id = ?', [client_id]);
      transactions = transactions || [];
      // If duplicate NRIC, also fetch previous clients' transactions
      let allTransactions = [...transactions];
      if (client.is_duplicate) {
        // Find all other clients with the same NRIC (excluding this one)
        const prevClients = await dbQuery('SELECT client_id FROM client WHERE client_NRIC = (SELECT client_NRIC FROM client WHERE client_id = ?) AND client_id != ?', [client_id, client_id]);
        for (const prev of prevClients) {
          const prevTxns = await dbQuery('SELECT * FROM transaction WHERE client_id = ?', [prev.client_id]);
          if (prevTxns && prevTxns.length > 0) {
            allTransactions.push(...prevTxns);
          }
        }
      }
      // Add transaction AML reasons dynamically
      let hasFlaggedTxn = false;
      allTransactions.forEach(txn => {
        if ((txn.risk_score && txn.risk_score >= 80) || (txn.red_flags && txn.red_flags && txn.red_flags.trim() !== '')) {
          hasFlaggedTxn = true;
          if (txn.red_flags && txn.red_flags.trim() !== '') {
            riskReasons.push(`Transaction AML Flag: ${txn.red_flags} (Score: ${txn.risk_score})`);
          } else {
            riskReasons.push(`Transaction AML Flag: High risk score (${txn.risk_score})`);
          }
        }
      });
      // Only show Transaction Behavior if there is a flagged transaction
      if (hasFlaggedTxn) {
        riskReasons.push('Transaction Behavior: Unusual or suspicious pattern (Flagged transaction present)');
      }
      // Only show Previous SAR if client is duplicate NRIC
      if (client.is_duplicate) {
        riskReasons.push('Previous SAR: Prior suspicious activity reported (Duplicate NRIC)');
      }

      // Build a fully dynamic risk score breakdown (client and transaction)
      let riskScoreBreakdown = [];
      // Client-level scores
      if (client.total_risk_score !== undefined && client.total_risk_score !== null)
        riskScoreBreakdown.push({ label: 'Total Risk Score', value: client.total_risk_score });
      if (client.geography_score !== undefined && client.geography_score !== null)
        riskScoreBreakdown.push({ label: 'Geography Score', value: client.geography_score });
      if (client.customer_type_score !== undefined && client.customer_type_score !== null)
        riskScoreBreakdown.push({ label: 'Customer Type Score', value: client.customer_type_score });
      if (client.occupation_score !== undefined && client.occupation_score !== null)
        riskScoreBreakdown.push({ label: 'Occupation Score', value: client.occupation_score });
      if (client.pep_score !== undefined && client.pep_score !== null)
        riskScoreBreakdown.push({ label: 'PEP Score', value: client.pep_score });
      if (client.source_of_funds_score !== undefined && client.source_of_funds_score !== null)
        riskScoreBreakdown.push({ label: 'Source of Funds Score', value: client.source_of_funds_score });
      if (client.transaction_behavior_score !== undefined && client.transaction_behavior_score !== null)
        riskScoreBreakdown.push({ label: 'Transaction Behavior Score', value: client.transaction_behavior_score });
      if (client.previous_sar_score !== undefined && client.previous_sar_score !== null && client.is_duplicate)
        riskScoreBreakdown.push({ label: 'Previous SAR Score', value: client.previous_sar_score });
      // Transaction-level scores
      if (allTransactions && allTransactions.length > 0) {
        allTransactions.forEach((txn, idx) => {
          if (txn.risk_score !== undefined && txn.risk_score !== null) {
            riskScoreBreakdown.push({ label: `Transaction #${idx+1} Risk Score`, value: txn.risk_score });
          }
        });
      }

      // Get all other FIs except sender
      const fiSql = "SELECT FI_id, institute_name, institute_email FROM financial_institute WHERE FI_id != ?";
      let fiResults = await dbQuery(fiSql, [senderFI.FI_id]);
      if (!fiResults || fiResults.length === 0) {
        console.error("Error fetching FIs: none found");
        return res.status(500).send("Error fetching FIs");
      }
      // Ensure AML reason is set for rejected transactions, but only for the current client's transaction
      let transactionsForEmail = (allTransactions || []).map(txn => {
        // Only update AML reason for the current client's transaction
        if (txn.client_id === client.client_id) {
          let amlReason = txn.red_flags;
          if ((!amlReason || amlReason.trim() === '-') && txn.transaction_status && txn.transaction_status.toLowerCase() === 'rejected') {
            amlReason = 'Rejected transaction: AML concern or policy violation';
          }
          return { ...txn, red_flags: amlReason };
        } else {
          // For previous clients' transactions, preserve original AML reason
          return txn;
        }
      });

      // Prepare email details
      const emailTemplatePath = path.join(__dirname, "../views/emailTemplate.ejs");
      const emailTemplate = fs.readFileSync(emailTemplatePath, "utf-8");
      const notificationController = require('./notificationController');
      for (const fi of fiResults) {
        // Prepare email details for each FI
        let details = {
          client_id: client.client_id,
          client_name: client.client_name,
          risk_status: displayRisk,
          institute_name: senderFI.institute_name,
          riskReasons: riskReasons,
          riskScoreBreakdown: riskScoreBreakdown,
          transactions: transactionsForEmail,
          fi_id: fi.FI_id // for each recipient FI, used in template links
        };
        const htmlContent = ejs.render(emailTemplate, { details });
        const mailOptions = {
          from: senderFI.institute_email,
          to: fi.institute_email,
          subject: "Accept or Reject Client's Risk Status",
          html: htmlContent,
        };
        await transporter.sendMail(mailOptions);
        // Notify FI of new email/request
        const notifTitle = `Risk Assessment Request`;
        const notifMsg = `${senderFI.institute_name} sent a risk assessment for client ${client.client_name}. Response required.`;
        notificationController.addNotification(fi.FI_id, notifTitle, notifMsg, null);
      }
      res.redirect('/all-clients?emailSuccess=1');
    });
  } catch (error) {
    console.error("Error sending email:", error);
    res.status(500).json({ error: "Failed to send email" });
  }
};

module.exports = { sendEmail };
