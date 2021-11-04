module.exports = {
  verbose: true,
  roots: [
    "spec/javascript"
  ],
  moduleDirectories: [
    "node_modules",
    "<rootDir>/app/javascript"
  ],
  moduleFileExtensions: [
    "js",
    "json",
    "vue"
  ],
  transform: {
    "^.+\\.js$": "babel-test",
    ".*\\.(vue)$": "vue-test"
  },
  testEnvironment: "jsdom"
}