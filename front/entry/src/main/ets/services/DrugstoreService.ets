import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Drug } from '../models/Drug'

export class DrugstoreService {
  private static api: ApiClient = ApiClient.getInstance()

  static async getDrugInfo(params: HttpParams): Promise<RestBean<Drug>> {
    return DrugstoreService.api.post<Drug>(8091, '/getDrugInfo', params)
  }

  static async getFinishPricePatient(params: HttpParams): Promise<RestBean<Drug>> {
    return DrugstoreService.api.post<Drug>(8091, '/getFinishPricePatient', params)
  }

  static async getPricePatientDrug(registId: string): Promise<RestBean<Drug>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return DrugstoreService.api.get<Drug>(8091, '/getPricePatientDrug', params)
  }

  static async givePatientDrugs(data: HttpParams): Promise<RestBean<void>> {
    return DrugstoreService.api.post<void>(8091, '/givePatientDrugs', data)
  }

  static async getGivePricePatient(params: HttpParams): Promise<RestBean<void>> {
    return DrugstoreService.api.post<void>(8091, '/getGivePricePatient', params)
  }

  static async getGivePatientDrug(registId: string): Promise<RestBean<void>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return DrugstoreService.api.get<void>(8091, '/getGivePatientDrug', params)
  }

  static async refundPatientDrugs(data: HttpParams): Promise<RestBean<void>> {
    return DrugstoreService.api.post<void>(8091, '/refundPatientDrugs', data)
  }
}
