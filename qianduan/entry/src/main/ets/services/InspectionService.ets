/**
 * @file 检验管理服务
 * 对应 Vue 版 inspection 模块所有 API
 */

import ApiClient from './ApiClient'
import { RestBean } from '../models/RestBean'
import { InspectionItem } from '../models/InspectionItem'

const PORT: number = 8092

/**
 * 获取等待检验患者（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getWaitInspection(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().get<RestBean<object>>(PORT, '/getWaitInspection', params)
}

/**
 * 获取今日已完成检验人数
 * @returns 人数
 */
export async function getFinishInspectionCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getFinishInspectionCount')
  return parseInt(resp) || 0
}

/**
 * 获取等待检验人数
 * @returns 人数
 */
export async function getWaitInspectionCount(): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getWaitInspectionCount')
  return parseInt(resp) || 0
}

/**
 * 获取检验科室列表
 * @returns 科室列表
 */
export async function getInspectionPatientDept(): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getInspectionPatientDept')
}

/**
 * 获取检验医生列表
 * @param deptmentId - 科室ID
 * @returns 医生列表
 */
export async function getInspectionPatientEmp(deptmentId: number): Promise<object[]> {
  return await ApiClient.getInstance().get<object[]>(PORT, '/getInspectionPatientEmp', { deptment_id: deptmentId })
}

/**
 * 获取患者的检验项目列表
 * @param registerId - 挂号记录ID
 * @returns 检验项目列表
 */
export async function getInspectionPatientByRegister(registerId: number): Promise<InspectionItem[]> {
  return await ApiClient.getInstance().get<InspectionItem[]>(PORT, '/getInspectionPatient', { register_id: registerId })
}

/**
 * 提交检验申请（分配检验医生）
 * @param data - { id, inspection_employee_id, item_name }
 * @returns 响应
 */
export async function updataInspectionPatient(data: Record<string, Object | undefined>): Promise<object> {
  return await ApiClient.getInstance().post<object>(PORT, '/updataInspectionPatient', data)
}

/**
 * 根据挂号ID获取患者的检验项目（管理查询）
 * @param registerId - 挂号记录ID
 * @returns 检验项目列表（含分页）
 */
export async function getPatientItemByInspection(registerId: number): Promise<{ list: InspectionItem[] }> {
  return await ApiClient.getInstance().get<{ list: InspectionItem[] }>(PORT, '/getPatientItemByInspection', { register_id: registerId })
}

/**
 * 获取患者查询列表（分页）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getInspectionPatientQuery(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getPatientQuery', params ?? {})
}
