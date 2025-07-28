
const express = require('express');
const mysql = require('mysql2');
const multer = require('multer');
const flash = require('connect-flash');
const session = require('express-session');
const app = express();

// Route for more details page
app.get('/moreDetails', (req, res) => {
    res.render('moreDetails');
});

const userController = require('./controllers/userController');
const FIcontroller = require('./controllers/FIcontroller');
const clientController = require('./controllers/clientController');
const emailController = require('./controllers/emailController');
const notificationController = require('./controllers/notificationController');

require('dotenv').config();
// Import middleware
const { checkAuthenticated, checkAdmin, checkUser } = require('./middleware/auth');
const { validateRegistration, validateLogin } = require('./middleware/validation');

// Set up multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/images'); // Directory to save uploaded files
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    }
});

const upload = multer({ storage: storage });

// Set up view engine
app.set('view engine', 'ejs');
//  enable static files
app.use(express.static('public'));

// enable form processing
app.use(express.urlencoded({
    extended: false
}));

//Code for Session Middleware  
app.use(session({
    secret: 'secret',
    resave: false,
    saveUninitialized: true,
    // Session expires after 1 week of inactivity
    cookie: { maxAge: 1000 * 60 * 60 * 24 * 7 }
}));

//This middleware assigns the current session object (req.session) to res.locals.session, making session data accessible within your view templates. 
app.use((req, res, next) => {
    res.locals.session = req.session;
    next();
});

// Use connect-flash middleware
app.use(flash()); // Use flash middleware after session middleware

// Notification middleware: fetch notifications for signed-in FI
app.use(notificationController.getNotifications);

// Reports dashboard route (must be after app is defined)
app.get('/reports', checkAuthenticated, checkUser, clientController.viewReportDashboard);

// Define routes here
app.get('/', (req, res) => {
    let loggedIn = false;
    if (req.session.user) {
        loggedIn = true;
    }
    res.render('1_index', { loggedIn });
});
app.get('/home', (req, res) => {
    res.render('4_home', { session: req.session });
});

app.get('/login', userController.renderLoginForm);
app.post('/login', validateLogin, userController.login);

// Reports dashboard route
app.get('/reports', checkAuthenticated, checkUser, clientController.viewReportDashboard);
app.get('/logout', checkAuthenticated, userController.logout);

// FI Registration (Admin account is pre-set, no signup)
app.get('/register', userController.renderRegisterForm);
app.post('/register', upload.none(), validateRegistration, userController.register);

// Admin-only routes
app.get('/institutions', checkAuthenticated, FIcontroller.getAllFIs);
app.get('/institution/:id', checkAuthenticated, FIcontroller.getFIById);
app.get('/editFI/:id', checkAuthenticated, checkAdmin, FIcontroller.editFIForm);
app.post('/editFI/:id', checkAuthenticated, checkAdmin, FIcontroller.editFI);
app.post('/deleteFI/:id', checkAuthenticated, checkAdmin, FIcontroller.deleteFI);



// FI-only routes (clients)
app.get('/all-clients', checkAuthenticated, checkUser, clientController.allClients);
app.get('/client/:id', checkAuthenticated, checkUser, clientController.viewClientById);

app.get('/addclient1', checkAuthenticated, checkUser, clientController.showAddClientForm);
app.post('/addclient', checkAuthenticated, checkUser, upload.single('image'), clientController.addClient);


// Render edit client form
app.get('/editclient/:id', checkAuthenticated, checkUser, clientController.editClientForm);
app.post('/editclient/:id', checkAuthenticated, checkUser, upload.single('image'), clientController.updateClient);


app.post('/deleteclient/:id', checkAuthenticated, checkUser, clientController.deleteClient);

app.get('/email/:id', checkAuthenticated, checkUser, emailController.sendEmail);
app.get('/send-email/:id', checkAuthenticated, checkUser, emailController.sendEmail);
// Accept/Reject from email: allow sessionless, FI id via query param
app.get('/accept/:id/:status', clientController.acceptStatusChange);
app.route('/reject/:id/:status')
  .get(clientController.rejectStatusChange)
  .post(clientController.rejectStatusChange);

app.get('/register-admin', checkAuthenticated, checkAdmin, userController.renderRegisterAdminForm);
app.post('/register-admin', checkAuthenticated, checkAdmin, upload.single('profile'), userController.registerAdmin);


app.get('/view-admins', checkAuthenticated, userController.viewAdmins);


app.post('/editadmin/:id', checkAuthenticated, userController.editAdmin);
app.get('/adminaccount', checkAuthenticated, userController.getAdminAccount);
app.get('/myaccount', checkAuthenticated, checkUser, FIcontroller.getMyAccount);



// Notifications page
app.get('/notifications', checkAuthenticated, async (req, res) => {
    let query = '';
    let param = null;
    let markReadQuery = '';
    if (req.session.user.role === 'admin') {
        query = 'SELECT id, title, message, link, is_read, created_at FROM notifications WHERE admin_id = ? AND fi_id IS NULL ORDER BY created_at DESC';
        param = req.session.user.user_id;
        markReadQuery = 'UPDATE notifications SET is_read = 1 WHERE admin_id = ? AND fi_id IS NULL AND is_read = 0';
    } else if (req.session.user.FI_id) {
        query = 'SELECT id, title, message, link, is_read, created_at FROM notifications WHERE fi_id = ? AND admin_id IS NULL ORDER BY created_at DESC';
        param = req.session.user.FI_id;
        markReadQuery = 'UPDATE notifications SET is_read = 1 WHERE fi_id = ? AND admin_id IS NULL AND is_read = 0';
    } else {
        return res.redirect('/login');
    }
    const db = require('./db');
    db.query(query, [param], (err, rows) => {
        if (err) {
            console.error('Error fetching notifications:', err);
            return res.render('notifications', { notifications: [] });
        }
        db.query(markReadQuery, [param], () => {
            const notifications = rows.map(row => ({
                title: row.title,
                message: row.message,
                link: row.link,
                is_read: row.is_read,
                time: row.created_at ? new Date(row.created_at).toLocaleString() : ''
            }));
            res.render('notifications', { notifications });
        });
    });
});

app.get('/contactUs', (req, res) => res.render('contactUs'));
app.get('/about', (req, res) => res.render('about'));
app.get('/401', (req, res) => res.render('401', { errors: req.flash('error') }));


//Start express server and bind it to a port
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
