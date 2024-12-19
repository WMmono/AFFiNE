import { type Framework } from '@toeverything/infra';

import { OpenInAppService } from './services';
import { GlobalState } from '../storage';
import { WorkspacesService } from '../workspace';

export { OpenInAppService, OpenLinkMode } from './services';
export * from './utils';
export * from './views/open-in-app-guard';

export const configureOpenInApp = (framework: Framework) => {
  framework.service(OpenInAppService, [GlobalState, WorkspacesService]);
};
