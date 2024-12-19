import { registerPlugin } from '@capacitor/core';

import type { NbStorePlugin } from './definitions';

const NbStoreDocStorage = registerPlugin<NbStorePlugin>('NbStoreDocStorage');

export * from './definitions';
export { NbStoreDocStorage };
