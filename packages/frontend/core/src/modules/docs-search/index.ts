export { DocsSearchService } from './services/docs-search';

import { type Framework } from '@toeverything/infra';

import { DocsIndexer } from './entities/docs-indexer';
import { DocsSearchService } from './services/docs-search';
import {
  WorkspaceScope,
  WorkspaceService,
  WorkspaceLocalState,
} from '../workspace';

export function configureDocsSearchModule(framework: Framework) {
  framework
    .scope(WorkspaceScope)
    .service(DocsSearchService, [WorkspaceService])
    .entity(DocsIndexer, [WorkspaceService, WorkspaceLocalState]);
}
