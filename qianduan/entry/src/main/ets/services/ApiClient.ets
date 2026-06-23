/**
 * @file HTTP 请求客户端（单例）
 * 封装 @kit.NetworkKit 的 http 模块，支持 GET/POST
 */

import { http } from '@kit.NetworkKit'
import { promptAction } from '@kit.ArkUI'
import { BASE_URL_8091, BASE_URL_8092 } from '../common/Constants'

class ApiClient {
  private static instance: ApiClient = new ApiClient()

  private constructor() {
    // 私有构造函数，单例模式
  }

  /**
   * 获取 ApiClient 单例
   */
  static getInstance(): ApiClient {
    return ApiClient.instance
  }

  /**
   * 构建完整URL
   */
  private buildUrl(port: number, path: string): string {
    const baseUrl: string = port === 8091 ? BASE_URL_8091 : BASE_URL_8092
    return baseUrl + path
  }

  /**
   * 将对象转为 URL query string
   */
  private toQueryString(params: Record<string, Object | undefined>): string {
    const parts: string[] = []
    const keys: string[] = Object.keys(params)
    for (let i: number = 0; i < keys.length; i++) {
      const key: string = keys[i]
      const val: Object | undefined = params[key]
      if (val != null) {
        parts.push(key + '=' + encodeURIComponent(String(val)))
      }
    }
    return parts.join('&')
  }

  /**
   * 通用 HTTP GET 请求
   */
  async get<T>(port: number, path: string, params?: Record<string, Object | undefined>): Promise<T> {
    let url: string = this.buildUrl(port, path)
    if (params != null) {
      const qs = this.toQueryString(params)
      if (qs.length > 0) {
        url = url + '?' + qs
      }
    }
    try {
      const request = http.createHttp()
      const response = await request.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 15000,
        readTimeout: 15000,
        header: { 'Content-Type': 'application/x-www-form-urlencoded' }
      })
      const data = response.result as T
      request.destroy()
      return data
    } catch (error) {
      promptAction.showToast({ message: '网络请求失败: ' + url, duration: 2000 })
      throw error
    }
  }

  /**
   * 通用 HTTP POST 请求（application/x-www-form-urlencoded）
   */
  async post<T>(port: number, path: string, body: Record<string, Object | undefined>): Promise<T> {
    const url: string = this.buildUrl(port, path)
    const formData: string = this.toUrlEncoded(body)
    try {
      const request = http.createHttp()
      const response = await request.request(url, {
        method: http.RequestMethod.POST,
        connectTimeout: 15000,
        readTimeout: 15000,
        header: { 'Content-Type': 'application/x-www-form-urlencoded' },
        extraData: formData
      })
      const data = response.result as T
      request.destroy()
      return data
    } catch (error) {
      promptAction.showToast({ message: '网络请求失败: ' + url, duration: 2000 })
      throw error
    }
  }

  /**
   * 将对象转为 application/x-www-form-urlencoded 格式
   */
  private toUrlEncoded(body: Record<string, Object | undefined>): string {
    return this.toQueryString(body)
  }
}

export default ApiClient
