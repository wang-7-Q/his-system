export interface TabConfig {
  name: string
  icon: string
  type: string
  port: number
}

export class Constants {
  /** Default API base URL (host VM network IP for emulator access) */
  static readonly API_BASE_URL_LOCAL: string = 'http://172.16.42.72'
  static readonly PORT_8091: number = 8091
  static readonly PORT_8092: number = 8092

  /** API base URLs - extracted for easy environment switching */
  static readonly BASE_URL_8091: string = `${Constants.API_BASE_URL_LOCAL}:${Constants.PORT_8091}`
  static readonly BASE_URL_8092: string = `${Constants.API_BASE_URL_LOCAL}:${Constants.PORT_8092}`

  /** Default timeout for network requests (in milliseconds) */
  static readonly REQUEST_TIMEOUT: number = 30000

  static readonly PAGE_SIZE_DEFAULT: number = 10
  static readonly PAGE_SIZES: number[] = [5, 10, 20, 50]

  static readonly TAB_CONFIGS: TabConfig[] = [
    { name: '挂号收费', icon: 'icon_registration', type: '挂号', port: 8092 },
    { name: '门诊医生', icon: 'icon_physician', type: '门诊', port: 8092 },
    { name: '检查管理', icon: 'icon_check', type: '检查', port: 8092 },
    { name: '检验管理', icon: 'icon_inspection', type: '检验', port: 8092 },
    { name: '药房管理', icon: 'icon_drugstore', type: '药房', port: 8091 },
    { name: '处置管理', icon: 'icon_disposal', type: '处置', port: 8092 },
  ]
}
