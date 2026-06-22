export interface InspectionItem {
  id: number
  item_name: string
  dept_name: string
  price: number
}

export interface InspectionRequest {
  id: number
  regist_id: string
  patient_name: string
  inspection_item: string
  status: string
  request_date: string
}
