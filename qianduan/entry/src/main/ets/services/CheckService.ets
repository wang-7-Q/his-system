/**
 * @file 检查管理服务
 * 对应 Vue 版 check 模块所有 API
 */

import ApiClient from './ApiClient'
import { RestBean } from '../models/RestBean'
import { CheckItem } from '../models/CheckItem'

const PORT: number = 8092

/**
 * 获取等待检查患者（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getWaitCheck(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().get<RestBean<object>>(PORT, '/getWaitCheck', params)
}

/**
 * 获取今日已完成检查人数
 * @returns 人数
 */
export async function getFinishCheckCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getFinishCheckCount')
  return parseInt(resp) || 0
}

/**
 * 获取等待检查人数
 * @returns 人数
 */
export async function getWaitCheckCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getWaitCheckCount')
  return parseInt(resp) || 0
}

/**
 * 获取已检查/待录入结果患者（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getFinishCheck(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getFinishCheck', params ?? {})
}

/**
 * 根据挂号ID获取该患者的检查项目
 * @param registerId - 挂号记录ID
 * @returns 检查项目列表
 */
export async function getFinishCheckByRegistid(registerId: number): Promise<CheckItem[]> {
  return await ApiClient.getInstance().get<CheckItem[]>(PORT, '/getFinishCheckByRegistid', { id: registerId })
}

/**
 * 获取检查科室列表
 * @returns 科室列表
 */
export async function getCheckPatientDept(): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getCheckPatientDept')
}

/**
 * 获取检查医生列表
 * @param deptmentId - 科室ID
 * @returns 医生列表
 */
export async function getCheckPatientEmp(deptmentId: number): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getCheckPatientEmp', { deptment_id: deptmentId })
}

/**
 * 更新检查结果
 * @param data - { check_result, id, employee_id }
 * @returns 响应
 */
export async function updateCheckInput(data: Record<string, Object | undefined>): Promise<object> {
  return await ApiClient.getInstance().post<object>(PORT, '/updateCheckInput', data)
}

/**
 * 获取患者的检查项目列表
 * @param registerId - 挂号记录ID
 * @returns 检查项目列表
 */
export async function getCheckPatientByRegister(registerId: number): Promise<CheckItem[]> {
  return await ApiClient.getInstance().get<CheckItem[]>(PORT, '/getCheckPatient', { register_id: registerId })
}

/**
 * 提交检查申请（分配检查医生）
 * @param data - { id, check_employee_id, item_name }
 * @returns 响应
 */
export async function updataCheckPatient(data: Record<string, Object | undefined>): Promise<object> {
  return await ApiClient.getInstance().post<object>(PORT, '/updataCheckPatient', data)
}

/**
 * 获取患者查询列表（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getPatientQuery(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getPatientQuery', params ?? {})
}

/**
 * 根据挂号ID获取患者的检查项目（管理查询）
 * @param registerId - 挂号记录ID
 * @returns 检查项目列表（含分页）
 */
export async function getPatientItemByCheck(registerId: number): Promise<{ list: CheckItem[] }> {
  return await ApiClient.getInstance().get<{ list: CheckItem[] }>(PORT, '/getPatientItemByCheck', { register_id: registerId })
}
