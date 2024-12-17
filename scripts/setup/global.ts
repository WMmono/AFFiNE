import { setupGlobal } from '@affine/env/global';
import { getBuildConfig } from '@affine-tools/utils/build-config';
import { Workspace } from '@affine-tools/utils/workspace';

globalThis.BUILD_CONFIG = getBuildConfig(
  new Workspace().getPackage('@affine/web'),
  {
    mode: 'development',
    channel: 'canary',
  }
);

if (typeof window !== 'undefined') {
  window.location.search = '?prefixUrl=http://127.0.0.1:3010/';
}

setupGlobal();
