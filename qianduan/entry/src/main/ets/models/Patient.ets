/**
 * @file 患者数据模型
 */

export interface Patient {
  id: number
  real_name: string
  case_number: string
  gender: string
  age: string
  age_type: string
  id_card: string
  card_number: string
  phone: string
  home_address: string
  birthday: string
  visit_state: string
  visit_date: string
}
