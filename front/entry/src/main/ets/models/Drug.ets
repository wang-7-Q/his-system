export interface Drug {
  id: number
  drug_code: string
  drug_name: string
  drug_format: string
  manufacturer: string
  unit_price: number
  stock: number
  expiry_date: string
}

export interface PrescriptionDrug {
  drug_id: number
  drug_name: string
  quantity: number
  usage_method: string
  dosage: string
  frequency: string
  days: number
}
