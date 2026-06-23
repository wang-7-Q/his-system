/**
 * @file 表单验证工具
 * 提供常用表单字段校验方法
 */

// 验证结果接口
export interface ValidationResult {
  isValid: boolean
  errorMsg: string
}

// 表单校验项接口
export interface FormValidationItem {
  value: string
  fieldName: string
  rules: ValidationRule[]
}

// 校验规则接口
export interface ValidationRule {
  type: 'required' | 'number' | 'phone' | 'idCard' | 'minLength' | 'maxLength'
  message: string
  param?: number
}

/**
 * 验证非空
 * @param value - 输入值
 * @param fieldName - 字段名称
 * @returns 验证结果
 */
export function isNotEmpty(value: string, fieldName: string): ValidationResult {
  if (value == null || value.trim() === '') {
    return { isValid: false, errorMsg: fieldName + '不能为空' }
  }
  return { isValid: true, errorMsg: '' }
}

/**
 * 验证数字
 * @param value - 输入值
 * @param fieldName - 字段名称
 * @returns 验证结果
 */
export function isNumber(value: string, fieldName: string): ValidationResult {
  if (value == null || value.trim() === '') {
    return { isValid: true, errorMsg: '' }
  }
  const num = Number(value)
  if (isNaN(num)) {
    return { isValid: false, errorMsg: fieldName + '必须为数字' }
  }
  return { isValid: true, errorMsg: '' }
}

/**
 * 验证手机号（简单11位数字校验）
 * @param value - 手机号
 * @returns 验证结果
 */
export function isPhone(value: string): ValidationResult {
  if (value == null || value.trim() === '') {
    return { isValid: true, errorMsg: '' }
  }
  const phoneRegex = /^1[3-9]\d{9}$/
  if (!phoneRegex.test(value.trim())) {
    return { isValid: false, errorMsg: '手机号格式不正确' }
  }
  return { isValid: true, errorMsg: '' }
}

/**
 * 验证身份证号（18位简单校验）
 * @param value - 身份证号
 * @returns 验证结果
 */
export function isIdCard(value: string): ValidationResult {
  if (value == null || value.trim() === '') {
    return { isValid: true, errorMsg: '' }
  }
  const idRegex = /^\d{17}[\dXx]$/
  if (!idRegex.test(value.trim())) {
    return { isValid: false, errorMsg: '身份证号格式不正确' }
  }
  return { isValid: true, errorMsg: '' }
}

/**
 * 批量校验表单字段
 * @param items - 校验项数组
 * @returns 第一条错误信息，无错误返回空字符串
 */
export function validateForm(items: FormValidationItem[]): string {
  for (const item of items) {
    for (const rule of item.rules) {
      let result: ValidationResult = { isValid: true, errorMsg: '' }
      if (rule.type === 'required') {
        result = isNotEmpty(item.value, item.fieldName)
      } else if (rule.type === 'number') {
        result = isNumber(item.value, item.fieldName)
      } else if (rule.type === 'phone') {
        result = isPhone(item.value)
      } else if (rule.type === 'idCard') {
        result = isIdCard(item.value)
      } else if (rule.type === 'minLength') {
        if (item.value.length < (rule.param ?? 0)) {
          result = { isValid: false, errorMsg: item.fieldName + '不能少于' + rule.param + '个字符' }
        }
      } else if (rule.type === 'maxLength') {
        if (item.value.length > (rule.param ?? 999)) {
          result = { isValid: false, errorMsg: item.fieldName + '不能超过' + rule.param + '个字符' }
        }
      }
      if (!result.isValid) {
        return result.errorMsg
      }
    }
  }
  return ''
}
