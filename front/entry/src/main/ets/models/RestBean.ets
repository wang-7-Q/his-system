export interface RestBean<T> {
  list: T[]
  totalCount: number
  msg: string
  status: number
}

export function createRestBean<T>(list: T[], msg: string, status: number): RestBean<T> {
  return { list: list, totalCount: list.length, msg: msg, status: status } as RestBean<T>
}

// 后端 searchExpenseChargePatient / searchExpenseRefundPatient 返回格式
export interface RestBeanMap {
  msg: string
  status: number
  registMap: Object | null
  requestList: ExpenseItem[]
}

// 收费/退费项目
export interface ExpenseItem {
  id: number
  item_name: string
  item_price: string
  item_type: string
  item_format: string
  item_number: string
  item_create_time: string
  regist_id: number
  case_number: string
  patient_name: string
  status: string
}
