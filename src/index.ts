export * from './cacher';

import { Cacher } from './cacher';
let cache = new Cacher({ cacheSizeMax: 1 });
console.log('ok');
