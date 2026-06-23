/**
 * @file 药房管理服务
 * 对应 Vue 版 drugstore 模块所有 API（端口 8091）
 */

import ApiClient from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Drug } from '../models/Drug'
import { PrescriptionDrug } from '../models/Drug'

const PORT: number = 8091

/**
 * 获取已缴费患者列表（发药）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getFinishPricePatient(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getFinishPricePatient', params ?? {})
}

/**
 * 获取患者已缴费药品列表
 * @param registerId - 挂号记录ID
 * @returns 药品列表
 */
export async function getPricePatientDrug(registerId: number): Promise<PrescriptionDrug[]> {
  return await ApiClient.getInstance().get<PrescriptionDrug[]>(PORT, '/getPricePatientDrug', { id: registerId })
}

/**
 * 发药
 * @param id - 药品记录ID
 * @returns 响应消息
 */
export async function givePatientDrugs(id: number): Promise<{ msg: string }> {
  return await ApiClient.getInstance().post<{ msg: string }>(PORT, '/givePatientDrugs', { id: id })
}

/**
 * 获取已发药患者列表（退药）
 * @param params - { case_number, real_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getGivePricePatient(params?: Record<string, Object | undefined>): Promise<RestBean<object>> {
  return await ApiClient.getInstance().post<RestBean<object>>(PORT, '/getGivePricePatient', params ?? {})
}

/**
 * 获取患者已发药药品列表（退药用）
 * @param registerId - 挂号记录ID
 * @returns 药品列表
 */
export async function getGivePatientDrug(registerId: number): Promise<PrescriptionDrug[]> {
  return await ApiClient.getInstance().get<PrescriptionDrug[]>(PORT, '/getGivePatientDrug', { id: registerId })
}

/**
 * 退药
 * @param id - 药品记录ID
 * @returns 响应消息
 */
export async function refundPatientDrugs(id: number): Promise<{ msg: string }> {
  return await ApiClient.getInstance().post<{ msg: string }>(PORT, '/refundPatientDrugs', { id: id })
}

/**
 * 查询药品列表（药库管理）
 * @param params - { drug_code, mnemonic_code, drug_name, nowPageNumber, pageSize }
 * @returns 分页结果
 */
export async function getDrugInfo(params?: Record<string, Object | undefined>): Promise<RestBean<Drug>> {
  return await ApiClient.getInstance().post<RestBean<Drug>>(PORT, '/getDrugInfo', params ?? {})
}

/**
 * 搜索药品（用药选择器）
 * @param keyword - 搜索关键字（药品名称/编码/助记码）
 * @returns 药品列表
 */
export async function searchDrugs(keyword: string): Promise<Drug[]> {
  return await ApiClient.getInstance().get<Drug[]>(PORT, '/getDrugInfo', { drug_name: keyword })
}
