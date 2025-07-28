const db = require('../db');

// Fetch notifications for the currently logged-in FI
exports.getNotifications = (req, res, next) => {
  if (!req.session || !req.session.user) {
    res.locals.notifications = [];
    return next();
  }
  if (!req.session || !req.session.user) {
    res.locals.notifications = [];
    return next();
  }
  let query = '';
  let param = null;
  if (req.session.user.role === 'admin') {
    query = `SELECT id, title, message, link, is_read, created_at FROM notifications WHERE admin_id = ? AND fi_id IS NULL ORDER BY created_at DESC LIMIT 50`;
    param = req.session.user.user_id;
  } else if (req.session.user.FI_id) {
    query = `SELECT id, title, message, link, is_read, created_at FROM notifications WHERE fi_id = ? AND admin_id IS NULL ORDER BY created_at DESC LIMIT 50`;
    param = req.session.user.FI_id;
  } else {
    res.locals.notifications = [];
    return next();
  }
  db.query(query, [param], (err, rows) => {
    if (err) {
      console.error('Error fetching notifications:', err);
      res.locals.notifications = [];
      return next();
    }
    res.locals.notifications = rows.map(row => ({
      title: row.title,
      message: row.message,
      link: row.link,
      is_read: row.is_read,
      time: row.created_at ? new Date(row.created_at).toLocaleString() : ''
    }));
    next();
  });
};

// Add a notification for a specific FI or all admins
exports.addNotification = (fi_id, title, message, link = null) => {
  if (fi_id === null) {
    // Notify all admins
    db.query(`SELECT user_id FROM user WHERE role = 'admin'`, (err, results) => {
      if (err) {
        console.error('Error fetching admins for notification:', err);
        return;
      }
      results.forEach(admin => {
        db.query(
          `INSERT INTO notifications (admin_id, fi_id, title, message, link, created_at) VALUES (?, NULL, ?, ?, ?, NOW())`,
          [admin.user_id, title, message, link],
          (err2) => {
            if (err2) console.error('Error adding notification for admin:', err2);
          }
        );
      });
    });
  } else {
    db.query(
      `INSERT INTO notifications (fi_id, admin_id, title, message, link, created_at) VALUES (?, NULL, ?, ?, ?, NOW())`,
      [fi_id, title, message, link],
      (err) => {
        if (err) console.error('Error adding notification:', err);
      }
    );
  }
};
