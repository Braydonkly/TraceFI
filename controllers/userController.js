const db = require("../db");

// Render register form
exports.renderRegisterForm = (req, res) => {
    res.render('3_register', {users: req.session.user, messages: req.flash('error'), formData: req.flash('formData')[0] });
};

// Handle registration
exports.register = (req, res) => {
    const { employee_id, institution, email, contactName, phone, userPassword } = req.body;

    if (!employee_id || !institution || !email || !contactName || !phone || !userPassword) {
        req.flash('error', 'All fields are required.');
        return res.redirect('/register');
    }

    const sql = `
        INSERT INTO financial_institute 
        (employee_id, institute_name, institute_email, institute_contact_name, institute_phone_number, password, role)
        VALUES (?, ?, ?, ?, ?, SHA1(?), 'user')
    `;

    const values = [employee_id, institution, email, contactName, phone, userPassword];

    db.query(sql, values, (err, result) => {
        if (err) {
            console.error("DB Error:", err);
            return res.status(500).send("Registration failed.");
        }
        // Notification: New FI registered
        const notificationController = require('./notificationController');
        notificationController.addNotification(result.insertId, 'New FI Registered', `A new Financial Institution (${institution}) has been registered.`, null);
        req.session.user = {
            employee_id,
            institute_name: institution,
            institute_email: email,
            institute_contact_name: contactName,
            institute_phone_number: phone,
            role: 'user',
            username: employee_id // fallback for display
        };
        res.render('4_home', { session: req.session, newUser: true });
    });
};


// Render login form
exports.renderLoginForm = (req, res) => {
    console.log('Rendering login form');
    res.render('2_login', {
        users: req.session.user,
        messages: req.flash('success'),
        errors: req.flash('error')
    });
};

exports.login = (req, res) => {
    console.log('Login request received');
    const { employee_id, institute_email, password } = req.body;
    console.log('Login attempt1:', { employee_id, institute_email, password });

    if (!employee_id || !institute_email || !password) {
        req.flash('error', 'All fields are required');
        return res.redirect('/login');
    }
    console.log('Login attempt 2:');
    // First, try to log in as admin from 'user' table
    const adminSql = 'SELECT * FROM user WHERE email = ? AND password = SHA1(?)';
    db.query(adminSql, [institute_email, password], (err, adminResults) => {
        if (err) throw err;

        if (adminResults.length > 0 && adminResults[0].role === 'admin') {
            req.session.user = adminResults[0];
            req.flash('success', 'Admin login successful');
            console.log('Admin login successful:', adminResults[0]);
            return res.redirect('/home');
        }

        // Otherwise, try to log in as a financial institution user
        const fiSql = 'SELECT * FROM financial_institute WHERE employee_id = ? AND institute_email = ? AND password = SHA1(?)';
        db.query(fiSql, [employee_id, institute_email, password], (err, fiResults) => {
            if (err) throw err;

            if (fiResults.length > 0) {
                req.session.user = fiResults[0];
                console.log('Financial institution login successful:', fiResults[0]);
                return res.redirect('/home');
            } else {
                req.flash('error', 'Invalid username, employee ID, or password');
                console.log('Login failed: Invalid credentials');
                return res.redirect('/login');
            }
        });
    });
};
// Render admin registration form
exports.renderRegisterAdminForm = (req, res) => {
    if (!req.session.user || req.session.user.role !== 'admin') {
        req.flash('error', 'Unauthorized access.');
        return res.redirect('/401');
    }

    // Filter ONLY registration-related flash messages
    const successMsgs = req.flash('success');
    const errorMsgs = req.flash('error');

    // Optional: further filter if needed based on req.originalUrl or req.headers.referer

    res.render('register_admin', {
        messages: {
            error: errorMsgs,
            success: successMsgs
        }
    });
};


// Handle admin registration
exports.registerAdmin = (req, res) => {
    if (!req.session.user || req.session.user.role !== 'admin') {
        req.flash('error', 'Unauthorized access.');
        return res.redirect('/401');
    }

    const { username, email, password } = req.body;

    const { employee_id } = req.body;
    const profileImg = req.file ? req.file.filename : 'phpfp.png'; // fallback image

    if (!employee_id || !username || !email || !password) {
        req.flash('error', 'All fields are required.');
        return res.redirect('/register-admin');
    }

    const sql = 'INSERT INTO user (employee_id, username, email, password, role, image) VALUES (?, ?, ?, SHA1(?), ?, ?)';
    const values = [employee_id, username, email, password, 'admin', profileImg];

    db.query(sql, values, (err) => {
        if (err) {
            console.error('Error registering admin:', err);
            req.flash('error', 'Registration failed.');
            return res.redirect('/register-admin');
        }
        // Notification: New admin registered
        const notificationController = require('./notificationController');
        notificationController.addNotification(null, 'New Admin Registered', `A new admin (${username}) has been registered.`, null);
        req.flash('success', 'Admin registered successfully.');
        res.redirect('/register-admin');
    });
};

// Render view-admins page (myAcc)
exports.viewAdmins = (req, res) => {
    const sql = "SELECT username, email, role, image FROM user WHERE role = 'admin'";
    db.query(sql, (err, results) => {
        if (err) {
            console.error("Failed to fetch admins:", err);
            return res.status(500).send("Could not load admin list.");
        }
        res.render("viewAdmins", { admins: results });
    });
};

exports.editAdmin = (req, res) => {
  const adminId = req.params.id;
  const { admin_name, admin_email, admin_phone } = req.body;

  const sql = `UPDATE user SET username = ?, email = ?, phone = ? WHERE id = ?`;
  db.query(sql, [admin_name, admin_email, admin_phone, adminId], (err) => {
    if (err) {
      console.error('Admin update failed:', err);
      return res.status(500).send('Error updating profile');
    }
    req.session.user.username = admin_name;
    req.session.user.email = admin_email;
    req.session.user.phone = admin_phone;
    res.redirect('/adminaccount');
  });
};

exports.getAdminAccount = (req, res) => {
  if (req.session.user.role !== 'admin') {
    return res.status(403).send("Access denied");
  }
  res.render('viewAdmin', { admin: req.session.user });
};




// Logout User
exports.logout = (req, res) => {
    req.session.destroy();
    res.redirect('/');
};