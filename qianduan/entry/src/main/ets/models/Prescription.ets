/**
 * @file 处方数据模型
 */

export interface Prescription {
  id: number
  register_id: number
  drug_name: string
  drug_code: string
  drug_format: string
  drug_usage: string
  dosage: string
  quantity: string
  drug_price: string
  total_price: string
  prescribe_time: string
  doctor_name: string
}
