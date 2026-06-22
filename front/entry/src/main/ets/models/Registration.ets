export interface Registration {
  id: number
  regist_id: string
  patient_id: number
  patient_name: string
  dept_id: number
  dept_name: string
  doctor_id: number
  doctor_name: string
  regist_level: string
  settle_category: string
  status: string
  regist_date: string
  case_number: string
}

export interface RegistLevel {
  id: number
  level_name: string
  price: number
}

export interface Department {
  id: number
  dept_name: string
  dept_type: string
}

export interface Doctor {
  id: number
  realname: string
  dept_id: number
}
