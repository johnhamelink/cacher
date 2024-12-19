import { benchmarkSuite } from "jest-bench";
import { Cacher } from '../../src/cacher';

const content: string = "25b4b3db-d576-4fb8-afcc-7c6ed766e6fa";
const inputSize = 1_000_000;

let cacher: Cacher;

benchmarkSuite("read", {
  setupSuite() {
    cacher = new Cacher({ cacheSizeMax: inputSize })
    for (var i = 0; i < inputSize; i++) {
      cacher.add(i.toString(), content);
    };
  },

  [inputSize + " - all cached"]: () => {
    for (var i = 0; i < inputSize; i++) {
      cacher.fetch(i.toString());
    };
  },

  [inputSize + " - all missing"]: () => {
    for (var i = 0; i < inputSize; i++) {
      cacher.fetch("_THIS_IS_NOT_CACHED_");
    };
  }
});
