/**
 * @file 费用数据模型
 */

export interface Expense {
  id: number
  register_id: number
  item_name: string
  item_price: string
  item_type: string
  item_format: string
  item_code: string
  item_number: string
  item_create_time: string
  item_state: string
}
