/**
 * @file 存储工具类
 * 封装 @kit.ArkData 的 preferences API，提供同步式 KV 存储
 */

import { preferences } from '@kit.ArkData'

let prefInstance: preferences.Preferences | null = null

/**
 * 初始化 preferences 实例
 * @param context - 应用上下文
 */
export async function initStorage(context: Context): Promise<void> {
  prefInstance = await preferences.getPreferences(context, 'his_app_settings')
}

/**
 * 获取 preferences 实例（确保已初始化）
 */
function getPref(): preferences.Preferences {
  if (prefInstance == null) {
    throw new Error('StorageUtil 未初始化，请先调用 initStorage()')
  }
  return prefInstance
}

/**
 * 存入键值对
 * @param key - 键名
 * @param val - 值（对象会被 JSON 序列化）
 */
export async function put(key: string, val: Object | string | number | boolean): Promise<void> {
  const pref = getPref()
  let strVal: string = ''
  if (typeof val === 'string' || typeof val === 'number' || typeof val === 'boolean') {
    strVal = String(val)
  } else {
    strVal = JSON.stringify(val)
  }
  await pref.put(key, strVal)
  await pref.flush()
}

/**
 * 读取键值
 * @param key - 键名
 * @returns 字符串值，不存在返回空字符串
 */
export async function get(key: string): Promise<string> {
  const pref = getPref()
  const val = await pref.get(key, '')
  return val as string
}

/**
 * 删除指定键
 * @param key - 键名
 */
export async function remove(key: string): Promise<void> {
  const pref = getPref()
  await pref.delete(key)
  await pref.flush()
}

/**
 * 清除所有数据
 */
export async function clearAll(): Promise<void> {
  const pref = getPref()
  await pref.clear()
  await pref.flush()
}

/**
 * 检查是否已登录
 */
export async function isLoggedIn(): Promise<boolean> {
  const flag = await get('Flag')
  return flag === 'isLogin'
}

/**
 * 获取缓存的登录用户信息（JSON 解析）
 * @returns 用户对象或 null
 */
export async function getLoginUser(): Promise<Record<string, string> | null> {
  const userStr = await get('loginUser')
  if (userStr === '') {
    return null
  }
  try {
    return JSON.parse(userStr) as Record<string, string>
  } catch {
    return null
  }
}
