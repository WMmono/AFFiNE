export { Navigator } from './entities/navigator';
export {
  resolveLinkToDoc,
  resolveRouteLinkMeta,
  toURLSearchParams,
} from './utils';
export { NavigationButtons } from './view/navigation-buttons';

import { type Framework } from '@toeverything/infra';

import { WorkbenchService } from '../workbench/services/workbench';
import { Navigator } from './entities/navigator';
import { NavigatorService } from './services/navigator';
import { WorkspaceScope } from '../workspace';

export function configureNavigationModule(framework: Framework) {
  framework
    .scope(WorkspaceScope)
    .service(NavigatorService)
    .entity(Navigator, [WorkbenchService]);
}
