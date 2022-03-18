const environmentConfig = require("./environmentConfig");

const developmentEnvironmentConfig = {
  environment: "development",
  directusSettings: {
    token: "4E29pMC5ZdHpW0TmhJubySEs",
    url: "http://localhost:8055"
  },
  portalSettings: {
    fileLink: "http://localhost:80",
    apiUrl: "http://localhost:80/api",
    tokenSettings: {
      passphrase:
        "daytona0overture96singular68Easing42gape51rusting17nereid86foliate34Flattest43fissile98Pravda76Meek",
      key: "NinaPeeters2019!"
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
