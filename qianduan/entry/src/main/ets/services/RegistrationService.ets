/**
 * @file 挂号收费服务
 * 对应 Vue 版 registration 模块所有 API
 */

import ApiClient from './ApiClient'
import { RestBean, RestBeanMap } from '../models/RestBean'
import { Registration, RegistLevel, Department, Doctor, SettleCategory } from '../models/Registration'
import { ExpenseItem } from '../models/RestBean'

const PORT: number = 8092

/**
 * 新增挂号
 * @param data - 挂号表单数据
 * @returns 响应字符串
 */
export async function addRegister(data: Record<string, Object | undefined>): Promise<string> {
  const resp = await ApiClient.getInstance().post<string>(PORT, '/addRegister', data)
  return resp
}

/**
 * 退号
 * @param registId - 挂号记录ID
 * @returns 响应字符串
 */
export async function refundMedicalRecord(registId: number): Promise<string> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/refundMedicalRecord', { id: registId })
  return resp
}

/**
 * 查询可退号患者列表（分页）
 * @param params - 查询参数
 * @returns 分页结果
 */
export async function getRecordRefundPatient(params?: Record<string, Object | undefined>): Promise<RestBean<Registration>> {
  return await ApiClient.getInstance().get<RestBean<Registration>>(PORT, '/getRecordRefundPatient', params)
}

/**
 * 查询医生已挂号数量
 * @param params - { visitDate, noon, employeeId }
 * @returns 已用号额
 */
export async function getAlreadyRegisterCount(params?: Record<string, Object | undefined>): Promise<number> {
  const resp = await ApiClient.getInstance().get<string>(PORT, '/getAlreadyRegisterCount', params)
  return parseInt(resp) || 0
}

/**
 * 查询科室医生列表（按科室+号别）
 * @param params - { deptment_id, regist_level_id }
 * @returns 医生列表
 */
export async function getRegistDoctorList(params?: Record<string, Object | undefined>): Promise<Doctor[]> {
  return await ApiClient.getInstance().get<Doctor[]>(PORT, '/getRegistDoctorList', params)
}

/**
 * 查询挂号级别列表
 * @returns 挂号级别列表
 */
export async function getRegistLevelList(): Promise<RegistLevel[]> {
  return await ApiClient.getInstance().get<RegistLevel[]>(PORT, '/getRegistLevelList')
}

/**
 * 查询所有科室列表
 * @returns 科室列表
 */
export async function getAllDeptList(): Promise<Department[]> {
  return await ApiClient.getInstance().get<Department[]>(PORT, '/getAllDeptList')
}

/**
 * 查询结算类别列表
 * @returns 结算类别列表
 */
export async function getSettleCategory(): Promise<SettleCategory[]> {
  return await ApiClient.getInstance().get<SettleCategory[]>(PORT, '/getSettleCategory')
}

/**
 * 获取最大病历号
 * @returns 最大病历号字符串
 */
export async function getMaxCaseNumber(): Promise<string> {
  return await ApiClient.getInstance().get<string>(PORT, '/getMaxCaseNumber')
}

/**
 * 收费结算
 * @param data - 收费项目数据
 * @returns RestBeanMap 响应
 */
export async function expenseCharge(data: Record<string, Object | undefined>): Promise<RestBeanMap> {
  return await ApiClient.getInstance().post<RestBeanMap>(PORT, '/expenseCharge', data)
}

/**
 * 退费结算
 * @param data - 退费项目数据
 * @returns RestBeanMap 响应
 */
export async function expenseRefund(data: Record<string, Object | undefined>): Promise<RestBeanMap> {
  return await ApiClient.getInstance().post<RestBeanMap>(PORT, '/expenseRefund', data)
}

/**
 * 查询待收费患者
 * @param params - 查询参数
 * @returns RestBeanMap
 */
export async function searchExpenseChargePatient(params?: Record<string, Object | undefined>): Promise<RestBeanMap> {
  return await ApiClient.getInstance().get<RestBeanMap>(PORT, '/searchExpenseChargePatient', params)
}

/**
 * 查询待退费患者
 * @param params - 查询参数
 * @returns RestBeanMap
 */
export async function searchExpenseRefundPatient(params?: Record<string, Object | undefined>): Promise<RestBeanMap> {
  return await ApiClient.getInstance().get<RestBeanMap>(PORT, '/searchExpenseRefundPatient', params)
}

/**
 * 查询患者全部费用记录
 * @param params - 查询参数
 * @returns RestBeanMap
 */
export async function searchAllPricePatient(params?: Record<string, Object | undefined>): Promise<RestBeanMap> {
  return await ApiClient.getInstance().get<RestBeanMap>(PORT, '/searchAllPricePatient', params)
}
