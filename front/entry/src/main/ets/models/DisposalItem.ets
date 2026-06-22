export interface DisposalItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface DisposalRequest {
  id: number
  regist_id: string
  patient_name: string
  disposal_item: string
  status: string
  request_date: string
}
