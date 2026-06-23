/**
 * @file 断点系统
 * 根据窗口宽度判断设备类型（SM/MD/LG），用于自适应布局
 */

import { window } from '@kit.ArkUI'

// 断点类型枚举
export enum BreakpointType {
  SM = 'sm',
  MD = 'md',
  LG = 'lg'
}

// 断点阈值（单位 vp）
const BREAKPOINT_SM_MAX: number = 600
const BREAKPOINT_MD_MAX: number = 840

/**
 * 根据窗口宽度获取断点类型
 * @param width - 窗口宽度（vp）
 * @returns 断点类型
 */
export function getBreakpoint(width: number): BreakpointType {
  if (width <= BREAKPOINT_SM_MAX) {
    return BreakpointType.SM
  } else if (width <= BREAKPOINT_MD_MAX) {
    return BreakpointType.MD
  } else {
    return BreakpointType.LG
  }
}

/**
 * 判断是否为平板设备
 * @param width - 窗口宽度（vp）
 * @returns 是否为平板
 */
export function isTablet(width: number): boolean {
  return width >= BREAKPOINT_MD_MAX
}

/**
 * 更新窗口断点（在 Ability 中调用）
 * @param windowClass - 窗口实例
 * @returns 当前断点类型
 */
export function updateBreakpoint(windowClass: window.Window): BreakpointType {
  const properties = windowClass.getWindowProperties()
  const width = properties.windowRect.width
  const bp = getBreakpoint(width)
  // 将断点值写入 AppStorage，供全局使用
  AppStorage.set<string>('breakpoint', bp)
  AppStorage.set<number>('windowWidth', width)
  return bp
}
