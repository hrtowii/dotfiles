const native = require('./discord_zstd.node');

// Init logging
const isFileManagerAvailable = window?.DiscordNative?.fileManager;
const isLogDirAvailable = isFileManagerAvailable?.getAndCreateLogDirectorySync;
let initializeArgs = {};
if (isLogDirAvailable) {
  const logDirectory = window.DiscordNative.fileManager.getAndCreateLogDirectorySync();
  const logLevel = window.DiscordNative.fileManager.logLevelSync();

  initializeArgs = {
    logDirectory: logDirectory,
    logLevel: logLevel,
    logNumFiles: 1,
    logFileSize: 3 * 1024 * 1024,
  };
}
native.initializeLogging(initializeArgs);

// Returning the real context to web JS doesn't seem to work, so we will hold onto
// it here and run the decompression function calls through a proxy object.
let id = 1;
let buffer = null;

function decompress(data) {
  if (this.id !== id) {
    throw new Error('Attempting to use a stale zstd context. Only one may be active at a time');
  }
  return buffer.decompress(data);
}

function getLastError() {
  if (this.id !== id) {
    throw new Error('Attempting to use a stale zstd context. Only one may be active at a time');
  }
  return buffer.getLastError();
}

function createContext() {
  id += 1;
  if (buffer != null) {
    buffer.reset();
  } else {
    buffer = new native.DecompressStream();
  }

  return {id, decompress, getLastError};
}

module.exports = {createContext};
