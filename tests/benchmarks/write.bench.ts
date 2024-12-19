import { benchmarkSuite } from "jest-bench";
import { Cacher } from '../../src/cacher';

const content: string = "25b4b3db-d576-4fb8-afcc-7c6ed766e6fa";
const inputSize = 1_000_000;

let cacher: Cacher;
let idx: number = 0;

[ (inputSize / 20), (inputSize / 3), inputSize ].forEach((pruneThreshold) => {

  cacher = new Cacher({ cacheSizeMax: pruneThreshold });
  for (var i = 0; i <= inputSize; i++) {
    cacher.add(i.toString(), content);
  }

  benchmarkSuite("write", {
    [inputSize + " - prune threshold " + pruneThreshold]: () => {
      cacher.add((idx++).toString(), content);
    },
  });
});

