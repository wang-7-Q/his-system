/**
 * Safely extract a string field value from any object.
 * Uses Object.keys/values to avoid bracket-access-on-Object restrictions.
 */
export function getStringField(obj: Object, key: string): string {
  const keys: string[] = Object.keys(obj)
  const values: Object[] = Object.values(obj)
  for (let i = 0; i < keys.length; i++) {
    if (keys[i] === key) {
      const val: Object = values[i]
      if (val !== undefined && val !== null) {
        return String(val)
      }
      break
    }
  }
  return ''
}

/**
 * Safely extract a number field value from any object.
 */
export function getNumberField(obj: Object, key: string): number {
  const str: string = getStringField(obj, key)
  const num: number = Number(str)
  return isNaN(num) ? 0 : num
}
