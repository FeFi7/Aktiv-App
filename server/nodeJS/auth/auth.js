const passport = require("passport");
const localStrategy = require("passport-local").Strategy;
const userService = require("../services/userService");
const JWTstrategy = require("passport-jwt").Strategy;
const ExtractJWT = require("passport-jwt").ExtractJwt;

const config = require("config");
const jwtConfig = config.get("Customer.jwtConfig");
const SECRET_TOKEN = jwtConfig.secret;

passport.use(
  "login",
  new localStrategy(
    {
      usernameField: "mail",
      passwordField: "passwort",
    },
    async (mail, passwort, done) => {
      try {
        const user = await userService.userExists(mail, passwort);
        if (user.error) {
          return done(null, false, { message: user.error });
        }
        const _user = {id: user.id, mail: user.mail, erstellt_ts: user.erstellt_ts };
        await userService.logLogintoDB(mail).catch((error) => console.log(error));
        
        return done(null, _user, { message: "Erfolgreich eingeloggt" });
      } catch (error) {
        return done(error);
      }
    }
  )
);

passport.use(
  new JWTstrategy(
    {
      secretOrKey: SECRET_TOKEN,
      jwtFromRequest: ExtractJWT.fromUrlQueryParameter("secret_token"),
    },
    async (token, done) => {
      try {
        console.log(token.user);
        return done(null, token.user);
      } catch (error) {
        done(error);
      }
    }
  )
);
