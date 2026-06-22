import { ApiClient, HttpParams } from './ApiClient'
import { RestBean } from '../models/RestBean'
import { Patient } from '../models/Patient'
import { Registration } from '../models/Registration'

export class PhysicianService {
  private static api: ApiClient = ApiClient.getInstance()

  static async getWaitPatient(): Promise<RestBean<Patient>> {
    return PhysicianService.api.get<Patient>(8092, '/getWaitPatient')
  }

  static async getFinishPatientCount(): Promise<RestBean<Patient>> {
    return PhysicianService.api.get<Patient>(8092, '/getFinishPatientCount')
  }

  static async getWaitPatientCount(): Promise<RestBean<Patient>> {
    return PhysicianService.api.get<Patient>(8092, '/getWaitPatientCount')
  }

  static async treatPatient(registId: string): Promise<RestBean<Registration>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return PhysicianService.api.get<Registration>(8092, '/treatPatient', params)
  }

  static async getCheckedPatient(params: HttpParams): Promise<RestBean<Registration>> {
    return PhysicianService.api.post<Registration>(8092, '/getCheckedPatient', params)
  }

  static async getDisease(params: HttpParams): Promise<RestBean<Registration>> {
    return PhysicianService.api.post<Registration>(8092, '/getDisease', params)
  }

  static async addHomeMedicalRecord(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/addHomeMedicalRecord', data)
  }

  static async outpatientDiagnosis(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/outpatientDiagnosis', data)
  }

  static async addCheckRequest(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/addCheckRequest', data)
  }

  static async getCheck(params: HttpParams): Promise<RestBean<Registration>> {
    return PhysicianService.api.post<Registration>(8092, '/getCheck', params)
  }

  static async getCheckPatientTableByRegist(registId: string): Promise<RestBean<Patient>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return PhysicianService.api.get<Patient>(8092, '/getCheckPatientTableByRegist', params)
  }

  static async addInspectionRequest(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/addInspectionRequest', data)
  }

  static async getInspection(params: HttpParams): Promise<RestBean<Registration>> {
    return PhysicianService.api.post<Registration>(8092, '/getInspection', params)
  }

  static async addDisposalRequest(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/addDisposalRequest', data)
  }

  static async getDisposal(params: HttpParams): Promise<RestBean<Registration>> {
    return PhysicianService.api.post<Registration>(8092, '/getDisposal', params)
  }

  static async addPrescription(data: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/addPrescription', data)
  }

  static async searchDrug(params: HttpParams): Promise<RestBean<void>> {
    return PhysicianService.api.post<void>(8092, '/searchDrug', params)
  }

  static async getPatientItemByPhysician(registId: string): Promise<RestBean<Patient>> {
    const params: HttpParams = new HttpParams()
    params.add('registId', registId)
    return PhysicianService.api.get<Patient>(8092, '/getPatientItemByPhysician', params)
  }
}
