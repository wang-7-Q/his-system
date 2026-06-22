import { preferences } from '@kit.ArkData'

const STORE_NAME: string = 'his_preferences'

export class StorageUtil {
  private static store?: preferences.Preferences
  private static initialized: boolean = false

  static async init(context: Context): Promise<void> {
    StorageUtil.store = await preferences.getPreferences(context, STORE_NAME)
    StorageUtil.initialized = true
  }

  static isReady(): boolean {
    return StorageUtil.initialized && StorageUtil.store !== undefined
  }

  static async put(key: string, value: string): Promise<void> {
    if (!StorageUtil.store) {
      throw new Error('StorageUtil not initialized - call init(context) first')
    }
    await StorageUtil.store.put(key, value)
    await StorageUtil.store.flush()
  }

  static async get(key: string): Promise<string> {
    if (!StorageUtil.store) {
      throw new Error('StorageUtil not initialized - call init(context) first')
    }
    return await StorageUtil.store.get(key, '') as string
  }

  static async remove(key: string): Promise<void> {
    if (!StorageUtil.store) {
      throw new Error('StorageUtil not initialized - call init(context) first')
    }
    await StorageUtil.store.delete(key)
    await StorageUtil.store.flush()
  }

  static async clearAll(): Promise<void> {
    if (!StorageUtil.store) {
      throw new Error('StorageUtil not initialized - call init(context) first')
    }
    await StorageUtil.store.clear()
    await StorageUtil.store.flush()
  }

  static async isLoggedIn(): Promise<boolean> {
    const flag: string = await StorageUtil.get('Flag')
    return flag === 'isLogin'
  }

  static async getLoginUser(): Promise<string> {
    return await StorageUtil.get('loginUser')
  }
}
