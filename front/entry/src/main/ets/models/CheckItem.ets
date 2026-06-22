export interface CheckItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface CheckRequest {
  id: number
  regist_id: string
  patient_name: string
  check_item: string
  status: string
  request_date: string
}
