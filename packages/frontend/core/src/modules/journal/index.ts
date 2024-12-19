import { type Framework } from '@toeverything/infra';

import { EditorSettingService } from '../editor-setting';
import { JournalService } from './services/journal';
import { JournalDocService } from './services/journal-doc';
import { JournalStore } from './store/journal';
import { DocsService, DocScope, DocService } from '../doc';
import { WorkspaceScope } from '../workspace';

export {
  JOURNAL_DATE_FORMAT,
  JournalService,
  type MaybeDate,
} from './services/journal';
export { JournalDocService } from './services/journal-doc';
export { suggestJournalDate } from './suggest-journal-date';

export function configureJournalModule(framework: Framework) {
  framework
    .scope(WorkspaceScope)
    .service(JournalService, [JournalStore, DocsService, EditorSettingService])
    .store(JournalStore, [DocsService])
    .scope(DocScope)
    .service(JournalDocService, [DocService, JournalService]);
}
