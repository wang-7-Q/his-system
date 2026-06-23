// 挂号记录 — 完整字段对齐后端 addRegister 参数
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

// 挂号级别 — 对齐后端 getRegistLevelList 返回的数据库字段
export interface RegistLevel {
  id: number
  regist_name: string
  regist_fee: string
  regist_quota: string
  sequence_no: number
}

// 科室 — 对齐后端 getAllDeptList 返回字段
export interface Department {
  id: number
  dept_name: string
  dept_code: string
  dept_type: string
}

// 医生 — 对齐后端 getRegistDoctorList 返回字段
export interface Doctor {
  id: number
  realname: string
  username: string
  dept_type: string
  dept_name: string
  regist_level_id: string
  regist_level: string
}

// 结算类别 — 对齐后端 getSettleCategory 返回字段
export interface SettleCategory {
  id: number
  settle_name: string
}
