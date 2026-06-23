/**
 * @file 通用后端响应包装
 * 对应后端 com.neuedu.bean.RestBean
 */

export interface RestBean<T> {
  list: T[]
  totalCount: number
  msg: string
  status: number
}

/**
 * 带 Map 返回的特殊响应（收费/退费查询等）
 */
export interface RestBeanMap {
  registMap: Record<string, Object> | null
  requestList: ExpenseItem[]
  msg: string
  status: number
}

/**
 * 费用项目明细（用于收费/退费列表）
 */
export interface ExpenseItem {
  id: number
  item_name: string
  item_price: string
  item_type: string
  item_format: string
  item_code: string
  item_number: string
  item_create_time: string
  item_state: string
  item_unit: string
  manufacturer: string
  register_id: number
}
