import type { Config } from 'jest';
const config: Config = {
  preset: 'ts-jest',
  verbose: true,
  transform: {
  '^.+\\.tsx?$': '@swc/jest',
  },
  coveragePathIgnorePatterns: ["/node_modules/", "/test/"],
  collectCoverageFrom: ["src/**/*.ts"],
  testRegex: "(/__benchmarks__/.*|(\\.|/)bench)\\.tsx?$",
  reporters: ["default", "jest-bench/reporter"],
  testEnvironment: "jest-bench/environment",
  testEnvironmentOptions: {
    // still Jest-bench environment will run your environment if you specify it here
    testEnvironment: "jest-environment-node",
    testEnvironmentOptions: {
      // specify any option for your environment
    }
  },
};
export default config;
