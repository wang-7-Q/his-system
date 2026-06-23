/**
 * @file 挂号相关数据模型
 */

// 挂号记录
export interface Registration {
  id: number
  case_number: string
  real_name: string
  gender: string
  age: string
  age_type: string
  birthday: string
  card_number: string
  home_address: string
  visit_date: string
  noon: string
  deptment_id: number
  employee_id: number
  regist_level_id: number
  settle_category_id: number
  is_book: boolean
  regist_method: string
  regist_money: string
  used_number: string
  total_number: string
  visit_state: string
  settle_id: number
}

// 挂号级别
export interface RegistLevel {
  id: number
  regist_name: string
  regist_fee: string
  regist_quota: string
  sequence_no: number
}

// 科室
export interface Department {
  id: number
  dept_name: string
  dept_code: string
  dept_type: string
}

// 医生信息
export interface Doctor {
  id: number
  realname: string
  username: string
  dept_type: string
  dept_name: string
  regist_level_id: string
  regist_level: string
}

// 结算类别
export interface SettleCategory {
  id: number
  settle_name: string
}
