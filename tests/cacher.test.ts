import { Cacher }  from '../src/cacher';

describe('Manipulating cache state', () => {
  let cacher: Cacher;

  beforeEach(() => {
    cacher = new Cacher({
      cacheSizeMax: 1
    });
  });
  
  it('Can cache', () => {
    expect(
     cacher.add('lorem', 'lorem ipsum dolor sit amet')
    ).toEqual(true);
  });

  it('Can fetch', () => {
    cacher.add('lorem', 'lorem ipsum dolor sit amet')

    expect(
      cacher.fetch('lorem')
    ).toEqual('lorem ipsum dolor sit amet');
  });

  it('Can remove', () => {
    expect(cacher.remove('lorem')).toEqual(false); // not added yet
    cacher.add('lorem', 'lorem ipsum dolor sit amet')

    expect(cacher.remove('lorem')).toEqual(true);
    expect(cacher.fetch('lorem')).toBeNull();
  });

  it('Can handle too many removes', () => {
    cacher.add('lorem', 'lorem ipsum dolor sit amet')

    expect(cacher.remove('lorem')).toEqual(true);
    expect(cacher.remove('lorem')).toEqual(false); // already removed
  });
});

describe('Pruning the cache', () => {
  it('cacheSizeMax = 1', () => {
    let cacher = new Cacher({ cacheSizeMax: 1 });
    cacher.add('lorem', 'ipsum');
    expect(cacher.stats().index).toEqual(new Set(['lorem']));
    cacher.add('ipsum', 'dolor');
    expect(cacher.stats().index).toEqual(new Set(['ipsum']));
  });

  it('cacheSizeMax = 2', () => {
    let cacher = new Cacher({ cacheSizeMax: 2 });
    cacher.add('lorem', 'ipsum');
    cacher.add('ipsum', 'dolor');
    expect(cacher.stats().index).toEqual(new Set(['lorem', 'ipsum']));
    cacher.add('sit', 'amet');
 
    expect(cacher.stats().index).toEqual(new Set(['ipsum', 'sit']));
  });

  it('Index can handle manual deletes', () => {
    let cacher = new Cacher({ cacheSizeMax: 2 });
    cacher.add('lorem', 'ipsum');
    cacher.add('ipsum', 'dolor');
    cacher.remove('ipsum');
    cacher.add('dolor', 'sit');

    expect(cacher.stats().index).toEqual(new Set(['lorem', 'dolor']));
  });
});
