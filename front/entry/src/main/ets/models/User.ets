/**
 * Observable model for login user data.
 * Used for reactive UI state management in V2 components.
 */
@ObservedV2
export class User {
  @Trace id: number = 0
  @Trace realname: string = ''
  @Trace username: string = ''
  @Trace password: string = ''
  @Trace dept_type: string = ''
  @Trace dept_name: string = ''
  @Trace regist_level_id: number = 0
  @Trace regist_level: string = ''
  @Trace settle_category_id: number = 0
}

/**
 * Create a User instance from a plain object (e.g., JSON.parse result).
 */
export function userFromPlain(obj: Record<string, Object>): User {
  const user: User = new User()
  user.id = Number(obj['id'] || 0)
  user.realname = String(obj['realname'] || '')
  user.username = String(obj['username'] || '')
  user.password = String(obj['password'] || '')
  user.dept_type = String(obj['dept_type'] || '')
  user.dept_name = String(obj['dept_name'] || '')
  user.regist_level_id = Number(obj['regist_level_id'] || 0)
  user.regist_level = String(obj['regist_level'] || '')
  user.settle_category_id = Number(obj['settle_category_id'] || 0)
  return user
}
