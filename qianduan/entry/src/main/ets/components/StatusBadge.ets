2/**
 * @file 状态标签组件
 * 根据状态值显示不同颜色的标记
 */

import { STATUS_COLORS } from '../common/Constants'

@ComponentV2
export struct StatusBadge {
  @Param status: string = ''

  build() {
    Text(this.status)
      .fontSize(12)
      .fontColor(Color.White)
      .backgroundColor(this.getBgColor())
      .borderRadius(4)
      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
  }

  /**
   * 根据状态获取背景色
   * @returns 颜色值
   */
  getBgColor(): ResourceColor {
    const colorStr: string = STATUS_COLORS[this.status.trim()]
    if (colorStr != null) {
      return colorStr
    }
    return '#8c8c8c'
  }
}
