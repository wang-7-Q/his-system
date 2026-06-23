/**
 * @file 认证服务
 * 处理登录/登出逻辑
 */

import ApiClient from './ApiClient'
import { put, get, remove, isLoggedIn, getLoginUser } from '../common/StorageUtil'
import { promptAction } from '@kit.ArkUI'
import { User } from '../models/User'

const PORT_LOGIN: number = 8091

/**
 * 登录
 * @param username - 用户名
 * @param password - 密码
 * @returns 登录成功返回 true，失败返回 false
 */
export async function login(username: string, password: string): Promise<boolean> {
  try {
    const data = await ApiClient.getInstance().get<User[]>(PORT_LOGIN, '/login', {
      username: username,
      password: password,
      type: '1'
    })
    if (data == null || data.length === 0) {
      promptAction.showToast({ message: '用户名或密码不存在或错误!', duration: 2000 })
      return false
    }
    const loginUser: User = data[0]
    // 存入 preferences
    await put('Flag', 'isLogin')
    await put('loginUser', JSON.stringify(loginUser))
    // 存入 AppStorage 供全局 UI 使用
    AppStorage.set<string>('Flag', 'isLogin')
    AppStorage.set<string>('loginUser', JSON.stringify(loginUser))
    promptAction.showToast({ message: '欢迎 ' + loginUser.realname + ' 登录成功!', duration: 1500 })
    return true
  } catch (error) {
    promptAction.showToast({ message: '登录失败: 网络错误', duration: 2000 })
    return false
  }
}

/**
 * 登出
 */
export async function logout(): Promise<void> {
  await remove('Flag')
  await remove('loginUser')
  AppStorage.set<string>('Flag', '')
  AppStorage.set<string>('loginUser', '')
}

/**
 * 检查是否已登录
 * @returns 是否已登录
 */
export async function checkLogin(): Promise<boolean> {
  return await isLoggedIn()
}

/**
 * 从缓存获取登录用户信息
 * @returns 用户对象或 null
 */
export async function getLoginUserFromCache(): Promise<User | null> {
  const userData = await getLoginUser()
  if (userData == null) {
    return null
  }
  return userData as unknown as User
}

/**
 * 获取当前用户部门类型
 * @returns 部门类型字符串
 */
export function getUserDeptType(): string {
  const userStr: string = AppStorage.get<string>('loginUser') as string
  if (userStr == null || userStr === '') {
    return ''
  }
  try {
    const user: User = JSON.parse(userStr) as User
    return user.dept_type
  } catch {
    return ''
  }
}
