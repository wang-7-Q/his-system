export interface FormValidationItem {
  value: string
  fieldName: string
  validator: (value: string, fieldName: string) => string
  onError: (message: string) => void
}

export class Validators {
  static isNotEmpty(value: string, fieldName: string): string {
    if (!value || value.trim().length === 0) {
      return `${fieldName}不能为空`
    }
    return ''
  }

  static isNumber(value: string, fieldName: string): string {
    if (isNaN(Number(value))) {
      return `${fieldName}必须是数字`
    }
    return ''
  }

  static isPhone(value: string): string {
    const phoneReg: RegExp = /^1[3-9]\d{9}$/
    if (!phoneReg.test(value)) {
      return '请输入有效的手机号码'
    }
    return ''
  }

  static validateForm(fields: FormValidationItem[]): boolean {
    for (const field of fields) {
      const error: string = field.validator(field.value, field.fieldName)
      if (error) {
        field.onError(error)
        return false
      }
    }
    return true
  }
}
