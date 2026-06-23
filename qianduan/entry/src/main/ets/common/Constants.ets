/**
 * @file 系统常量配置
 * 定义API端口、路由映射、模块配置等全局常量
 */

// 后端双端口常量
export const PORT_8091: number = 8091
export const PORT_8092: number = 8092

/**
 * ★ 联调地址配置
 *
 * - 模拟器联调: 必须使用宿主机 IP（模拟器是独立虚拟机，访问不了 localhost）
 *   获取方式: 在宿主机终端运行 `ipconfig`，找到 IPv4 地址（如 192.168.x.x）
 * - 真机联调: 同上，确保手机和电脑在同一 WiFi 下
 * - 本地预览: 只有 DevEco Studio Previewer（非模拟器）才可以用 localhost
 *
 * 切换方法: 修改下方 HOST_IP 的值即可
 */
const HOST_IP: string = '10.73.52.171' // ← 改为你的宿主机 IP

export const BASE_URL_8091: string = 'http://' + HOST_IP + ':' + PORT_8091
export const BASE_URL_8092: string = 'http://' + HOST_IP + ':' + PORT_8092

// 默认分页大小
export const PAGE_SIZE_DEFAULT: number = 10
export const PAGE_SIZES: number[] = [5, 10, 20, 50]

// 登录账号提示列表
export const LOGIN_ACCOUNT_TIPS: string[] = [
  'root（可查看所有功能，请勿进行业务操作）',
  '挂号',
  '扁鹊（范无病、华佗、葛洪等医生）',
  '检查',
  '检验',
  '处置'
]

// 模块配置 - 对应左侧导航的6个业务模块
export const TAB_CONFIGS: TabConfig[] = [
  { name: '挂号收费', icon: 'document', type: '财务', port: PORT_8092 },
  { name: '门诊医生', icon: 'user', type: '门诊', port: PORT_8092 },
  { name: '检查管理', icon: 'camera', type: '检查', port: PORT_8092 },
  { name: '检验管理', icon: 'headset', type: '检验', port: PORT_8092 },
  { name: '药房管理', icon: 'wallet', type: '药房', port: PORT_8091 },
  { name: '处置管理', icon: 'firstaid', type: '处置', port: PORT_8092 }
]

// 状态颜色映射
export const STATUS_COLORS: Record<string, string> = {
  '已缴费': '#52c41a',
  '未缴费': '#ff4d4f',
  '已完成': '#1890ff',
  '待处理': '#fa8c16',
  '已退费': '#8c8c8c',
  '已发药': '#52c41a',
  '未发药': '#ff4d4f',
  '已退药': '#8c8c8c',
  '待检查': '#fa8c16',
  '待检验': '#fa8c16',
  '待处置': '#fa8c16'
}

// 性别列表
export const GENDER_OPTIONS: SelectOption[] = [
  { value: '男', label: '男' },
  { value: '女', label: '女' }
]

// 年龄类型
export const AGE_TYPE_OPTIONS: SelectOption[] = [
  { value: '年', label: '年' },
  { value: '天', label: '天' }
]

// 午别
export const NOON_OPTIONS: SelectOption[] = [
  { value: '上午', label: '上午' },
  { value: '下午', label: '下午' }
]

// 收费方式
export const PAYMENT_METHODS: SelectOption[] = [
  { value: '现金', label: '现金' },
  { value: '微信', label: '微信' },
  { value: '支付宝', label: '支付宝' },
  { value: '银行卡', label: '银行卡' },
  { value: '医保卡', label: '医保卡' }
]

// 患者看诊状态
export enum VisitState {
  WAIT = '待诊',
  TREATING = '诊治中',
  FINISHED = '已诊',
  CHECKED = '已检查',
  INSPECTED = '已检验',
  DISPOSAL = '已处置'
}

// 模块配置接口
export interface TabConfig {
  name: string
  icon: string
  type: string
  port: number
}

// 下拉选择项接口
export interface SelectOption {
  value: string
  label: string
}

// 分页信息接口
export interface PageInfo {
  page: number
  size: number
  total: number
}
