// Middleware for form validation
const validateRegistration = (req, res, next) => {
    const { institution, email, contactName, phone, userPassword } = req.body;

    if (!institution || !email || !contactName || !phone || !userPassword) {
        req.flash('error', 'All fields are required.');
        req.flash('formData', req.body);
        return res.redirect('/register');
    }

    // Removed minimum password length validation

    next();
};



const validateLogin = (req, res, next) => {
    const { institute_email, password } = req.body;

    if (!institute_email || !password) {
        req.flash('error', 'All fields are required.');
        return res.redirect('/login');
    }
    next();
};




module.exports = {
    validateRegistration,
    validateLogin,
};