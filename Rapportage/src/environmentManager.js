const environmentConfig = require("./environmentConfig");

const developmentEnvironmentConfig = {
  environment: "development",
  directusSettings: {
    token: "abcd",
    url: "http://localhost:80"
  },
  portalSettings: {
    fileLink: "http://localhost:80",
    apiUrl: "http://localhost:80/api",
    tokenSettings: {
      passphrase:
        "ABC123HIJ",
      key: "JWTSecret!"
    }
  }
};

const getEnvironmentSettings = () => {
  if (environmentConfig.environment === "#_#{var_environmentName}#_#") {
    console.log("using development environmentConfig");
    return developmentEnvironmentConfig;
  } else {
    console.log(
      "using environmentConfig.json (replaced variables - production)"
    );
    return environmentConfig;
  }
};

module.exports = {
  getEnvironmentSettings
};
