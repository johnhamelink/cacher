import type { Config } from 'jest';
// Sync object
const config: Config = {
  verbose: true,
  transform: {
  '^.+\\.tsx?$': '@swc/jest',
  },
  testRegex: "((\\.|/)test)\\.tsx?$",
};
export default config;
