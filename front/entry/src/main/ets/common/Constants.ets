/**
 * Module configuration (used in Workbench tab cards).
 */
export interface ModuleConfig {
  name: string
  icon: string
  type: string
  port: number
  description: string
}

export class Constants {
  /** Default API base URL (host VM network IP for emulator access) */
  static readonly API_BASE_URL_LOCAL: string = 'http://192.168.183.1'
  static readonly PORT_8091: number = 8091
  static readonly PORT_8092: number = 8092

  /** API base URLs */
  static readonly BASE_URL_8091: string = `${Constants.API_BASE_URL_LOCAL}:${Constants.PORT_8091}`
  static readonly BASE_URL_8092: string = `${Constants.API_BASE_URL_LOCAL}:${Constants.PORT_8092}`

  /** Default timeout for network requests (ms) */
  static readonly REQUEST_TIMEOUT: number = 30000

  static readonly PAGE_SIZE_DEFAULT: number = 10
  static readonly PAGE_SIZES: number[] = [5, 10, 20, 50]

  // ── Design tokens ──────────────────────────────────────────
  static readonly COLOR_PRIMARY: string = '#1677FF'
  static readonly COLOR_PRIMARY_LIGHT: string = '#E6F4FF'
  static readonly COLOR_SUCCESS: string = '#52C41A'
  static readonly COLOR_WARNING: string = '#FAAD14'
  static readonly COLOR_DANGER: string = '#FF4D4F'
  static readonly COLOR_BG: string = '#F5F5F5'
  static readonly COLOR_CARD: string = '#FFFFFF'
  static readonly COLOR_TEXT_PRIMARY: string = '#1A1A1A'
  static readonly COLOR_TEXT_SECONDARY: string = '#666666'
  static readonly COLOR_TEXT_HINT: string = '#999999'
  static readonly COLOR_TAB_ACTIVE: string = '#1677FF'
  static readonly COLOR_TAB_INACTIVE: string = '#8E8E93'
  static readonly COLOR_DIVIDER: string = '#EEEEEE'

  // ── Module configs (for Workbench tab) ─────────────────────
  static readonly MODULE_CONFIGS: ModuleConfig[] = [
    { name: '挂号收费', icon: '📋', type: '挂号', port: 8092, description: '现场挂号 · 费用收取 · 退费管理' },
    { name: '门诊医生', icon: '🩺', type: '门诊', port: 8092, description: '患者接诊 · 处方开具 · 检查检验申请' },
    { name: '检查管理', icon: '🔬', type: '检查', port: 8092, description: '检查登记 · 结果录入 · 报告管理' },
    { name: '检验管理', icon: '🧪', type: '检验', port: 8092, description: '检验登记 · 结果录入 · 报告管理' },
    { name: '药房管理', icon: '💊', type: '药房', port: 8091, description: '药品发放 · 退药处理 · 库存管理' },
    { name: '处置管理', icon: '🏥', type: '处置', port: 8092, description: '处置登记 · 执行确认 · 记录管理' },
  ]

  // ── Legacy alias ───────────────────────────────────────────
  static readonly TAB_CONFIGS: ModuleConfig[] = Constants.MODULE_CONFIGS
}
