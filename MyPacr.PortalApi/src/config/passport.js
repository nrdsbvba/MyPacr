const JwtStrategy = require('passport-jwt').Strategy
const ExtractJwt = require('passport-jwt').ExtractJwt

const SmartschoolStrategy = require('@diekeure/passport-smartschool').Strategy
const config = require('config')
const userService = require('../service/userService')

module.exports = function(passport) {
  var opts = {}
  opts.jwtFromRequest = ExtractJwt.fromAuthHeaderWithScheme('jwt')
  opts.secretOrKey = config.get("passport").tokenSecret
  passport.use(
    new JwtStrategy(opts, (jwt_payload, done) => {
      userService
        .getCoAccountById(jwt_payload._doc._id)
        .then(user => {
          if (user) {
            return done(null, user)
          } else {
            return done(null, false)
          }
        })
        .catch(err => {
          return done(err, false)
        })
    })
  )

  passport.use(
    new SmartschoolStrategy(
      {
        clientID: config.get("smartschoolAuthentication").clientID,
        clientSecret: config.get("smartschoolAuthentication").clientSecret,
      },
      function(accesstoken, refreshtoken, profile, cb) {
        return cb(null, profile)
      }
    )
  )
}
