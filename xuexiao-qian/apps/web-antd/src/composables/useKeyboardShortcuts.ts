import { onMounted, onUnmounted } from 'vue';

/**
 * 键盘快捷键Hook
 * Requirements: 18.1, 18.2, 18.3
 *
 * 实现 E(编辑)、R(刷新)、Ctrl+S(保存) 快捷键
 */

export interface KeyboardShortcutOptions {
  /** 按下E键时的回调 */
  onEdit?: () => void;
  /** 按下R键时的回调 */
  onRefresh?: () => void;
  /** 按下Ctrl+S时的回调 */
  onSave?: () => void;
  /** 是否启用 */
  enabled?: boolean;
}

/**
 * 键盘快捷键Hook
 */
export function useKeyboardShortcuts(options: KeyboardShortcutOptions) {
  const { onEdit, onRefresh, onSave, enabled = true } = options;

  function handleKeyDown(event: KeyboardEvent) {
    if (!enabled) return;

    // 如果焦点在输入框中，不处理快捷键
    const target = event.target as HTMLElement;
    if (
      target.tagName === 'INPUT' ||
      target.tagName === 'TEXTAREA' ||
      target.isContentEditable
    ) {
      // 只处理Ctrl+S
      if (event.ctrlKey && event.key.toLowerCase() === 's') {
        event.preventDefault();
        onSave?.();
      }
      return;
    }

    // E键 - 编辑
    if (event.key.toLowerCase() === 'e' && !event.ctrlKey && !event.altKey) {
      event.preventDefault();
      onEdit?.();
      return;
    }

    // R键 - 刷新
    if (event.key.toLowerCase() === 'r' && !event.ctrlKey && !event.altKey) {
      event.preventDefault();
      onRefresh?.();
      return;
    }

    // Ctrl+S - 保存
    if (event.ctrlKey && event.key.toLowerCase() === 's') {
      event.preventDefault();
      onSave?.();
    }
  }

  onMounted(() => {
    window.addEventListener('keydown', handleKeyDown);
  });

  onUnmounted(() => {
    window.removeEventListener('keydown', handleKeyDown);
  });

  return {
    handleKeyDown,
  };
}

export default useKeyboardShortcuts;
