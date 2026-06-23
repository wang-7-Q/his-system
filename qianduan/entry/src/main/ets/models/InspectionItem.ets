/**
 * @file 检验项目数据模型
 */

// 检验项目
export interface InspectionItem {
  id: number
  item_code: string
  item_name: string
  item_format: string
  item_price: string
  item_type: string
  item_state: string
  item_create_time: string
  inspection_result: string
  register_id: number
}

// 检验申请/请求
export interface InspectionRequest {
  id: number
  inspection_employee_id: number
  item_name: string
  item_code: string
}
