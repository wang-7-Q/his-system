/**
 * @file 检查项目数据模型
 */

// 检查项目
export interface CheckItem {
  id: number
  item_code: string
  item_name: string
  item_format: string
  item_price: string
  item_type: string
  item_state: string
  item_create_time: string
  check_time: string
  check_result: string
  register_id: number
}

// 检查申请/请求
export interface CheckRequest {
  id: number
  check_employee_id: number
  item_name: string
  item_code: string
}
