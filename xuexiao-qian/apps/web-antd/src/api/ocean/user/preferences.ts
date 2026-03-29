import type {
  SaveUserPreferencesRequest,
  UserPreferenceRecord,
} from './types/preferences.types';

import { requestClient } from '#/api/request';

async function getPreferences(key: string) {
  return requestClient.get<UserPreferenceRecord>('/ocean/user/preferences', {
    params: { key },
  });
}

async function savePreferences(data: SaveUserPreferencesRequest) {
  return requestClient.post('/ocean/user/preferences', data);
}

async function resetPreferences(key: string) {
  return requestClient.delete('/ocean/user/preferences', {
    params: { key },
  });
}

export { getPreferences, resetPreferences, savePreferences };
