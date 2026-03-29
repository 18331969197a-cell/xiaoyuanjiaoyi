const LEGACY_BROKEN_HOSTS = new Set(['minio.zhangchuangla.cn']);

function isAbsoluteUrl(url: string) {
  return /^https?:\/\//.test(url);
}

export function resolveLegacyImage(
  url: null | string | undefined,
  fallback: string,
) {
  if (!url) {
    return fallback;
  }

  if (!isAbsoluteUrl(url)) {
    return url;
  }

  try {
    const parsed = new URL(url);
    if (LEGACY_BROKEN_HOSTS.has(parsed.hostname)) {
      return fallback;
    }
  } catch {
    return fallback;
  }

  return url;
}
