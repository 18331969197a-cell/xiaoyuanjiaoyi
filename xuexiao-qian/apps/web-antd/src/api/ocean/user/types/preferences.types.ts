export interface UserPreferences {
  dataListColumns?: string[];
  exportSettings?: {
    fields?: string[];
    format?: string;
  };
  profileSettings?: {
    selectedLayer?: string;
    showSalinity?: boolean;
    showTemperature?: boolean;
  };
}

export interface UserPreferenceRecord {
  key?: string;
  preferenceValue?: UserPreferences;
}

export interface SaveUserPreferencesRequest {
  key: string;
  value: UserPreferences;
}
