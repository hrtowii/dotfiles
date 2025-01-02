const KrispModule = require('./discord_krisp.node');

const isLogDirAvailable = window?.DiscordNative?.fileManager?.getAndCreateLogDirectorySync;
let initializationParams;
if (isLogDirAvailable) {
  const logDirectory = window.DiscordNative.fileManager.getAndCreateLogDirectorySync(window);
  const logLevel = window.DiscordNative.fileManager.logLevelSync(window);
  initializationParams = {logDirectory, logLevel};
} else {
  console.warn('Unable to find log directory');
}

KrispModule._initialize(initializationParams);

KrispModule.getNcModels = function () {
  return new Promise((resolve) => {
    KrispModule._getNcModels((models) => resolve(models));
  });
};

KrispModule.getVadModels = function () {
  return new Promise((resolve) => {
    KrispModule._getVadModels((models) => resolve(models));
  });
};

module.exports = KrispModule;
