/**
 * @file 药品数据模型
 */

// 药品
export interface Drug {
  id: number
  drug_code: string
  drug_name: string
  drug_format: string
  drug_unit: string
  manufacturer: string
  drug_price: string
  drug_stock: number
  mnemonic_code: string
}

// 处方药品
export interface PrescriptionDrug {
  id: number
  item_code: string
  item_name: string
  item_format: string
  item_unit: string
  manufacturer: string
  item_price: string
  item_number: string
  register_id: number
}
