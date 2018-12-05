const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const mongoose = require('mongoose');

const MONGOHost = process.env.MONGO_HOST;
const MONGODatabase = process.env.MONGO_DB;
const MONGOPort = process.env.MONGO_PORT;

const MONGOUser = process.env.MONGO_USER;
const MONGOPassword = process.env.MONGO_PASSWORD;
const MONGOURI = `mongodb://${MONGOHost}:${MONGOPort}/${MONGODatabase}`;

const MongooseOptions = {
  user: MONGOUser,
  pass: MONGOPassword,
}

const db = mongoose.connect(MONGOURI, MongooseOptions);

db.then(function(){
  console.log("ready");
},
function(err){
  console.log(err);
});

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
