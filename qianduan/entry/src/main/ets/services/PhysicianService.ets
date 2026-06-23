/**
 * @file 门诊医生服务
 * 对应 Vue 版 physician 模块所有 API
 */

import ApiClient from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Registration } from '../models/Registration'

const PORT: number = 8092

/**
 * 获取等待看诊患者（分页）
 * @param params - { employee_id, case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getWaitPatient(params?: Record<string, Object | undefined>): Promise<RestBean<Registration>> {
  return await ApiClient.getInstance().get<RestBean<Registration>>(PORT, '/getWaitPatient', params)
}

/**
 * 标记患者开始看诊
 * @param id - 挂号记录ID
 * @returns 响应消息
 */
export async function treatPatient(id: number): Promise<string> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/treatPatient', { id: id })
  return resp
}

/**
 * 获取今日已完成看诊人数
 * @param employeeId - 医生ID
 * @returns 人数
 */
export async function getFinishPatientCount(employeeId: number): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getFinishPatientCount', { employee_id: employeeId })
  return parseInt(resp) || 0
}

/**
 * 获取等待看诊人数
 * @param employeeId - 医生ID
 * @returns 人数
 */
export async function getWaitPatientCount(employeeId: number): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getWaitPatientCount', { employee_id: employeeId })
  return parseInt(resp) || 0
}

/**
 * 获取已看诊患者记录（分页）
 * @param params - { employee_id, case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getCheckedPatient(params?: Record<string, Object | undefined>): Promise<RestBean<Registration>> {
  return await ApiClient.getInstance().post<RestBean<Registration>>(PORT, '/getCheckedPatient', params ?? {})
}

/**
 * 获取患者全部费用项目
 * @param port - 端口（查询药品用8091，其他8092）
 * @param registerId - 挂号记录ID
 * @returns 费用项目列表（含 totalCount）
 */
export async function getPatientItemByType(port: number, path: string, registerId: number): Promise<{ list: object[] }> {
  return await ApiClient.getInstance().get<{ list: object[] }>(port, path, { register_id: registerId })
}
