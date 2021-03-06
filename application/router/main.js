const express = require('express');
const router = express.Router();
const mysql = require('mysql2');


var connection = mysql.createConnection({
    host: 'localhost',
    port: 33306,
    user: 'root',
    password: 'battery',
    database: 'battery'
})
connection.connect();

router.get('/', function (req, res) {

    data = {
        userData: req.session.user
    }
    res.render('main.html' , {data : data});
});

router.get('/login', function (req, res) {
    res.render('login.html');
});

router.get('/logout',function(req,res) {
    if (req.session.user) {
        req.session.destroy(err => {
            console.log('failed: ' + err);
            return;
        });
        console.log('success');
        res.status(200).redirect('/');
    } else return;
});

router.get('/register', function (req, res) {
    res.render('register.html');
});

router.post('/register', function (req, res) {
    let body = req.body;
    let phone = body.phone;
    let password = body.password;
    let sql = { phone: phone, password: password };

    var query = connection.query('insert into user set ?', sql, function (err, rows) {
        if (err) { throw err; }
        console.log("ok DB insert");
    });

    res.render('main.html');
});

router.post('/login', function (req, res) {
    let body = req.body;
    let phone = body.phone;
    let password = body.password;
    let s_sql = { phone: phone};
    let p_sql = { password: password};
    let s_phone= connection.query('select * from user where ?', s_sql);
    let s_password= connection.query('select * from user where ?',p_sql);
    
    if (req.body.phone == s_phone.values.phone && req.body.password == s_password.values.password) {

        req.session.user = {
            phone: req.body.phone,
            password: req.body.password
        }
    }

        res.redirect('/');
});




module.exports = router;