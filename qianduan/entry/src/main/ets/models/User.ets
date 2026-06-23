/**
 * @file 用户数据模型
 */

export interface User {
  id: number
  realname: string
  username: string
  password: string
  dept_type: string
  dept_name: string
  regist_level_id: string
  regist_level: string
  settle_category_id: string
}
