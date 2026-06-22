import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { User } from '../models/User'
import { StorageUtil } from '../common/StorageUtil'

export class AuthService {
  private static api: ApiClient = ApiClient.getInstance()

  private static tokenKey: string = 'auth_token'

  static async login(username: string, password: string): Promise<RestBean<User>> {
    const params: HttpParams = new HttpParams()
    params.add('username', username)
    params.add('password', password)
    params.add('type', '1')

    const result: RestBean<User> = await AuthService.api.get<User>(8091, '/login', params)

    if (result.status === 1 && result.list && result.list.length > 0) {
      const user: User = result.list[0]
      await StorageUtil.put('Flag', 'isLogin')
      await StorageUtil.put('loginUser', JSON.stringify(user))

      const sessionToken: string = 'session_' + Date.now().toString() + '_' + user.id.toString()
      await StorageUtil.put(AuthService.tokenKey, sessionToken)
      AuthService.api.setAuthToken(sessionToken)

      AppStorage.setOrCreate('isLoggedIn', true)
      AppStorage.setOrCreate('loginUser', user)
    }
    return result
  }

  static async logout(): Promise<void> {
    await StorageUtil.remove('Flag')
    await StorageUtil.remove('loginUser')
    await StorageUtil.remove(AuthService.tokenKey)
    AuthService.api.clearAuthToken()
    AppStorage.setOrCreate('isLoggedIn', false)
    AppStorage.setOrCreate('loginUser', null)
  }

  static getLoginUserFromCache(): User | null {
    const cached: User | undefined = AppStorage.get<User>('loginUser')
    if (cached) {
      return cached
    }
    return null
  }

  static getUserDeptType(): string {
    const user: User | null = AuthService.getLoginUserFromCache()
    if (user) {
      return user.dept_type
    }
    return ''
  }

  static async restoreSession(): Promise<void> {
    const token: string = await StorageUtil.get(AuthService.tokenKey)
    if (token) {
      AuthService.api.setAuthToken(token)
    }
  }
}
