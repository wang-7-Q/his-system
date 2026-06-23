/**
 * @file 处置管理服务
 * 对应 Vue 版 disposal 模块所有 API
 */

import ApiClient from './ApiClient'
import { RestBean } from '../models/RestBean'
import { DisposalItem } from '../models/DisposalItem'

const PORT: number = 8092

/**
 * 获取等待处置患者（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getWaitDisposal(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().get<RestBean<object>>(PORT, '/getWaitDisposal', params)
}

/**
 * 获取今日已完成处置人数
 * @returns 人数
 */
export async function getFinishDisposalCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getFinishDisposalCount')
  return parseInt(resp) || 0
}

/**
 * 获取等待处置人数
 * @returns 人数
 */
export async function getWaitDisposalCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getWaitDisposalCount')
  return parseInt(resp) || 0
}

/**
 * 获取已完成处置患者（分页，待录入结果）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getFinishDisposal(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getFinishDisposal', params ?? {})
}

/**
 * 根据挂号ID获取患者的处置项目
 * @param registerId - 挂号记录ID
 * @returns 处置项目列表
 */
export async function getFinishDisposalByRegistid(registerId: number): Promise<DisposalItem[]> {
  return await ApiClient.getInstance().get<DisposalItem[]>(PORT, '/getFinishDisposalByRegistid', { id: registerId })
}

/**
 * 获取处置科室列表
 * @returns 科室列表
 */
export async function getDisposalPatientDept(): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getDisposalPatientDept')
}

/**
 * 获取处置医生列表
 * @param deptmentId - 科室ID
 * @returns 医生列表
 */
export async function getDisposalPatientEmp(deptmentId: number): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getDisposalPatientEmp', { deptment_id: deptmentId })
}

/**
 * 更新处置结果
 * @param data - { disposal_result, id, employee_id }
 * @returns 响应
 */
export async function updateDisposalInput(data: Record<string, Object | undefined>): Promise<object> {
  return await ApiClient.getInstance().post<object>(PORT, '/updateDisposalInput', data)
}

/**
 * 获取患者的处置项目列表
 * @param registerId - 挂号记录ID
 * @returns 处置项目列表
 */
export async function getDisposalPatientByRegister(registerId: number): Promise<DisposalItem[]> {
  return await ApiClient.getInstance().get<DisposalItem[]>(PORT, '/getDisposalPatient', { register_id: registerId })
}

/**
 * 提交处置申请（分配处置医生）
 * @param data - { id, diaposal_employee_id, item_name }
 * @returns 响应
 */
export async function updataDisposalPatient(data: Record<string, Object | undefined>): Promise<object> {
  return await ApiClient.getInstance().post<object>(PORT, '/updataDisposalPatient', data)
}

/**
 * 获取患者查询列表（分页，管理查询）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getDisposalPatientQuery(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getPatientQuery', params ?? {})
}

/**
 * 根据挂号ID获取患者的处置项目（管理查询）
 * @param registerId - 挂号记录ID
 * @returns 处置项目列表（含分页）
 */
export async function getPatientItemByDisposal(registerId: number): Promise<{ list: DisposalItem[] }> {
  return await ApiClient.getInstance().get<{ list: DisposalItem[] }>(PORT, '/getPatientItemByDisposal', { register_id: registerId })
}
