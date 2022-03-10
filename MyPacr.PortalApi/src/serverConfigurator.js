const directusService = require("./external/directusService");
const smartschoolService = require("./external/smartschoolService");
const cronJobService = require("./service/cronJobService");

const service = {};

service.configServices = () => {
  return new Promise((resolve, reject) => {
    //Setup Directus using the configuration files in 'root'/config.
    directusService.setupService();

    directusService
      .getConfigurations()
      .then(configs => {
        console.log("*** Logging Z Configurations ***");
        console.log(JSON.stringify(configs));
        console.log("*** End Logging Z Configurations ***");

        // setting the Z-configurations in global variable to be used everywhere
        global.Zconfigs = configs;

        for (let index = 0; index < configs.length; index++) {
          const directusConfig = configs[index];
          switch (directusConfig.key) {
            case "smartschool":
              smartschoolService.setupService(directusConfig.config);
              break;
            case "cronJobs":
              cronJobService.setupService(directusConfig.config);
              break;
            case "messageProviderSettings":
              global.messageProviderSettings = directusConfig.config;
              break;
            default:
              return reject(
                "No service configurator found for key: " + directusConfig.key
              );
              break;
          }
        }
        return resolve(true);
      })
      .catch(err => {
        return reject(err);
      });
  });
};

module.exports = service;
