import { type Framework } from '@toeverything/infra';

import { DocsSearchService } from '../docs-search';
import { DocDatabaseBacklinksService } from './services/doc-database-backlinks';
import { DocsService } from '../doc/services/docs';
import { WorkspaceScope } from '../workspace';

export { DocDatabaseBacklinkInfo } from './views/database-properties/doc-database-backlink-info';

export function configureDocInfoModule(framework: Framework) {
  framework
    .scope(WorkspaceScope)
    .service(DocDatabaseBacklinksService, [DocsService, DocsSearchService]);
}
