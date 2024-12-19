import { type Framework } from '@toeverything/infra';

import { I18nProvider } from './context';
import { I18n, type LanguageInfo } from './entities/i18n';
import { I18nService } from './services/i18n';
import { GlobalCache } from '../storage';

export function configureI18nModule(framework: Framework) {
  framework.service(I18nService).entity(I18n, [GlobalCache]);
}

export { I18n, I18nProvider, I18nService, type LanguageInfo };
